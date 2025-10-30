import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_theme.dart';
import 'shared/localization/app_localizations.dart';
import 'shared/router/app_router.dart';
import 'shared/providers/app_start_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: VozApp()));
}

class VozApp extends HookConsumerWidget {
  const VozApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    useEffect(() {
      ref.read(appStartProvider); // kick off initialization
      return null;
    }, const []);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'voz.vn',
      themeMode: themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}
