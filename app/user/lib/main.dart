import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: FixoUserApp()));
}

class FixoUserApp extends ConsumerWidget {
  const FixoUserApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp.router(
          title: 'FIXO.GO User',
          themeMode: ThemeMode.system,
          theme: lightDynamic != null
              ? AppTheme.lightFromScheme(lightDynamic)
              : AppTheme.lightFallback(),
          darkTheme: darkDynamic != null
              ? AppTheme.darkFromScheme(darkDynamic)
              : AppTheme.darkFallback(),
          debugShowCheckedModeBanner: false,
          routerConfig: router,
        );
      },
    );
  }
}
