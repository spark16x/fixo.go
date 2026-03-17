import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FixoUserApp());
}

class FixoUserApp extends StatelessWidget {
  const FixoUserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          title: 'FIXO.GO User',
          themeMode: ThemeMode.system,
          theme: lightDynamic != null
              ? AppTheme.lightFromScheme(lightDynamic)
              : AppTheme.lightFallback(),
          darkTheme: darkDynamic != null
              ? AppTheme.darkFromScheme(darkDynamic)
              : AppTheme.darkFallback(),
          debugShowCheckedModeBanner: false,
          initialRoute: AppRouter.splash,
          onGenerateRoute: AppRouter.onGenerateRoute,
        );
      },
    );
  }
}
