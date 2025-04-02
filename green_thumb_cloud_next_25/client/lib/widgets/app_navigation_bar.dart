import 'package:flutter/material.dart';

import '../styles.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({super.key});

  @override
  Widget build(BuildContext context) => NavigationBar(
    backgroundColor: AppColors.navigationBarBackground,
    height: AppLayout.navigationBarHeight,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    destinations: const [
      NavigationDestination(
        icon: Icon(Icons.shopping_bag_outlined, size: AppLayout.iconSize),
        selectedIcon: Icon(Icons.shopping_bag, size: AppLayout.iconSize),
        label: 'Shop',
      ),
      NavigationDestination(
        icon: Icon(Icons.settings_outlined, size: AppLayout.iconSize),
        selectedIcon: Icon(Icons.settings, size: AppLayout.iconSize),
        label: 'Services',
      ),
      NavigationDestination(
        icon: Icon(Icons.build_outlined, size: AppLayout.iconSize),
        selectedIcon: Icon(Icons.build, size: AppLayout.iconSize),
        label: 'DIY',
      ),
      NavigationDestination(
        icon: Icon(Icons.person_outline, size: AppLayout.iconSize),
        selectedIcon: Icon(Icons.person, size: AppLayout.iconSize),
        label: 'Login',
      ),
    ],
    onDestinationSelected: (index) {},
  );
}

class AppNavigationRail extends StatelessWidget {
  const AppNavigationRail({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.shopping_bag_outlined, size: AppLayout.iconSize),
          selectedIcon: Icon(Icons.shopping_bag, size: AppLayout.iconSize),
          label: Text('Shop'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings_outlined, size: AppLayout.iconSize),
          selectedIcon: Icon(Icons.settings, size: AppLayout.iconSize),
          label: Text('Services'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.build_outlined, size: AppLayout.iconSize),
          selectedIcon: Icon(Icons.build, size: AppLayout.iconSize),
          label: Text('DIY'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person_outline, size: AppLayout.iconSize),
          selectedIcon: Icon(Icons.person, size: AppLayout.iconSize),
          label: Text('Login'),
        ),
      ],
      selectedIndex: 0,
    );
  }
}
