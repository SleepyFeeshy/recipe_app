import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../routing/destination.dart';

class LayoutScaffold extends StatelessWidget{
  const LayoutScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        // indicatorColor: Theme.of(context).primaryColor,
        destinations: destinations
          .map((destination) => NavigationDestination(icon: Icon(destination.icon), label: destination.label)).toList(),
      ),
    );
  }
}