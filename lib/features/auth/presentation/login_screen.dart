import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/localization/app_localizations.dart';
import '../providers/auth_providers.dart';
import '../domain/auth_models.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final authState = ref.watch(authStateProvider);

    ref.listen(authStateProvider, (previous, next) {
      next.maybeMap(
        authenticated: (_) => Future.microtask(() => context.go('/home')),
        failure: (failure) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        ),
        orElse: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).translate('login'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context).translate('username')),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context).translate('password')),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: authState is Loading
                  ? null
                  : () => ref
                      .read(authStateProvider.notifier)
                      .login(usernameController.text.trim(), passwordController.text.trim()),
              child: authState is Loading
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(AppLocalizations.of(context).translate('login')),
            ),
          ],
        ),
      ),
    );
  }
}
