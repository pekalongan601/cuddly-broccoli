import 'package:flutter/material.dart';

/// Serializable user preferences stored locally.
@immutable
class AppPreferences {
  const AppPreferences({
    required this.userName,
    required this.phoneNumber,
    required this.accountNumber,
    required this.balance,
    required this.savingsBalance,
    required this.isBalanceHidden,
    required this.themeMode,
  });

  static const String defaultUserName = 'Diaz Arman Maulana';
  static const String defaultPhoneNumber = '083*****350';
  static const String defaultAccountNumber = '9014 3025 9290';
  static const int defaultBalance = 212000000;
  static const int defaultSavingsBalance = 212000000;

  static const AppPreferences defaults = AppPreferences(
    userName: defaultUserName,
    phoneNumber: defaultPhoneNumber,
    accountNumber: defaultAccountNumber,
    balance: defaultBalance,
    savingsBalance: defaultSavingsBalance,
    isBalanceHidden: false,
    themeMode: ThemeMode.light,
  );

  final String userName;
  final String phoneNumber;
  final String accountNumber;
  final num balance;
  final num savingsBalance;
  final bool isBalanceHidden;
  final ThemeMode themeMode;
}
