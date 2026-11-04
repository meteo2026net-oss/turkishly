import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/brand_splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TurkishlyApp());
}

class TurkishlyApp extends StatelessWidget {
  const TurkishlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sara Hocam | تعلم مع الانسة ساره',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('tr')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: BrandSplashScreen(),
      ),
    );
  }
}
