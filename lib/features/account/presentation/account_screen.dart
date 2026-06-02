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

    if (authState.isLoading) {
      return AppScaffold(
        title: t.account,
        padding: kScreenContentPadding,
        children: const <Widget>[
          AppSkeletonBox(height: 108),
          SizedBox(height: 24),
          AppSkeletonBox(width: 90, height: 18),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(child: AppSkeletonBox(height: 46)),
              SizedBox(width: 12),
              Expanded(child: AppSkeletonBox(height: 46)),
            ],
          ),
          SizedBox(height: 24),
          AppSkeletonBox(height: 52),
          SizedBox(height: 10),
          AppSkeletonBox(height: 52),
        ],
      );
    }

    return AppScaffold(
      title: t.account,
      padding: kScreenContentPadding,
      children: <Widget>[
        // Profile / guest card
        if (authState.isLoggedIn && authState.user != null)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(kRadiusSm),
              border: Border.all(color: const Color(0xFFEDEDED)),
            ),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primary,
                  child: const Icon(
                    Icons.person,
                    color: AppColors.textPrimary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        authState.user!.fullName,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        authState.user!.email,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF737373)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(kRadiusSm),
              border: Border.all(color: const Color(0xFFEDEDED)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: Color(0xFF616161),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            lang.isFrench ? 'Invité' : 'Guest',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lang.isFrench
                                ? 'Connectez-vous pour gérer vos réservations'
                                : 'Log in to manage your bookings',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF737373), height: 1.25),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => context.push(AppRoute.login),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.textPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: Text(
                      t.logIn,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ),
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
        _MenuTile(
          icon: Icons.support_agent_outlined,
          label: lang.isFrench ? 'Support' : 'Contact Support',
          onTap: () => context.push(AppRoute.support),
          backgroundColor: const Color(0xFFF0FDF4),
          borderColor: const Color(0xFF86EFAC),
          textColor: const Color(0xFF15803D),
          iconColor: const Color(0xFF15803D),
          chevronColor: const Color(0xFF16A34A),
        ),
        if (authState.isLoggedIn) ...<Widget>[
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => ref.read(authSessionProvider.notifier).logout(),
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xFFFFF1F2),
              foregroundColor: const Color(0xFFB91C1C),
              side: const BorderSide(color: Color(0xFFFCA5A5)),
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
            ),
            child: Text(
              t.logOut,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFFB91C1C),
              ),
            ),
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
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.textPrimary : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(kRadiusSm),
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
  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.iconColor,
    this.chevronColor,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final Color? iconColor;
  final Color? chevronColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.surface,
          borderRadius: BorderRadius.circular(kRadiusSm),
          border: Border.all(color: borderColor ?? const Color(0xFFEDEDED)),
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 22, color: iconColor ?? AppColors.textPrimary),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? AppColors.textPrimary,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: chevronColor ?? const Color(0xFF9E9E9E)),
          ],
        ),
      ),
    );
  }
}
