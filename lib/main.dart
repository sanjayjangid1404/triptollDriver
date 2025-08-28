import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
// import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taxi_driver/common/appContants.dart';
import 'package:taxi_driver/controller/authController.dart';
// import 'package:workmanager/workmanager.dart';
import 'common/background_service.dart';
import 'common/driver_notification_service.dart';
import 'common/get_di.dart' as di;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common/db_helper.dart';
import 'package:taxi_driver/common/globs.dart';
import 'package:taxi_driver/common/my_http_overrides.dart';
import 'package:taxi_driver/common/service_call.dart';
import 'package:taxi_driver/common/socket_manager.dart';
import 'package:taxi_driver/cubit/login_cubit.dart';
import 'package:taxi_driver/view/login/splash_view.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'common/route_helper.dart';

SharedPreferences? prefs;
final AudioPlayer player = AudioPlayer();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> showNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'location_tracker_channel',
    'Location Tracker Notifications',
    channelDescription: 'Channel for location-based notifications',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('booking'), // 🔔 custom sound
  );

  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    'New Booking - Triptoll',
    'You have a new booking!',
    platformChannelSpecifics,
  );
}



// Background service handler


// iOS background callback
@pragma('vm:entry-point')
Future<bool> onIosBackground() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return true;
}

// Play sound in background
Future<void> playSoundInBackground() async {
  try {
    final player = AudioPlayer();
   // await player.setReleaseMode(ReleaseMode.loop);

    // Play sound for 15 seconds (adjust as needed)
    await player.play(AssetSource("sounds/booking.mp3"), volume: 1.0);
    await Future.delayed(Duration(seconds: 15));
    await player.stop();
    await player.dispose();
  } catch (e) {
    print("Error playing sound in background: $e");
  }
}

Future<void> setupFirebaseMessaging() async {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request notification permissions
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // Handle background messages


  // Handle messages when the app is in the foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Foreground message received: ${message.data}');

    // Play sound immediately for foreground notifications
    playSound();
  });

  // Handle when the app is opened from a terminated state
  RemoteMessage? initialMessage = await messaging.getInitialMessage();
  if (initialMessage != null) {
    _handleMessage(initialMessage);
  }

  // Handle when the app is in the background and opened from a notification
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
}


@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background message received: ${message.notification?.title}");

  // Sound play

  //await player.setReleaseMode(ReleaseMode.loop);

  await player.play(AssetSource("sounds/booking.mp3"));

  // ✅ App open करने के लिए
  if (Platform.isAndroid) {
    final service = FlutterBackgroundService();
    service.invoke("openApp");
  }
}

void _handleMessage(RemoteMessage message) {
  print('Notification opened app: ${message.data}');
  // Play sound when notification opens the app
  playSound();
}

// Function to play sound in foreground
Future<void> playSound() async {
  try {

    await player.setReleaseMode(ReleaseMode.loop);
    await player.play(AssetSource("sounds/booking.mp3"), volume: 1.0);

    // Stop after 15 seconds (adjust as needed)
    // Future.delayed(Duration(seconds: 15), () async {
    //   await player.stop();
    //   await player.dispose();
    // });
  } catch (e) {
    print("Error playing sound: $e");
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  DBHelper.shared().db;
  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await _handleLocationPermissions();
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher'); // आपकी app icon
  const InitializationSettings initializationSettings =
  InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // 2. Only start service if permissions are granted
  if (await _checkLocationPermissionGranted()) {
    await initializeService();
  } else {
    await _handleLocationPermissions();
    // Show alert that features won't work without permissions
  }

  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();

    }
  });

  await DriverNotificationService.initialize();
  if (Globs.udValueBool(Globs.userLogin)) {
    ServiceCall.userObj = Globs.udValue(Globs.userPayload) as Map? ?? {};
    ServiceCall.userType = ServiceCall.userObj["user_type"] as int? ?? 1;
  }


  runApp(const MyApp());
  configLoading();
  ServiceCall.getStaticDateApi();
}




Future<bool> _checkLocationPermissionGranted() async {
  final status = await Geolocator.checkPermission();
  return status == LocationPermission.always || status == LocationPermission.whileInUse;
}

Future<void> _handleLocationPermissions() async {
  // Check if location services are enabled
  if (!await Geolocator.isLocationServiceEnabled()) {
    // Optionally show dialog prompting user to enable
    return;
  }

  // Check current permission status
  var permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Optionally open app settings so user can enable manually
    await openAppSettings();
    return;
  }
}






// void headlessTask(bg.HeadlessEvent headlessEvent) async {
//   if (headlessEvent.name == bg.Event.LOCATION) {
//     bg.Location location = headlessEvent.event;
//     // You might want to handle headless location updates here
//     print('[HeadlessTask] - Location: $location');
//   }
// }




void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 5.0
    ..progressColor = TColor.primaryText
    ..backgroundColor = TColor.primary
    ..indicatorColor = Colors.white
    ..textColor = TColor.primaryText
    ..userInteractions = false
    ..dismissOnTap = false;
}

Future<void> stopRingtone() async {
  await player.stop();
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyApp();

  // This widget is the root of your application.

}

class _MyApp extends State<MyApp> {

  String? referralCode;
  String? installedViaReferral;


  @override
  void dispose() {

    super.dispose();
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();





  // Handle the deep link containing referral code


  @override
  void initState() {
    // TODO: implement initState
    super.initState();



    AppContants.getToken();
     var initialzationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

     if(Get.find<AuthController>().isLoggedIn()){
       Get.find<AuthController>().getBookingNotification(context);
     }

    var initialzationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,);
    var initializationSettings =
    InitializationSettings(android: initialzationSettingsAndroid,iOS: initialzationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);


    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {

        await showNotification();
        if(notification.title!.toLowerCase().contains("new booking - triptoll")){

          await player.setReleaseMode(ReleaseMode.loop);
          await player.play(AssetSource("sounds/booking.mp3"), volume: 1.0,);

        }
        print("onMessage: ${notification.title}/${notification.body}/${notification.titleLocKey}");
        print("onMessage type: ${message.data['type']}/${message.data}");




        // Check if 'type' key exists in message data

        flutterLocalNotificationsPlugin.show(
          notification.hashCode, // id
          notification.title,    // title
          notification.body,     // body
          NotificationDetails(   // notification details
            android: AndroidNotificationDetails(
              'channel_id',
              'channel_name',
              channelDescription: 'your channel description',
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          payload: "", // optional data
        );




      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        print("onMessage: ${notification.title}/${notification.body}/${notification.titleLocKey}");
        print("onMessage type: ${message.data['type']}/${message.data}");

      if(notification.title!.toLowerCase().contains("new booking - triptoll")){

        await player.setReleaseMode(ReleaseMode.loop);
        await player.play(AssetSource("sounds/booking.mp3"), volume: 1.0);
      }
      flutterLocalNotificationsPlugin.show(
        notification.hashCode, // id
        notification.title,    // title
        notification.body,     // body
        NotificationDetails(   // notification details
          android: AndroidNotificationDetails(
            'channel_id',
            'channel_name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        payload: "", // optional data
      );


      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Taxi Driver',
      navigatorKey: Get.key,
      getPages: RouteHelper.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "NunitoSans",
        scaffoldBackgroundColor: TColor.bg,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: TColor.primary),
        useMaterial3: false,
      ),
      home: const SplashView(),
      builder: EasyLoading.init(),
    );
  }
}


