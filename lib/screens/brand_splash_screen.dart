import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/brand_mark.dart';
import 'home_screen.dart';

class BrandSplashScreen extends StatelessWidget {
  const BrandSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [AppColors.navy, Color(0xFF164D91), Color(0xFF071D43)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),
              const BrandMark(size: 118),
              const SizedBox(height: 26),
              const Text(
                'تعلم مع الانسة ساره',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 31,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.1,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'SARA HOCAM',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 3.2,
                ),
              ),
              const SizedBox(height: 18),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 38),
                child: Text(
                  'رحلتك لتعلّم اللغة التركية خطوة بخطوة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    height: 1.7,
                  ),
                ),
              ),
              const Spacer(flex: 3),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 0, 28, 34),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: AppColors.navy,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (_) => const HomeScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'ابدأ التعلّم',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
