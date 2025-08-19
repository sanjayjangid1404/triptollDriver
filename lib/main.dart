import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
// import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
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

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();


  DBHelper.shared().db;


  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  await _handleLocationPermissions();

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyApp();

  // This widget is the root of your application.

}

class _MyApp extends State<MyApp> {


  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    AppContants.getToken();
     var initialzationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/logo');

    var initialzationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,);
    var initializationSettings =
    InitializationSettings(android: initialzationSettingsAndroid,iOS: initialzationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        if (kDebugMode) {
          print("onMessage: ${notification.title}/${notification.body}/${notification.titleLocKey}");
          print("onMessage type: ${message.data['type']}/${message.data}");
        }



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

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {


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
