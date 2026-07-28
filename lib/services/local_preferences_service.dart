import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_preferences.dart';

/// Small local-only persistence boundary for user-adjustable demo settings.
///
/// The in-memory constructor keeps widgets and tests independent from platform
/// channels while the production constructor uses SharedPreferences.
class LocalPreferencesService {
  LocalPreferencesService._(this._preferences);

  factory LocalPreferencesService.inMemory() =>
      LocalPreferencesService._(null);

  static Future<LocalPreferencesService> create() async =>
      LocalPreferencesService._(await SharedPreferences.getInstance());

  static const String _userNameKey = 'user_name';
  static const String _phoneNumberKey = 'phone_number';
  static const String _accountNumberKey = 'account_number';
  static const String _balanceKey = 'balance';
  static const String _savingsBalanceKey = 'savings_balance';
  static const String _balanceHiddenKey = 'balance_hidden';
  static const String _themeModeKey = 'theme_mode';

  final SharedPreferences? _preferences;
  AppPreferences _memory = AppPreferences.defaults;

  AppPreferences read() {
    final SharedPreferences? prefs = _preferences;
    if (prefs == null) return _memory;

    const AppPreferences defaults = AppPreferences.defaults;
    return AppPreferences(
      userName: prefs.getString(_userNameKey) ?? defaults.userName,
      phoneNumber:
          prefs.getString(_phoneNumberKey) ?? defaults.phoneNumber,
      accountNumber:
          prefs.getString(_accountNumberKey) ?? defaults.accountNumber,
      balance: prefs.getDouble(_balanceKey) ?? defaults.balance,
      savingsBalance:
          prefs.getDouble(_savingsBalanceKey) ?? defaults.savingsBalance,
      isBalanceHidden:
          prefs.getBool(_balanceHiddenKey) ?? defaults.isBalanceHidden,
      themeMode: _themeFromStorage(prefs.getString(_themeModeKey)),
    );
  }

  Future<void> save(AppPreferences settings) async {
    _memory = settings;
    final SharedPreferences? prefs = _preferences;
    if (prefs == null) return;

    await Future.wait(<Future<bool>>[
      prefs.setString(_userNameKey, settings.userName),
      prefs.setString(_phoneNumberKey, settings.phoneNumber),
      prefs.setString(_accountNumberKey, settings.accountNumber),
      prefs.setDouble(_balanceKey, settings.balance.toDouble()),
      prefs.setDouble(
          _savingsBalanceKey, settings.savingsBalance.toDouble()),
      prefs.setBool(_balanceHiddenKey, settings.isBalanceHidden),
      prefs.setString(_themeModeKey, settings.themeMode.name),
    ]);
  }

  ThemeMode _themeFromStorage(String? value) {
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }
}
