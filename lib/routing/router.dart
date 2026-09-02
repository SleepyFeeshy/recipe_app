import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../ui/home/widgets/home_screen.dart';
import '../ui/recipes/widgets/recipes_screen.dart';
import '../ui/core/layout/layout_scaffold.dart';

final GoRouter router = GoRouter(
  // routes: <RouteBase>[
  //   ShellRoute(
  //     routes: [
  //       GoRoute(
  //         path: '/',
  //         builder: (BuildContext context, GoRouterState state) => HomeScreen(),
  //     )],
  //     builder: (context, state, child) {
  //       return 
  //       Scaffold(
  //         body: child,
  //         bottomNavigationBar: NavigationBar(
  //         destinations: [
  //           NavigationDestination(icon: Icon(Icons.house), label: "Home"),
  //           NavigationDestination(icon: Icon(Icons.book), label: "Recipes")  
  //         ]),
  //       );
  //     }
  //   )
  // ],
  initialLocation: '/recipes',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => LayoutScaffold(
        navigationShell: navigationShell,
      ),
      branches: [
        // StatefulShellBranch(
        //   routes: [
        //     GoRoute(
        //       path: '/',
        //       builder: (BuildContext context, GoRouterState state) => HomeScreen()
        //     )
        //   ]
        // ),
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
