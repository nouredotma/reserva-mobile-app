import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reservamobile/app/router/app_router.dart';
import 'package:reservamobile/app/theme/app_colors.dart';
import 'package:reservamobile/core/auth/auth_session_controller.dart';
import 'package:reservamobile/core/i18n/app_language.dart';
import 'package:reservamobile/core/i18n/app_strings.dart';
import 'package:reservamobile/core/widgets/app_scaffold.dart';
import 'package:reservamobile/core/widgets/ui_kit.dart';
import 'package:reservamobile/features/shell/shell_providers.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppStrings t = ref.watch(stringsProvider);
    final AppLanguage lang = ref.watch(languageProvider);
    final authState = ref.watch(authSessionProvider);

    return AppScaffold(
      title: t.account,
      padding: kScreenContentPadding,
      children: <Widget>[
        // Profile header
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(kRadiusLg),
          ),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary,
                child: Icon(
                  authState.isLoggedIn ? Icons.person : Icons.person_outline,
                  color: AppColors.textPrimary,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      authState.isLoggedIn && authState.user != null
                          ? authState.user!.fullName
                          : (lang.isFrench ? 'Invité' : 'Guest'),
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      authState.isLoggedIn && authState.user != null
                          ? authState.user!.email
                          : (lang.isFrench
                              ? 'Connectez-vous pour gérer vos réservations'
                              : 'Log in to manage your bookings'),
                      style: const TextStyle(fontSize: 13, color: Color(0xFF737373)),
                    ),
                  ],
                ),
              ),
              if (!authState.isLoggedIn)
                TextButton(
                  onPressed: () => context.push(AppRoute.login),
                  child: Text(t.logIn),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Language switcher
        Text(t.language, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: _LangButton(
                label: 'English',
                selected: !lang.isFrench,
                onTap: () =>
                    ref.read(languageProvider.notifier).setLanguage(AppLanguage.en),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _LangButton(
                label: 'Français',
                selected: lang.isFrench,
                onTap: () =>
                    ref.read(languageProvider.notifier).setLanguage(AppLanguage.fr),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        _MenuTile(
          icon: Icons.receipt_long_outlined,
          label: t.myBookings,
          onTap: () => ref.read(shellTabProvider.notifier).state = 2,
        ),
        _MenuTile(
          icon: Icons.notifications_outlined,
          label: t.notifications,
          onTap: () => context.push(AppRoute.notifications),
        ),
        if (authState.isLoggedIn) ...<Widget>[
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => ref.read(authSessionProvider.notifier).logout(),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
            ),
            child: Text(t.logOut),
          ),
        ],
      ],
    );
  }
}

class _LangButton extends StatelessWidget {
  const _LangButton({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.textPrimary : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(kRadius),
          border: Border.all(
            color: selected ? AppColors.textPrimary : const Color(0xFFE5E5E5),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(kRadius),
          border: Border.all(color: const Color(0xFFEDEDED)),
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 22, color: AppColors.textPrimary),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
            const Icon(Icons.chevron_right, color: Color(0xFF9E9E9E)),
          ],
        ),
      ),
    );
  }
}
