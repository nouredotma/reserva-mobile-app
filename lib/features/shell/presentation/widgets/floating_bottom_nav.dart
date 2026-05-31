import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservamobile/app/theme/app_colors.dart';
import 'package:reservamobile/core/i18n/app_strings.dart';

class FloatingBottomNav extends ConsumerWidget {
  const FloatingBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  static const _innerPaddingVertical = 6.0;
  static const _innerPaddingHorizontal = 4.0;
  static const _pillInset = 4.0;
  static const _outerMargin = 12.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppStrings t = ref.watch(stringsProvider);
    final List<_NavDestination> destinations = <_NavDestination>[
      _NavDestination(icon: Icons.home_outlined, selectedIcon: Icons.home, label: t.navHome),
      _NavDestination(icon: Icons.search, selectedIcon: Icons.search, label: t.navSearch),
      _NavDestination(icon: Icons.receipt_long_outlined, selectedIcon: Icons.receipt_long, label: t.navBookings),
      _NavDestination(icon: Icons.person_outline, selectedIcon: Icons.person, label: t.navAccount),
    ];
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        _outerMargin,
        _outerMargin,
        _outerMargin,
        bottomInset + _outerMargin,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.navBar,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _innerPaddingHorizontal,
            vertical: _innerPaddingVertical,
          ),
          child: SizedBox(
            height: 52,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemCount = destinations.length;
                final itemWidth = constraints.maxWidth / itemCount;
                final pillWidth = itemWidth - _pillInset * 2;

                return Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeOutCubic,
                      left: selectedIndex * itemWidth + _pillInset,
                      top: 0,
                      bottom: 0,
                      width: pillWidth,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.navBarActivePill,
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                    Row(
                      children: List.generate(itemCount, (index) {
                        final destination = destinations[index];
                        final isSelected = selectedIndex == index;

                        return Expanded(
                          child: _NavItem(
                            destination: destination,
                            isSelected: isSelected,
                            onTap: () => onDestinationSelected(index),
                          ),
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _NavDestination {
  const _NavDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  final _NavDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : AppColors.navBarIcon;

    return Semantics(
      button: true,
      selected: isSelected,
      label: destination.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? destination.selectedIcon : destination.icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 3),
            Text(
              destination.label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
