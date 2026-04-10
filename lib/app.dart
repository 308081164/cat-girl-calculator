import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_colors.dart';
import 'widgets/calculator_screen.dart';

class CatGirlCalculatorApp extends StatelessWidget {
  const CatGirlCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '猫猫计算器',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.pressStart2pTextTheme(),
        colorScheme: const ColorScheme.dark(
          primary: AppColors.cyan,
          secondary: AppColors.magenta,
          surface: AppColors.panel,
        ),
      ),
      home: const CalculatorScreen(),
    );
  }
}
