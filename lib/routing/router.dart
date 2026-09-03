import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../ui/home/widgets/home_screen.dart';
import '../ui/recipes/widgets/recipes_screen.dart';
import '../ui/core/layout/layout_scaffold.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => LayoutScaffold(
        navigationShell: navigationShell,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (BuildContext context, GoRouterState state) => RecipesScreen()
            )
          ]
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/recipes',
              builder: (BuildContext context, GoRouterState state) => RecipesScreen()
            )
          ]
        )
      ]
    )
  ]
);
