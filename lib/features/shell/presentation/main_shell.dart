import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservamobile/core/auth/auth_session_controller.dart';
import 'package:reservamobile/features/account/presentation/account_screen.dart';
import 'package:reservamobile/features/account/presentation/bookings_screen.dart';
import 'package:reservamobile/features/home/presentation/home_screen.dart';
import 'package:reservamobile/features/search/presentation/search_screen.dart';
import 'package:reservamobile/features/shell/presentation/widgets/floating_bottom_nav.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _selectedIndex = 0;

  late final List<Widget> _tabs = const [
    HomeScreen(),
    SearchScreen(),
    BookingsScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    ref.watch(authSessionProvider);
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _selectedIndex, children: _tabs),
      bottomNavigationBar: FloatingBottomNav(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
