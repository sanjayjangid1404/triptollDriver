import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:taxi_driver/common/custom_snackbar.dart';
import '../common/appContants.dart';
import '../controller/authController.dart';
import '../model/booking_notification_response.dart';


class ChatController extends GetxController {

  Rxn<Data> newBookingSocket = Rxn<Data>();
  io.Socket? socket;
  Set<int> shownBookingIds = {};
  Future<void> connectToServer() async {
    if (socket?.connected == true) {
      log("Already connected");
      return;
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString(AppContants.token) ?? '';

    if (token.isEmpty) {
      log("❌ Token missing");
      return;
    }

    socket?.disconnect();
    socket?.dispose();

    socket = io.io('ws://triptoll.in:3000', {
      "transports": ["websocket"],
      "autoConnect": false,
      "reconnection": true,
      "reconnectionAttempts": 10,
      "reconnectionDelay": 2000,
      "reconnectionDelayMax": 10000,
      "extraHeaders": {"authorization": token}
    });

    socket!.onConnect((_) async {
      log('✅ Connected with server');
      showCustomSnackBar('✅ Connected with server',isError: false,getXSnackBar: true);
      socket!.off("newBooking");
      socket!.off("forceLogout");
      socket!.off("deviceStatus");
      socket!.off("bookingAccepted");
      socket!.off("bookingTaken");
      socket!.off("scheduledReminder");
      socket!.off("tripStarted");
      socket!.off("activeBooking");
      socket!.off("tripEnded");
      socket!.on("forceLogout", (data) {
        if (kDebugMode) {
          print("📡 forceLogout status: $data");
        }

        if (data != null && data["message"] == "Logged in from another device"){
          showCustomSnackBar(
            data["message"],
            getXSnackBar: true,
            isError: true,
          );
          Get.find<AuthController>().logoutUser();
          socket?.clearListeners();
          socket?.disconnect();
          socket?.dispose();
          socket = null;
        }else{
          if (kDebugMode) {
            print("logout socket else part");
          }
        }
      });
      socket!.on("deviceStatus", (data) {
        if (kDebugMode) {
          print("📡 Device status: $data");
        }

        if (data != null && data["status"] == true) {
        }else{
          if (kDebugMode) {
            print("logout socket else part");
          }
        }
      });
      socket!.on("newBooking", (data) async {
        if (kDebugMode) {
          print("📡 newBooking status: $data");
        }

        if (data != null && data["status"] == true && data["data"] != null) {
          var booking = data["data"][0];

          try {
            var bookingData = Data.fromJson(booking);
            int bookingId = int.tryParse(bookingData.bookingId.toString()) ?? 0;
            newBookingSocket.value = bookingData;
            // if (!shownBookingIds.contains(bookingId)) {
            //   shownBookingIds.add(bookingId);
            //   final prefs = await SharedPreferences.getInstance();
            //   await prefs.setString(AppContants.bookingID, bookingId.toString());
            //   newBookingSocket.value = bookingData;
            // }

          } catch (e) {
            print("❌ parsing error: $e");
          }

        } else {
          print("❌ new_booking else part");
        }
      });
      socket!.on("bookingAccepted", (data) async {
        if (kDebugMode) {
          print("📡 bookingAccepted status: $data");
        }

      });
      socket!.on("bookingTaken", (data) async {
        if (kDebugMode) {
          print("📡 bookingTaken status: $data");
        }

      });
      Set<int> shownBookingIds = {};
      socket!.on("scheduledReminder", (data) async {
        if (kDebugMode) {
          print("📡 scheduledReminder status: $data");
        }
        if (data != null && data['status'] == true) {
          var bookings = data['data'];

          if (bookings != null && bookings.isNotEmpty) {

            for (var booking in bookings) {
              int bookingId =
                  int.tryParse(booking['booking_id'].toString()) ?? 0;


              if (!shownBookingIds.contains(bookingId)) {
                shownBookingIds.add(bookingId);
                Get.find<AuthController>().setBookingId(bookingId);

                if (kDebugMode) {
                  print("✅ New Booking Saved: $bookingId");
                }

                // 👉 yaha tu popup / notification bhi trigger kar sakta hai
              } else {
                if (kDebugMode) {
                  print("⚠️ Duplicate Booking Ignored: $bookingId");
                }
              }
            }
          }
        }
      });
      socket!.on("updateStatus", (data) async {
        if (kDebugMode) {
          print("📡 updateStatus status: $data");
        }

      });
      socket!.on("nextDrop", (data) async {
        if (kDebugMode) {
          print("📡 nextDrop status: $data");
        }

      });
      socket!.on("tripStarted", (data) {
        if (kDebugMode) {
          print("📡 tripStarted status: $data");
        }
      });

      socket!.on("activeBooking", (data) {
        if (kDebugMode) {
          print("📡 activeBooking status: $data");
        }

      });

      socket!.on("tripEnded", (data) {
        if (kDebugMode) {
          print("📡 tripEnded status: $data");
        }
      });
      await sendDeviceData();
    });
    socket!.onReconnectFailed((_) {
      log("❌ Reconnection Failed after 10 attempts");

      showCustomSnackBar(
        "Network issue. Please login again.",
        getXSnackBar: true,
        isError: true,
      );

      Get.find<AuthController>().logoutUser();

      socket?.clearListeners();
      socket?.disconnect();
      socket?.dispose();
      socket = null;
    });
    socket!.onDisconnect((_) {
      log('❌ Disconnected');
    });

    socket!.onConnectError((data) {
      log("❌ Connect Error: $data");
    });

    socket!.onError((data) {
      log("❌ Error: $data");
    });

    socket!.onReconnect((_) async {
      log("🔁 Reconnected");

      await sendDeviceData();
    });

    socket!.connect();
  }
  Future<void> sendDeviceData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userID = pref.getString(AppContants.userID) ?? '';

    if (socket?.connected != true) return;

    final payload = {
      "driver_id": userID.toString(),
      "device_token": Get.find<AuthController>().deviceId.toString()
    };

    socket?.emitWithAck("registerDriverDevice", payload, ack: (res) {
      print("registerDriverDevice: $res");
    });

    socket?.emitWithAck("startDeviceMonitor", payload, ack: (res) {
      print("startDeviceMonitor: $res");
    });
    socket?.emitWithAck("restoreTrip", {
      "driver_id": userID.toString()
    },
      ack: (res) {
        print("restoreTrip: $res");
      }
    );
  }
  Future<void> reconnectWithNewToken() async {
    print("🔄 Reconnecting with new token...");
    connectToServer();
  }
  @override
  void onInit() {
    connectToServer();
    super.onInit();
  }

  @override
  void onClose() {
    socket?.disconnect();
    socket?.dispose();
    super.onClose();
  }
}