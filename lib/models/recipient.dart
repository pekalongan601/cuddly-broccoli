import 'package:flutter/material.dart';

/// A transfer recipient displayed in the recipient list.
class Recipient {
  const Recipient({
    required this.name,
    required this.detail,
    required this.color,
    required this.icon,
  });

  final String name;
  final String detail;
  final Color color;
  final IconData icon;
}
