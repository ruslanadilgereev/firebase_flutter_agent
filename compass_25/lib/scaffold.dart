import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'theme.dart';

class _Location {
  String route;
  String label;
  String iconAsset;

  _Location(this.route, this.label, this.iconAsset);
}

final List<_Location> _locations = [
  _Location('/explore', 'Explore', 'assets/icons/explore.png'),
  _Location('/my_trips', 'My Activities', 'assets/icons/directions_run.png'),
  _Location('/messages', 'Messages', 'assets/icons/chat.png'),
  _Location('/profile', 'Profile', 'assets/icons/user.png'),
];

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const ScaffoldWithNavBar({super.key, required this.navigationShell});
  @override
  Widget build(BuildContext context) {
    var currentIndex = _calculateSelectedIndex(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar:
          Platform.isIOS
              ? CupertinoTabBar(
                backgroundColor: Colors.white,
                border: const Border(
                  top: BorderSide(color: Colors.grey, width: 0.0),
                ),
                iconSize: 24,
                items:
                    _locations.mapIndexed((index, location) {
                      return BottomNavigationBarItem(
                        icon: Image.asset(
                          location.iconAsset,
                          width: 24,
                          height: 24,
                          color:
                              index == currentIndex
                                  ? AppColors.primary
                                  : Colors.grey,
                        ),
                        label: location.label,
                      );
                    }).toList(),
                currentIndex: currentIndex,
                onTap: (int index) => _onItemTapped(index, context),
              )
              : BottomNavigationBar(
                //Removed SizedBox here.
                type: BottomNavigationBarType.fixed,
                items:
                    _locations
                        .mapIndexed(
                          (index, location) => BottomNavigationBarItem(
                            label: location.label,
                            icon: Image.asset(
                              location.iconAsset,
                              color:
                                  index == currentIndex
                                      ? AppColors.primary
                                      : Colors.grey,
                              width: 24,
                              height: 24,
                            ),
                          ),
                        )
                        .toList(),
                currentIndex: _calculateSelectedIndex(context),
                selectedItemColor: Theme.of(context).colorScheme.primary,
                selectedIconTheme: IconThemeData(color: AppColors.primary),
                unselectedFontSize: 10,
                selectedFontSize: 12,
                onTap: (int idx) => _onItemTapped(idx, context),
              ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String uriPath = GoRouterState.of(context).uri.path;
    for (var i = 0; i < _locations.length; i++) {
      final location = _locations[i];
      if (uriPath.startsWith(location.route)) {
        return i;
      }
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    navigationShell.goBranch(index);
  }
}
