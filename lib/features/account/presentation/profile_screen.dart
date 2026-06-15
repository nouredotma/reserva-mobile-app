import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reservamobile/app/router/app_router.dart';
import 'package:reservamobile/app/theme/app_colors.dart';
import 'package:reservamobile/core/auth/auth_session_controller.dart';
import 'package:reservamobile/core/i18n/app_strings.dart';
import 'package:reservamobile/core/models/app_models.dart';
import 'package:reservamobile/core/providers/reserva_providers.dart';
import 'package:reservamobile/core/widgets/app_scaffold.dart';
import 'package:reservamobile/core/widgets/ui_kit.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isEditing = false;
  bool _isSaving = false;
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _syncFromUser(AppUser user) {
    _nameController.text = user.fullName;
    _emailController.text = user.email;
    _phoneController.text = user.phone;
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    await ref.read(authSessionProvider.notifier).updateProfile(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );
    if (!mounted) return;
    setState(() {
      _isSaving = false;
      _isEditing = false;
    });
    final AppStrings t = ref.read(stringsProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t.profileUpdated)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings t = ref.watch(stringsProvider);
    final authState = ref.watch(authSessionProvider);
    final bookingsAsync = ref.watch(userBookingsProvider);

    if (authState.isLoading) {
      return AppScaffold(
        title: t.myProfile,
        padding: kScreenContentPadding,
        children: const <Widget>[
          AppSkeletonBox(height: 120),
          SizedBox(height: 16),
          AppSkeletonBox(height: 52),
          SizedBox(height: 10),
          AppSkeletonBox(height: 52),
        ],
      );
    }

    if (!authState.isLoggedIn || authState.user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go(AppRoute.login);
      });
      return const SizedBox.shrink();
    }

    final AppUser user = authState.user!;
    if (!_isEditing &&
        _nameController.text.isEmpty &&
        _emailController.text.isEmpty) {
      _syncFromUser(user);
    }

    final List<BookingItem> bookings =
        bookingsAsync.valueOrNull ?? const <BookingItem>[];
    final int totalBookings = bookings.length;
    final int completedExperiences = bookings
        .where((b) => b.status == BookingStatus.completed)
        .length;
    final int reviewsWritten = bookings.isEmpty ? 0 : 0;

    return AppScaffold(
      title: t.profilePageTitle,
      padding: kScreenContentPadding,
      children: <Widget>[
        Text(
          t.profilePageDescription,
          style: const TextStyle(fontSize: 13, color: Color(0xFF737373), height: 1.35),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          t.personalInfo,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          t.updateDetails,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF737373),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!_isEditing)
                    TextButton(
                      onPressed: () => setState(() => _isEditing = true),
                      child: Text(t.editProfile),
                    )
                  else
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextButton(
                          onPressed: _isSaving
                              ? null
                              : () {
                                  _syncFromUser(user);
                                  setState(() => _isEditing = false);
                                },
                          child: Text(t.cancel),
                        ),
                        FilledButton(
                          onPressed: _isSaving ? null : _saveProfile,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textPrimary,
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(t.saveChanges),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 34,
                      backgroundColor: AppColors.primary,
                      child: Icon(
                        Icons.person,
                        size: 36,
                        color: AppColors.textPrimary.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _nameController.text.isEmpty
                              ? user.fullName
                              : _nameController.text,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          t.memberSince,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF9E9E9E),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _ProfileField(
                label: t.fullName,
                controller: _nameController,
                icon: Icons.person_outline,
                enabled: _isEditing,
                hint: t.namePlaceholder,
              ),
              const SizedBox(height: 12),
              _ProfileField(
                label: t.emailAddress,
                controller: _emailController,
                icon: Icons.mail_outline,
                enabled: _isEditing,
                hint: t.emailPlaceholder,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              _ProfileField(
                label: t.phoneNumber,
                controller: _phoneController,
                icon: Icons.phone_outlined,
                enabled: _isEditing,
                hint: t.phonePlaceholder,
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _StatCard(
          icon: Icons.calendar_month_outlined,
          value: '$totalBookings',
          label: t.totalBookings,
          highlighted: true,
        ),
        const SizedBox(height: 10),
        _StatCard(
          icon: Icons.star_outline,
          value: '$reviewsWritten',
          label: t.reviewsWritten,
        ),
        const SizedBox(height: 10),
        _StatCard(
          icon: Icons.check_circle_outline,
          value: '$completedExperiences',
          label: t.completedExperiences,
        ),
      ],
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.label,
    required this.controller,
    required this.icon,
    required this.enabled,
    required this.hint,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final bool enabled;
  final String hint;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Color(0xFF9E9E9E),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFFD4D4D4)),
            filled: true,
            fillColor: enabled ? Colors.white : const Color(0xFFF5F5F5),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kRadiusSm),
              borderSide: const BorderSide(color: Color(0xFFEDEDED)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kRadiusSm),
              borderSide: const BorderSide(color: Color(0xFFEDEDED)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kRadiusSm),
              borderSide: const BorderSide(color: Color(0xFFEDEDED)),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    this.highlighted = false,
  });

  final IconData icon;
  final String value;
  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: highlighted ? AppColors.primary : const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(kRadiusSm),
        border: Border.all(
          color: highlighted ? AppColors.primary : const Color(0xFFEDEDED),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            icon,
            size: 28,
            color: highlighted ? AppColors.textPrimary : AppColors.primary,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              color: highlighted
                  ? AppColors.textPrimary.withValues(alpha: 0.65)
                  : const Color(0xFF9E9E9E),
            ),
          ),
        ],
      ),
    );
  }
}
