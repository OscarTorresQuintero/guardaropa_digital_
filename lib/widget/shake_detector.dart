widgets: // lib/widgets/shake_detector.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ShakeDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback onShake;
  final double threshold;

  const ShakeDetector({
    super.key,
    required this.child,
    required this.onShake,
    this.threshold = 12.0,
  });

  @override
  State<ShakeDetector> createState() => _ShakeDetectorState();
}

class _ShakeDetectorState extends State<ShakeDetector> {
  StreamSubscription<AccelerometerEvent>? _sub;
  DateTime _lastShake = DateTime.now();

  @override
  void initState() {
    super.initState();
    _sub = accelerometerEventStream(
      samplingPeriod: SensorInterval.normalInterval,
    ).listen((event) {
      final magnitude = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );
      // La gravedad normal es ~9.8, si supera threshold + 9.8 es un shake
      if (magnitude > widget.threshold + 9.8) {
        final now = DateTime.now();
        if (now.difference(_lastShake).inMilliseconds > 1000) {
          _lastShake = now;
          widget.onShake();
        }
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}