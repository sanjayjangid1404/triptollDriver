import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:taxi_driver/common/custom_snackbar.dart';
import '../common/appContants.dart';
import '../controller/authController.dart';
import '../model/booking_deatils_model.dart';
import '../model/booking_notification_response.dart';


class ChatController extends GetxController {

  Rxn<Data> newBookingSocket = Rxn<Data>();
  io.Socket? socket;
  Set<int> shownBookingIds = {};
  Future<void> emitDriverOnline() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String userID = pref.getString(AppContants.userID) ?? '';

      if (userID.isEmpty) {
        print("❌ UserID not found");
        return;
      }
      socket?.emit("driver_online", {
        "driver_id": userID,
      });
    } catch (e) {
      print("❌ Error emitting driver_online: $e");
    }
  }
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
      // showCustomSnackBar('✅ Connected with server',isError: false,getXSnackBar: true);
      socket!.off("newBooking");
      socket!.off("forceLogout");
      socket!.off("deviceStatus");
      socket!.off("bookingAccepted");
      socket!.off("bookingTaken");
      socket!.off("scheduledReminder");
      socket!.off("tripStarted");
      socket!.off("activeBooking");
      socket!.off("tripEnded");
      await emitDriverOnline();
      socket!.on("forceLogout", (data) {
        print("📡 forceLogout status: $data");
        print("CHECK: ${data["message"] == "Logged in from another device"}");
        final message = data?["message"]?.toString() ?? "";

        if (message.contains("Logged in from another device")) {

          print("🚨 FORCE LOGOUT TRIGGERED");

          showCustomSnackBar(
            message,
            getXSnackBar: true,
            isError: true,
          );

          Get.find<AuthController>().logoutUser();

          socket?.clearListeners();
          socket?.disconnect();
          socket?.dispose();
          socket = null;
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
            newBookingSocket.refresh();
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

        try {
          if (data == null) return;

          List bookings = [];
          if (data['booking'] != null) {
            bookings = [data['booking']];
          }
          else if (data['data'] != null && data['data'] is List) {
            bookings = data['data'];
          }

          for (var booking in bookings) {
            int bookingId =
                int.tryParse(booking['id'].toString()) ?? 0;

            if (!shownBookingIds.contains(bookingId)) {
              shownBookingIds.add(bookingId);

              Get.find<AuthController>().setBookingId(bookingId);

              print("✅ New Booking Saved: $bookingId");
            } else {
              print("⚠️ Duplicate Booking Ignored: $bookingId");
            }
          }
        } catch (e) {
          print("❌ Error in scheduledReminder: $e");
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
      // socket!.on("activeBooking", (data) {
      //   if (kDebugMode) {
      //     print("📡 activeBooking status: $data");
      //     print("📡 activeBooking status: ${jsonEncode(data)}");
      //   }
      //
      //   try {
      //     if (data != null && data is Map<String, dynamic>) {
      //       final bookingList = data['data'];
      //
      //       if (bookingList is List && bookingList.isNotEmpty) {
      //         Get.find<AuthController>().bookingDetailsResponse =
      //             GetBookingDetailModel.fromJson(bookingList[0]);
      //         if (Get.find<AuthController>().bookingDetailsResponse != null){
      //           Get.find<AuthController>().runningOrderStatus.value =
      //               Get.find<AuthController>().bookingDetailsResponse!.orderStatus.toString() ?? '';
      //         }
      //            Get.find<AuthController>().checkAndShowOrderPageSokect();
      //       }
      //
      //       update();
      //     }
      //   } catch (e) {
      //     print("❌ Parsing error: $e");
      //   }
      // });
      socket!.on("activeBooking", (data) {
        if (kDebugMode) {
          print("📡 activeBooking status: $data");
        }

        try {
          Map<String, dynamic> parsedData;

          if (data is String) {
            parsedData = jsonDecode(data);
          } else {
            parsedData = Map<String, dynamic>.from(data);
          }

          final bookingList = parsedData['data'];

          if (bookingList is List && bookingList.isNotEmpty) {
            final controller = Get.find<AuthController>();

            controller.bookingDetailsResponse =
                GetBookingDetailModel.fromJson(bookingList[0]);

            controller.runningOrderStatus.value = controller.bookingDetailsResponse?.orderStatus ?? '';
            controller.checkAndShowOrderPageSokect();
            print("📍 Pickup Full: ${controller.bookingDetailsResponse?.pickup?.toJson()}");
          }

          update();
        } catch (e) {
          print("❌ Parsing error: $e");
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
    socket!.onAny((event, data) {
      log("📡 EVENT: $event");
      log("📦 DATA: $data");
    });
    socket!.onReconnect((_) async {
      log("🔁 Reconnected");
      await emitDriverOnline();
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