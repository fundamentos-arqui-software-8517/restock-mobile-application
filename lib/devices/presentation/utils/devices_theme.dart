import 'package:flutter/material.dart';

class DevicesTheme {
  DevicesTheme._();

  // Surfaces
  static const Color background = Color(0xFFF4F7F6);
  static const Color cardBackground = Colors.white;
  static const Color headerDark = Color(0xFF111827);

  // Brand greens (Figma mobile — distintos al shared/theme.dart)
  static const Color greenPrimary = Color(0xFF006C49);
  static const Color greenAccent = Color(0xFF4EDEA3);
  static const Color greenLight = Color(0xFF6FFBBE);
  static const Color greenBorderDark = Color(0xFF024E36);
  static const Color greenTextDeep = Color(0xFF002113);

  // Text
  static const Color textPrimary = Color(0xFF1B1B1D);
  static const Color textSecondary = Color(0xFF76777D);

  // Borders / dividers
  static const Color borderGray = Color(0xFFC6C6CD);
  static const Color borderLight = Color(0xFFF0EDEE);

  // Health badges
  static const Color healthyBorder = Color(0xFF006C49);
  static const Color healthyBg = Color(0xFF4EDEA3);
  static const Color healthyText = Color(0xFF002113);

  static const Color warmBorder = Color(0xFFB87500);
  static const Color warmBg = Color(0xFFFFDDB8);
  static const Color warmText = Color(0xFF653E00);

  static const Color criticalBorder = Color(0xFFBA1A1A);
  static const Color criticalBg = Color(0xFFFFDAD6);
  static const Color criticalText = Color(0xFF93000A);

  static const Color offlineBorder = Color(0xFF76777D);
  static const Color offlineBg = Color(0xFFDCD9DB);
  static const Color offlineText = Color(0xFF45464C);

  // Radii
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;

  // Spacing
  static const double sidePadding = 16.0;
}
