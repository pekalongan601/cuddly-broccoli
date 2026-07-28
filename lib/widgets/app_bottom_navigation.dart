import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/layout.dart';

/// SeaBank-style bottom navigation bar with a prominent centre QRIS button.
class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({super.key, required this.location});

  final String location;

  int get _selectedIndex {
    if (location.startsWith('/transfer')) return 1;
    if (location.startsWith('/qris')) return 2;
    if (location.startsWith('/deposit')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    const List<String> routes = <String>[
      '/home', '/transfer', '/qris', '/deposit', '/profile',
    ];
    const List<String> labels = <String>[
      'Beranda', 'Bayar/Transfer', 'QRIS', 'Deposito', 'Saya',
    ];
    const List<IconData> inactiveIcons = <IconData>[
      Icons.home_outlined,
      Icons.swap_horiz_rounded,
      Icons.qr_code_scanner_rounded,
      Icons.savings_outlined,
      Icons.person_outline_rounded,
    ];
    const List<IconData> activeIcons = <IconData>[
      Icons.home_rounded,
      Icons.swap_horiz_rounded,
      Icons.qr_code_scanner_rounded,
      Icons.savings_rounded,
      Icons.person_rounded,
    ];

    final int selected = _selectedIndex;

    return SizedBox(
      height: Layout.navHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: Layout.navBarHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  top: BorderSide(color: Theme.of(context).dividerColor),
                ),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 6,
                    offset: Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                children: List<Widget>.generate(5, (int index) {
                  final bool active = selected == index;
                  return Expanded(
                    child: _NavItem(
                      active: active,
                      center: index == 2,
                      icon: active ? activeIcons[index] : inactiveIcons[index],
                      label: labels[index],
                      onTap: () => context.go(routes[index]),
                    ),
                  );
                }),
              ),
            ),
          ),
          Semantics(
            button: true,
            selected: selected == 2,
            label: 'QRIS',
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: () => context.go('/qris'),
                customBorder: const CircleBorder(),
                child: Container(
                  height: Layout.navFabSize,
                  width: Layout.navFabSize,
                  decoration: BoxDecoration(
                    color: AppColors.orange,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.surface,
                      width: 3,
                    ),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x40FF6600),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.qr_code_scanner_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.active,
    required this.center,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final bool active;
  final bool center;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = active ? AppColors.orange : AppColors.navInactive;
    return Semantics(
      button: true,
      selected: active,
      label: label,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (center)
              const SizedBox(height: Layout.s20)
            else
              Icon(icon, color: color, size: Layout.iconNav),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: TextStyle(
                color: color,
                fontSize: Layout.fsNavLabel,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
