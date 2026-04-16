import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/authController.dart';

class LoadingTimer extends StatelessWidget {
  final String maxLoadingTime;
  final String loadingChargePerMin;

  LoadingTimer({
    Key? key,
    required this.maxLoadingTime,
    required this.loadingChargePerMin,
  }) : super(key: key);

  final AuthController authController = Get.find<AuthController>();

  double _calculateCharge(int seconds) {
    int elapsedMinutes = seconds ~/ 60;
    int freeMinutes = int.tryParse(maxLoadingTime) ?? 0;

    if (elapsedMinutes <= freeMinutes) return 0.0;
    return (elapsedMinutes - freeMinutes) *
        double.parse(loadingChargePerMin);
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  Color _getTimerColor(int seconds) {
    int freeSeconds = (int.tryParse(maxLoadingTime) ?? 0) * 60;
    if (seconds <= freeSeconds) return Colors.green;

    double t = ((seconds - freeSeconds) / 60).clamp(0.0, 1.0);
    return Color.lerp(Colors.green, Colors.red, t)!;
  }
  double _progressValue(int seconds) {
    int freeSeconds = (int.tryParse(maxLoadingTime) ?? 0) * 60;

    if (seconds <= 0) return 0.0;
    if (seconds >= freeSeconds) return 1.0;

    return seconds / freeSeconds; // 0.0 → 1.0
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final seconds = authController.elapsedSeconds.value;

      authController.chargesLoading = _calculateCharge(seconds);
      authController.realLoadingTime =
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
                value: _progressValue(seconds),
                valueColor:
                AlwaysStoppedAnimation(_getTimerColor(seconds)),
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

