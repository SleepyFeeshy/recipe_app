import 'package:flutter/material.dart';

class Destination {
  const Destination({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

const destinations = {
  // Destination(label: 'Home', icon: Icons.home),
  Destination(label: 'Recipes', icon: Icons.book),
  Destination(label: 'Ingredients', icon: Icons.list),
  Destination(label: 'Shopping Lists', icon: Icons.shopping_basket),
  // Destination(label: 'Grocery Lists', icon: Icons.shop),
  // Destination(label: 'Profile', icon: Icons.person)
};