// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:animations/animations.dart';
import 'package:collection/collection.dart';
import 'package:cupertino_compass/screens/explore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'auth.dart';
import 'model/app_data.dart';
import 'scaffold.dart';
import 'screens/login.dart';
import 'screens/messages.dart';
import 'screens/my_trips.dart';
import 'screens/profile.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final myTripsNavKey = GlobalKey<NavigatorState>(debugLabel: 'my-trips');
final exploreNavKey = GlobalKey<NavigatorState>(debugLabel: 'explore');
final messagesNavKey = GlobalKey<NavigatorState>(debugLabel: 'messages');
final profileNavKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

class CompassAppRouter {
  final CompassAppAuth auth;

  CompassAppRouter(this.auth);

  late final GoRouter router = GoRouter(
    initialLocation: '/explore',
    navigatorKey: navigatorKey,
    refreshListenable: auth,
    redirect: (BuildContext context, GoRouterState state) {
      final loggedIn = auth.isLoggedIn;
      final loggingIn = state.matchedLocation == '/login';

      if (!loggedIn) {
        return loggingIn ? null : '/login';
      }

      if (loggingIn) {
        return '/explore';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
      StatefulShellRoute(
        parentNavigatorKey: navigatorKey,
        builder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        navigatorContainerBuilder: (
          BuildContext context,
          StatefulNavigationShell navigationShell,
          List<Widget> children,
        ) {
          return _AnimatedBranchContainer(
            navigationShell: navigationShell,
            children: children,
          );
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: exploreNavKey,
            routes: <RouteBase>[
              GoRoute(
                path: '/explore',
                builder: (context, state) => ExploreScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: myTripsNavKey,
            routes: <RouteBase>[
              GoRoute(
                path: '/my_trips',
                builder:
                    (context, state) =>
                        MyTripsScreen(appData: context.read<CompassAppData>()),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: messagesNavKey,
            routes: <RouteBase>[
              GoRoute(
                path: '/messages',
                builder: (context, state) => MessagesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: profileNavKey,
            routes: <RouteBase>[
              GoRoute(
                path: '/profile',
                builder: (context, state) => ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class _AnimatedBranchContainer extends StatefulWidget {
  const _AnimatedBranchContainer({
    required this.navigationShell,
    required this.children,
  });

  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  @override
  State<_AnimatedBranchContainer> createState() =>
      _AnimatedBranchContainerState();
}

class _AnimatedBranchContainerState extends State<_AnimatedBranchContainer> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children:
          widget.children.mapIndexed((int index, Widget child) {
            return _AnimatedOffstageNavigator(
              isActive: widget.navigationShell.currentIndex == index,
              child: child,
            );
          }).toList(),
    );
  }
}

class _AnimatedOffstageNavigator extends StatefulWidget {
  const _AnimatedOffstageNavigator({
    required this.isActive,
    required this.child,
  });

  final bool isActive;
  final Widget child;

  @override
  State<_AnimatedOffstageNavigator> createState() =>
      _AnimatedOffstageNavigatorState();
}

class _AnimatedOffstageNavigatorState extends State<_AnimatedOffstageNavigator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _secondaryAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = _controller.drive(CurveTween(curve: Curves.easeOutQuad));
    _secondaryAnimation = ReverseAnimation(_animation);
    if (widget.isActive) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _AnimatedOffstageNavigator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Positioned.fill(
          child: IgnorePointer(
            ignoring: !widget.isActive,
            child:
                isIOS
                    ? FadeTransition(
                      opacity: _animation,
                      child: TickerMode(
                        enabled: widget.isActive,
                        child: child!,
                      ),
                    )
                    : FadeThroughTransition(
                      animation: _animation,
                      fillColor: Colors.transparent,
                      secondaryAnimation: _secondaryAnimation,
                      child: TickerMode(
                        enabled: widget.isActive,
                        child: child!,
                      ),
                    ),
          ),
        );
      },
      child: widget.child,
    );
  }
}
