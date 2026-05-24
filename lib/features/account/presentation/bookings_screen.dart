import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reservamobile/app/router/app_router.dart';
import 'package:reservamobile/core/auth/auth_session_controller.dart';
import 'package:reservamobile/core/providers/reserva_providers.dart';

class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authSessionProvider);
    if (!authState.isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Bookings')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Login to see your bookings.'),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => context.push(AppRoute.login),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      );
    }

    final bookingsAsync = ref.watch(userBookingsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: bookingsAsync.when(
        data: (bookings) {
          if (bookings.isEmpty) {
            return const Center(child: Text('No bookings yet.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = bookings[index];
              return Card(
                child: ListTile(
                  title: Text(item.establishmentName),
                  subtitle: Text(
                    '${item.serviceName}\n${item.bookingDate.toLocal().toString().split(' ').first} • ${item.startTime}',
                  ),
                  isThreeLine: true,
                  trailing: Text(item.status.name),
                  onTap: () =>
                      context.push(AppRoute.detail(item.establishmentId)),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Failed to load bookings: $err')),
      ),
    );
  }
}
