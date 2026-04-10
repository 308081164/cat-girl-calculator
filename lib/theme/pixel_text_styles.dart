import 'package:flutter/material.dart';
import 'app_colors.dart';

class PixelTextStyles {
  static const TextStyle result = TextStyle(
    fontFamily: 'PressStart2P',
    fontSize: 28,
    color: AppColors.textPrimary,
    letterSpacing: 2,
    shadows: [
      Shadow(color: AppColors.green, blurRadius: 10),
      Shadow(color: AppColors.green, blurRadius: 20),
    ],
  );

  static const TextStyle expression = TextStyle(
    fontFamily: 'PressStart2P',
    fontSize: 12,
    color: AppColors.textSecondary,
    letterSpacing: 1,
  );

  static const TextStyle button = TextStyle(
    fontFamily: 'PressStart2P',
    fontSize: 16,
    color: Colors.white,
  );

  static const TextStyle buttonOp = TextStyle(
    fontFamily: 'PressStart2P',
    fontSize: 18,
    color: AppColors.cyan,
  );

  static const TextStyle buttonSpecial = TextStyle(
    fontFamily: 'PressStart2P',
    fontSize: 16,
    color: AppColors.magenta,
  );

  static const TextStyle zzz = TextStyle(
    fontFamily: 'PressStart2P',
    fontSize: 20,
    color: AppColors.cyan,
    shadows: [
      Shadow(color: AppColors.cyan, blurRadius: 6),
    ],
  );

  static const TextStyle zzzSmall = TextStyle(
    fontFamily: 'PressStart2P',
    fontSize: 14,
    color: Color(0xFF00AAAA),
  );
}
