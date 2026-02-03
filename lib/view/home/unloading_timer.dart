import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../controller/authController.dart';

class UnLoadingTimer extends StatelessWidget {
  final String maxLoadingTime;
  final String loadingChargePerMin;

  UnLoadingTimer({
    Key? key,
    required this.maxLoadingTime,
    required this.loadingChargePerMin,
  }) : super(key: key);

  final AuthController controller = Get.find<AuthController>();

  double _progressValue(int seconds) {
    final freeSeconds = int.parse(maxLoadingTime) * 60;
    if (seconds <= 0) return 0.0;
    if (seconds >= freeSeconds) return 1.0;
    return seconds / freeSeconds;
  }

  double _calculateCharge(int seconds) {
    int elapsedMinutes = seconds ~/ 60;
    int freeMinutes = int.parse(maxLoadingTime);
    if (elapsedMinutes <= freeMinutes) return 0.0;
    return (elapsedMinutes - freeMinutes) *
        double.parse(loadingChargePerMin);
  }

  Color _getTimerColor(int seconds) {
    int freeSeconds = int.parse(maxLoadingTime) * 60;
    if (seconds <= freeSeconds) return Colors.green;

    double t = ((seconds - freeSeconds) / 60).clamp(0.0, 1.0);
    return Color.lerp(Colors.green, Colors.red, t)!;
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final seconds = controller.elapsedSecondsUnload.value;

      controller.chargesUnLoading = _calculateCharge(seconds);
      controller.realUnLoadingTime =
          ((seconds ~/ 60) < 1 ? 1 : (seconds ~/ 60)).toString();

      return Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                strokeWidth: 5,
                value: _progressValue(seconds), // ✅ NO ROTATION
                valueColor: AlwaysStoppedAnimation(
                  _getTimerColor(seconds),
                ),
                backgroundColor: Colors.grey.shade300,
              ),
            ),
            Text(
              _formatTime(seconds),
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: _getTimerColor(seconds),
              ),
            ),
          ],
        ),
      );
    });
  }
}


class LottieScreen extends StatelessWidget {
  const LottieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: 250,
      child: Lottie.asset(
          'assets/lottie/click_next.json'
      ),
    );
  }
}
