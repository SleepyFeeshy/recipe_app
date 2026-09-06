import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../ui/home/widgets/home_screen.dart';
import '../ui/recipes/widgets/recipes_screen.dart';
import '../ui/core/layout/layout_scaffold.dart';
import '../ui/recipes/widgets/recipe_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/recipes',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => LayoutScaffold(
        navigationShell: navigationShell,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/recipes',
              builder: (BuildContext context, GoRouterState state) => RecipesScreen()
            )
          ]
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/ingredients',
              builder: (BuildContext context, GoRouterState state) => RecipesScreen(),
              // routes: [
              //   GoRoute(
              //     path:':recipeId',
              //     builder: (context, state) => RecipePage(recipeId: state.pathParameters['recipeId']!),
              //   )
              // ]
            )
          ]
        )
      ]
    )
  ]
);
