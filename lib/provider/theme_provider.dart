import 'dart:async';
import 'package:flutter/material.dart';
import 'package:light/light.dart';
import 'package:battery_plus/battery_plus.dart';

class SmartThemeController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  final Battery _battery = Battery();
  StreamSubscription? _lightSub;
  StreamSubscription? _batterySub;

  int _currentLux = 100; 
  int _currentBatteryLevel = 100;
  BatteryState _currentBatteryState = BatteryState.discharging; 

  SmartThemeController() {
    _initSensors();
  }

  void _initSensors() {
    _lightSub = Light().lightSensorStream.listen((lux) {
      _currentLux = lux;
      _calculateTheme();
    });

    _batterySub = _battery.onBatteryStateChanged.listen((BatteryState state) async {
      _currentBatteryState = state;
      _currentBatteryLevel = await _battery.batteryLevel;
      _calculateTheme();
    });

    _checkInitialBattery();
  }

  Future<void> _checkInitialBattery() async {
    _currentBatteryLevel = await _battery.batteryLevel;
    _currentBatteryState = await _battery.batteryState; 
    _calculateTheme();
  }

  void _calculateTheme() {
    bool isRoomDark = _currentLux < 8000;
    bool isLowBatteryCritical = _currentBatteryLevel < 20 && _currentBatteryState != BatteryState.charging;

    if (isRoomDark || isLowBatteryCritical) {
      _updateTheme(ThemeMode.dark);
    } else {
      _updateTheme(ThemeMode.light);
    }
  }

  void _updateTheme(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners(); 
    }
  }

  @override
  void dispose() {
    _lightSub?.cancel();
    _batterySub?.cancel();
    super.dispose();
  }
}