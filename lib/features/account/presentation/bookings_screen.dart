import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reservamobile/app/router/app_router.dart';
import 'package:reservamobile/app/theme/app_colors.dart';
import 'package:reservamobile/core/auth/auth_session_controller.dart';
import 'package:reservamobile/core/i18n/app_language.dart';
import 'package:reservamobile/core/i18n/app_strings.dart';
import 'package:reservamobile/core/i18n/labels.dart';
import 'package:reservamobile/core/models/app_models.dart';
import 'package:reservamobile/core/providers/reserva_providers.dart';
import 'package:reservamobile/core/widgets/app_network_image.dart';
import 'package:reservamobile/core/widgets/app_scaffold.dart';
import 'package:reservamobile/core/widgets/ui_kit.dart';

class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppStrings t = ref.watch(stringsProvider);
    final AppLanguage lang = ref.watch(languageProvider);
    final authState = ref.watch(authSessionProvider);

    if (!authState.isLoggedIn) {
      return AppScaffold(
        title: t.myBookings,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.receipt_long_outlined, size: 48, color: Color(0xFFBDBDBD)),
              const SizedBox(height: 12),
              Text(t.loginToSeeBookings),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => context.push(AppRoute.login),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                ),
                child: Text(t.logIn),
              ),
            ],
          ),
        ),
      );
    }

    final bookingsAsync = ref.watch(userBookingsProvider);
    return bookingsAsync.when(
      loading: () => AppScaffold(
        title: t.myBookings,
        padding: kScreenContentPadding,
        children: const <Widget>[
          AppSkeletonBox(width: 110, height: 20),
          SizedBox(height: 10),
          AppSkeletonBox(height: 114),
          SizedBox(height: 12),
          AppSkeletonBox(height: 114),
          SizedBox(height: 18),
          AppSkeletonBox(width: 90, height: 20),
          SizedBox(height: 10),
          AppSkeletonBox(height: 114),
        ],
      ),
      error: (err, _) => AppScaffold(
        title: t.myBookings,
        body: Center(child: Text('${t.loadError}: $err')),
      ),
      data: (bookings) {
        if (bookings.isEmpty) {
          return AppScaffold(
            title: t.myBookings,
            body: Center(
              child: Text(t.noBookings),
            ),
          );
        }
        final DateTime now = DateTime.now();
        final upcoming = bookings.where((b) => b.bookingDate.isAfter(now)).toList();
        final past = bookings.where((b) => !b.bookingDate.isAfter(now)).toList();

        return AppScaffold(
          title: t.myBookings,
          padding: kScreenContentPadding,
          children: <Widget>[
            if (upcoming.isNotEmpty) ...<Widget>[
              SectionHeader(title: t.upcoming),
              ...upcoming.map((b) => _BookingCard(booking: b, t: t, lang: lang)),
              const SizedBox(height: 16),
            ],
            if (past.isNotEmpty) ...<Widget>[
              SectionHeader(title: t.past),
              ...past.map((b) => _BookingCard(booking: b, t: t, lang: lang)),
            ],
          ],
        );
      },
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking, required this.t, required this.lang});
  final BookingItem booking;
  final AppStrings t;
  final AppLanguage lang;

  String _statusLabel() {
    switch (booking.status) {
      case BookingStatus.pending:
        return t.statusPending;
      case BookingStatus.confirmed:
        return t.statusConfirmed;
      case BookingStatus.completed:
        return t.statusCompleted;
      case BookingStatus.cancelled:
        return t.statusCancelled;
    }
  }

  Color _statusColor() {
    switch (booking.status) {
      case BookingStatus.pending:
        return const Color(0xFFB45309);
      case BookingStatus.confirmed:
        return const Color(0xFF16A34A);
      case BookingStatus.completed:
        return const Color(0xFF525252);
      case BookingStatus.cancelled:
        return const Color(0xFFB91C1C);
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = booking.bookingDate;
    final String date =
        '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    return GestureDetector(
      onTap: () => context.push(AppRoute.detail(booking.establishmentId)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(kRadiusSm),
          border: Border.all(color: const Color(0xFFEDEDED)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(kRadiusSm),
              child: SizedBox(
                width: 92,
                height: 92,
                child: AppNetworkImage(url: booking.coverImage),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 2, right: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            booking.localizedEstablishmentName(lang),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: _statusColor().withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            _statusLabel(),
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _statusColor()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      booking.localizedServiceName(lang),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF525252)),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: <Widget>[
                        const Icon(Icons.event, size: 12, color: Color(0xFF737373)),
                        const SizedBox(width: 3),
                        Text('$date · ${booking.startTime}',
                            style: const TextStyle(fontSize: 11, color: Color(0xFF737373))),
                        const Spacer(),
                        Text(formatMad(booking.totalPriceMad),
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
