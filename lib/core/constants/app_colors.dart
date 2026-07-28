import 'package:flutter/material.dart';

/// SeaBank-brand color palette extracted from the official app UI.
abstract final class AppColors {
  AppColors._();

  // ─── Primary ──────────────────────────────────────────────
  static const Color orange = Color(0xFFFF6600);
  static const Color orangeDark = Color(0xFFD94E00);
  static const Color orangeDeep = Color(0xFFE85500);
  static const Color orangeGradientStart = Color(0xFFFF7200);
  static const Color orangeGradientEnd = Color(0xFFF25800);

  // ─── Orange tints ─────────────────────────────────────────
  static const Color peach = Color(0xFFFFE6D2);
  static const Color palePeach = Color(0xFFFFF2E8);
  static const Color flashDealBg = Color(0xFFFFE8D6);
  static const Color flashDealBgEnd = Color(0xFFFFF7F0);
  static const Color badgeBg = Color(0xFFFFD5A2);
  static const Color badgeText = Color(0xFF6A370D);
  static const Color depositHeroStart = Color(0xFFFFF0E7);
  static const Color depositHeroEnd = Color(0xFFFFD8C7);

  // ─── Surfaces ─────────────────────────────────────────────
  static const Color background = Color(0xFFF7F7F8);
  static const Color white = Colors.white;
  static const Color cardSurface = Colors.white;

  // ─── Text ─────────────────────────────────────────────────
  static const Color ink = Color(0xFF202124);
  static const Color inkDark = Color(0xFF1A1D23);
  static const Color muted = Color(0xFF737373);
  static const Color mutedLight = Color(0xFF8A8F98);
  static const Color subtitle = Color(0xFF545454);
  static const Color hint = Color(0xFFC6C6C6);

  // ─── Lines & Dividers ─────────────────────────────────────
  static const Color line = Color(0xFFE9E9E9);
  static const Color lineLight = Color(0xFFE4E4E4);
  static const Color border = Color(0xFFB5B5B5);

  // ─── Functional ───────────────────────────────────────────
  static const Color success = Color(0xFF18A957);
  static const Color blue = Color(0xFF1C61E7);
  static const Color starYellow = Color(0xFFFFC400);
  static const Color linkBlue = Color(0xFF1483A5);
  static const Color clockBg = Color(0xFF242424);
  static const Color hintOrange = Color(0xFFC85B19);
  static const Color gold = Color(0xFFFFB100);
  static const Color circleBlue = Color(0xFF7699E9);

  // ─── Nav ──────────────────────────────────────────────────
  static const Color navInactive = Color(0xFF767676);
  static const Color navShadow = Color(0xFF292929);

  // ─── QRIS ─────────────────────────────────────────────────
  static const Color qrisBg = Color(0xFF151515);
  static const Color qrisCorner = AppColors.orange;

  // ─── Orange card utilities ────────────────────────────────
  static const Color riwayatBg = Color(0xFFCF4D00);
  static const Color depositCtaBg = Color(0xFFFFD19A);
  static const Color depositCtaText = Color(0xFF713600);
  static const Color savingsSubText = Color(0xFFFFD2AF);
}
