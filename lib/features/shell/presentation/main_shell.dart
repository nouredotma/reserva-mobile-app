import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservamobile/core/auth/auth_session_controller.dart';
import 'package:reservamobile/features/account/presentation/account_screen.dart';
import 'package:reservamobile/features/account/presentation/bookings_screen.dart';
import 'package:reservamobile/features/home/presentation/home_screen.dart';
import 'package:reservamobile/features/search/presentation/search_screen.dart';
import 'package:reservamobile/features/shell/presentation/widgets/floating_bottom_nav.dart';
import 'package:reservamobile/features/shell/shell_providers.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  static const List<Widget> _tabs = <Widget>[
    HomeScreen(),
    SearchScreen(),
    BookingsScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(authSessionProvider);
    final int selectedIndex = ref.watch(shellTabProvider);
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: selectedIndex, children: _tabs),
      bottomNavigationBar: FloatingBottomNav(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) =>
            ref.read(shellTabProvider.notifier).state = index,
      ),
    );
  }
}
