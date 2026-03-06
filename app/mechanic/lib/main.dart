import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: FixoMechanicApp()));
}

class FixoMechanicApp extends ConsumerWidget {
  const FixoMechanicApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'FIXO.GO Mechanic',
          themeMode: ThemeMode.system,
          theme: lightDynamic != null
              ? AppTheme.lightFromScheme(lightDynamic)
              : AppTheme.lightFallback(),
          darkTheme: darkDynamic != null
              ? AppTheme.darkFromScheme(darkDynamic)
              : AppTheme.darkFallback(),
          routerConfig: ref.watch(appRouterProvider),
        );
      },
    );
  }
}
