import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/authController.dart';

class LoadingTimer extends StatefulWidget {
  // Pass your free time and charge rate as arguments or from API/keys
  final String maxLoadingTime; // Free time in minutes
  final String loadingChargePerMin; // Charge per minute after free time

  const LoadingTimer({
    Key? key,
    required this.maxLoadingTime,
    required this.loadingChargePerMin,
  }) : super(key: key);

  @override
  State<LoadingTimer> createState() => _LoadingTimerState();
}

class _LoadingTimerState extends State<LoadingTimer> {
  Timer? _timer;
  bool _isRunning = false;
  AuthController authController  = Get.find<AuthController>();
  void _startTimer() {
    setState(() {
      _isRunning = true;
      authController.elapsedSeconds = 0;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        authController.elapsedSeconds++;
      });
    });
  }
 @override
  void initState() {
    super.initState();
    _startTimer();
  }
  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  /// Calculate charges based on elapsed time
  double _calculateCharge() {
    int elapsedMinutes = authController.elapsedSeconds ~/ 60;
    if (elapsedMinutes <= int.parse(widget.maxLoadingTime)) return 0.0;
    int chargeableMinutes = elapsedMinutes - int.parse(widget.maxLoadingTime);
    return chargeableMinutes * double.parse(widget.loadingChargePerMin);
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
  int getElapsedMinutesForAPI(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    if (minutes < 1) {
      minutes = 1;
    }
    return minutes;
  }
  Color _getTimerColor() {
    int freeSeconds = int.parse(widget.maxLoadingTime) * 60;
    int elapsed = authController.elapsedSeconds;

    if (elapsed <= freeSeconds) return Colors.green;

    int overSeconds = elapsed - freeSeconds;
    double t = (overSeconds / 60).clamp(0.0, 1.0); // within 1 min turns red
    return Color.lerp(Colors.green, Colors.red, t)!;
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   authController.chargesLoading = _calculateCharge();
   int apiMinutes = getElapsedMinutesForAPI(authController.elapsedSeconds);
   authController.realLoadingTime = apiMinutes.toString();
   final int freeSeconds = int.tryParse(widget.maxLoadingTime) != null
       ? int.parse(widget.maxLoadingTime) * 60
       : 2700;
    return Center(
     child: Stack(
       alignment: Alignment.center,
       children: [
         // Circular progress
         SizedBox(
           width: 120,
           height: 120,
           child: CircularProgressIndicator(
             value: double.parse(freeSeconds.toString()),
             strokeWidth: 5,
             valueColor: AlwaysStoppedAnimation<Color>(_getTimerColor()),
             backgroundColor: Colors.grey.shade300,
           ),
         ),
         // Timer text in the center
         Text(
           _formatTime(authController.elapsedSeconds),
           style: TextStyle(
             fontSize: 25,
             fontWeight: FontWeight.bold,
             color: _getTimerColor(),
           ),
         ),
       ],
     ),
   );
  }
}
