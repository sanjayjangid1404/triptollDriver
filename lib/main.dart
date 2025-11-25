import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
// import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:android_intent_plus/android_intent.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
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
import 'language/local_string.dart';


class OverlayHelper {
  static const platform = MethodChannel("service.triptoll.in/overlay");

  static Future<void> bringAppToFront() async {
    try {
      await platform.invokeMethod("bringToFront");
    } catch (e) {
      print("Overlay errordfjdf: $e");
    }
  }
  static Future<void> bringToFrontCustom() async {
    try {
      await platform.invokeMethod('bringToFrontCustom');
    } catch (e) {
      print("Error bringToFrontCustom: $e");
    }
  }
}
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
    sound: RawResourceAndroidNotificationSound('booking'),
    timeoutAfter: 30000,
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
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Sound play

  //await player.setReleaseMode(ReleaseMode.loop);

  await player.play(AssetSource("sounds/booking.mp3"));
  Future.delayed(const Duration(seconds: 60), () async {
    await flutterLocalNotificationsPlugin.cancelAll();
    await stopRingtone();
  });

  if (Platform.isAndroid) {
    await bringAppToFront();
  }
  // ✅ App open करने के लिए
  // if (Platform.isAndroid) {
  //   final service = FlutterBackgroundService();
  //   service.invoke("openApp");
  // }
}

Future<void> bringAppToFront() async {
  const platform = MethodChannel('service.triptoll.in/main_overlay');

  try {
    await platform.invokeMethod('bringToFrontMain');
    print("✅ bringToFrontCustom executed successfully");
  } catch (e) {
    print("⚠️ bringToFrontCustom failed: $e");
    print("➡️ Trying fallback intent...");

    try {
      final intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        package: 'service.triptoll.in',
        componentName: '.MainActivity',
        category: 'android.intent.category.LAUNCHER',
        flags: <int>[
          268435456, // FLAG_ACTIVITY_NEW_TASK
          67108864,  // FLAG_ACTIVITY_CLEAR_TOP
        ],
      );
      await intent.launch();
      print("✅ App launched via Intent");
    } catch (err) {
      print("❌ Intent launch failed: $err");
    }
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
  final port = ReceivePort();
  IsolateNameServer.registerPortWithName(port.sendPort, "overlay_channel");

  port.listen((message) {
    if (message == "bringToFront") {
      OverlayHelper.bringAppToFront();
    }
  });
  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
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
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  FlutterOverlayWindow.overlayListener.listen((event) async {
    if (event == "open_app") {
      await FlutterOverlayWindow.closeOverlay();
      FlutterOverlayWindow.showOverlay();
    }
  });
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

class _MyApp extends State<MyApp>  with WidgetsBindingObserver{

  String? referralCode;
  String? installedViaReferral;


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();





  Future<void> _checkOverlayPermission() async {
    bool granted = await FlutterOverlayWindow.isPermissionGranted();
    if (!granted) {
      await FlutterOverlayWindow.requestPermission();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _checkOverlayPermission();

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


        // ✅ Timestamp condition
        final int now = DateTime.now().millisecondsSinceEpoch;
        final String? tsString = message.data['timestamp'];
        int? sentTime = int.tryParse(tsString ?? '');
        if (sentTime != null && (now - sentTime) <= 30000) {
          // Play ringtone only if <= 30 seconds old
          await showNotification();
          if (notification.title!
              .toLowerCase()
              .contains("new booking - triptoll")) {
            await player.setReleaseMode(ReleaseMode.loop);
            await player.play(
              AssetSource("sounds/booking.mp3"),
              volume: 1.0,
            );
          }
        } else {
          debugPrint("⏳ Skipping music: notification too old or invalid timestamp");
        }

        print("onMessage: ${notification.title}/${notification.body}/${notification.titleLocKey}");
        print("onMessage data: ${message.data}");
        print("onMessage timestamp: ${message.data['timestamp']}");

        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'channel_id',
              'channel_name',
              channelDescription: 'your channel description',
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          payload: "",
        );
      }
    });


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        print("onMessageOpenedApp: ${notification.title}/${notification.body}/${notification.titleLocKey}");
        print("onMessageOpenedApp data: ${message.data}");
        print("onMessageOpenedApp timestamp: ${message.data['timestamp']}");

        // ✅ Timestamp condition
        final int now = DateTime.now().millisecondsSinceEpoch;
        final String? tsString = message.data['timestamp'];
        int? sentTime = int.tryParse(tsString ?? '');
        if (sentTime != null && (now - sentTime) <= 30000) {
          if (notification.title!
              .toLowerCase()
              .contains("new booking - triptoll")) {
            await player.setReleaseMode(ReleaseMode.loop);
            await player.play(
              AssetSource("sounds/booking.mp3"),
              volume: 1.0,
            );
          }
        } else {
          debugPrint("⏳ Skipping music: notification too old or invalid timestamp");
        }

        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'channel_id',
              'channel_name',
              channelDescription: 'your channel description',
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          payload: "",
        );
      }
    });
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (Platform.isAndroid) {
      if (state == AppLifecycleState.paused) {
        _showOverlay();
      } else if (state == AppLifecycleState.resumed) {
        FlutterOverlayWindow.closeOverlay();
      }
    }
  }

  Future<void> _showOverlay() async {
    bool? granted = await FlutterOverlayWindow.isPermissionGranted();
    if (!granted) {
      granted = await FlutterOverlayWindow.requestPermission();
    }
    if (granted == true) {
      await FlutterOverlayWindow.showOverlay(
        height: 100,
        width: 100,
        alignment: OverlayAlignment.centerRight,
        flag: OverlayFlag.defaultFlag,
        // flag: OverlayFlag.focusPointer,
        enableDrag: true,
      );
    } else {
      debugPrint("Overlay permission not granted");
    }
  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Taxi Driver',
      translations: LocaleString(),
      locale: const Locale('en','US'),
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


@pragma('vm:entry-point')
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () {
            // 🔥 Direct MethodChannel mat call kar
            final sendPort = IsolateNameServer.lookupPortByName("overlay_channel");
            sendPort?.send("bringToFront");
          },
          child: Center(
            child: Container(
              height: 80,
              width: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              padding: EdgeInsets.all(7),
              child: Image.asset("assets/img/flot.jpg", height: 20,
                width: 20,),
            ),
          ),
        ),
      ),
    ),
  );
}

