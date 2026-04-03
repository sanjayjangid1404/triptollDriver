import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_driver/common/appContants.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

io.Socket? socket;

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  // Notification channel setup
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'location_tracker_channel', // id
    'Location Tracker', // title
    description: 'Tracking your location every 3 seconds',
    importance: Importance.low,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'location_tracker_channel',
      initialNotificationTitle: 'Location Tracker',
      initialNotificationContent: 'Initializing location tracking...',
      foregroundServiceNotificationId: 888,
      foregroundServiceTypes: [AndroidForegroundType.location],


    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString(AppContants.token) ?? '';

  socket = io.io('ws://triptoll.in:3000', {
    "transports": ["websocket"],
    "autoConnect": false,
    "reconnection": true,
    "reconnectionAttempts": 10,
    "reconnectionDelay": 2000,
    "extraHeaders": {"authorization": token}
  });

  socket!.connect();

  socket!.onConnect((_) {
    print("✅ BG Socket Connected");
  });

  socket!.onDisconnect((_) {
    print("❌ BG Socket Disconnected");
  });
  final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Check and request location permissions
  bool serviceEnabled = await geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return;
  }

  LocationPermission permission = await geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return;
    }
  }

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    socket?.disconnect();   // ✅ add
    socket?.dispose();
    service.stopSelf();
  });

  var initialzationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  var initialzationSettingsIOS =
  DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,);
  var initializationSettings =
  InitializationSettings(android: initialzationSettingsAndroid,iOS: initialzationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  Timer.periodic(const Duration(seconds: 6), (timer) async {
    try {
      if (service is AndroidServiceInstance && !await service.isForegroundService()) {
        return;
      }
      Position position = await geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.bestForNavigation),

      );
      await prefs.reload();
      debugPrint("callingLocation");
      print("callingLocation");
      String? userId = prefs.getString(AppContants.userID);
      String? bookingID = prefs.getString(AppContants.bookingID);

      if (userId != null && userId.isNotEmpty) {
        // await _sendLocationToServer(userId,position.latitude, position.longitude,bookingID);
        String? driverStatus = await getDriverStatus();
        print("🔥 BG DRIVER STATUS: $driverStatus");
        if (socket?.connected == true &&
            userId.toString().trim().isNotEmpty) {
          socket?.emitWithAck(
            "driverLocation",
            {
              "driver_id": userId,
              "lat": position.latitude,
              "lng": position.longitude,
              "booking_id" : bookingID ?? "0",
              "login_status" :  driverStatus ?? "online",
            },
            ack: (response) {
              if (kDebugMode) {
                print("Server response background: $response");
              }

              if (response == null) {
                if (kDebugMode) {
                  print("❌ No response from server");
                }
                return;
              }

              if (response["status"] == "success") {
                if (kDebugMode) {
                  print("✅ Success: ${response["message"]}");
                }
              } else {
                if (kDebugMode) {
                  print("❌ Error: ${response["message"]}");
                }
              }
            },
          );
          final payload = {
            "lat": position.latitude,
            "lng": position.longitude,
            "driver_id": userId,
            "booking_id": bookingID ?? "0",
            "login_status": driverStatus ?? "online",
            // "location_time": DateTime.now().toIso8601String(),
          };
          if (kDebugMode) {
            print("📤 DRIVER LOCATION PAYLOAD: $payload");
          }
          // socket!.emit("driverLocation", {
          //   "lat": position.latitude,
          //   "lng": position.longitude,
          //   "driver_id": userId,
          //   // "booking_id": bookingID ?? "0",
          //   // "driver_status": driverStatus ?? "online",
          //   // "location_time": DateTime.now().toIso8601String(),
          // });
          // final payload = {
          //   "lat": position.latitude,
          //   "lng": position.longitude,
          //   "driver_id": userId,
          //   // "booking_id": bookingID ?? "0",
          //   // "driver_status": driverStatus ?? "online",
          //   // "location_time": DateTime.now().toIso8601String(),
          // };
          print("📤 BG Location Sent: ${position.latitude}, ${position.longitude},${userId.toString()}");

        }
        else {
          print("❌ Socket not connected background");
        }
      }
      // Send to server


      // Update notification
      // if (service is AndroidServiceInstance) {
      //   flutterLocalNotificationsPlugin.show(
      //     888,
      //     'Location Updated',
      //     'Lat: ${position.latitude.toStringAsFixed(4)}, Lng: ${position.longitude.toStringAsFixed(4)}',
      //     const NotificationDetails(
      //       android: AndroidNotificationDetails(
      //         'location_tracker_channel',
      //         'Location Tracker',
      //         icon: 'ic_bg_service_small',
      //         ongoing: true,
      //       ),
      //     ),
      //   );
      //
      //   // service.setForegroundNotificationInfo(
      //   //   title: "Location Tracker",
      //   //   content: "Updated at ${DateTime.now().toString().substring(11, 19)}",
      //   // );
      // }

      // debugPrint('Location Update: ${position.latitude}, ${position.longitude} at ${DateTime.now()}');

    } catch (e) {
      debugPrint('Location Error: $e');
    }
  });
}
Future<String?> getDriverStatus() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  return prefs.getString('driver_status');
}



// api code comment by him for socket code
// Future<void> _sendLocationToServer(String? userID,double lat, double lng,String? bookingID) async {
//
//   debugPrint("callingLocation");
//   print("callingLocation");
//   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//   String? token = sharedPreferences.getString(AppContants.token);
//   try {
//
//
//     print('${AppContants.baseURl}${AppContants.updateDriverLocation}');
//     print('location update backGround:${jsonEncode({
//       'lat': lat.toStringAsFixed(14),
//       'long': lng.toStringAsFixed(14),
//       "user_id": userID,
//       "booking_id": bookingID??"0",
//       "driver_status": getDriverStatus(),
//       "location_time":DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),})}');
//     final response = await http.post(
//       Uri.parse('${AppContants.baseURl}${AppContants.updateDriverLocation}'),
//       headers: {
//         'Content-Type': 'application/json',
//         "Authorization":"$token"
//
//       },
//       body: jsonEncode({
//         'lat': lat.toStringAsFixed(14),
//         'long': lng.toStringAsFixed(14),
//         'user_id': userID,
//         "booking_id": bookingID??"0",
//         "driver_status": getDriverStatus(),
//         "location_time": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
//       }),
//
//     );
//     print("Location Response${response.body}");
//
//     if (response.statusCode != 200) {
//       debugPrint('Failed to send location: ${response.statusCode}');
//     }
//   } catch (e) {
//     debugPrint('Error sending location: $e');
//   }
// }

