import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reservamobile/app/router/app_router.dart';
import 'package:reservamobile/core/auth/auth_session_controller.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authSessionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (authState.isLoggedIn && authState.user != null)
            _AccountTile(
              title: authState.user!.fullName,
              subtitle: authState.user!.email,
              icon: Icons.verified_user_outlined,
            )
          else
            _AccountTile(
              title: 'Guest mode',
              subtitle: 'Login to protect bookings and profile',
              icon: Icons.person_outline,
              trailing: TextButton(
                onPressed: () => context.push(AppRoute.login),
                child: const Text('Login'),
              ),
            ),
          const _AccountTile(
            title: 'Settings',
            subtitle: 'Language, notifications, preferences',
            icon: Icons.settings_outlined,
          ),
          const _AccountTile(
            title: 'Support',
            subtitle: 'Contact support and FAQs',
            icon: Icons.support_agent,
          ),
          if (authState.isLoggedIn)
            FilledButton.tonal(
              onPressed: () => ref.read(authSessionProvider.notifier).logout(),
              child: const Text('Logout'),
            ),
        ],
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  const _AccountTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: trailing,
      ),
    );
  }
}
