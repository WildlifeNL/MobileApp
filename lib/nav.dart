import 'package:flutter/material.dart';
import 'package:wildlife_nl_app/pages/example.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int selectedIndex = 0;

  final List<Widget> children = [];
  final List<NavigationDestination> items = [];

  _addItem(NavigationDestination item, Widget child) {
    items.add(item);
    children.add(child);
  }

  @override
  void initState() {
    super.initState();
    _addItem(
        const NavigationDestination(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        const ExamplePage());
    _addItem(
        const NavigationDestination(
          icon: Icon(Icons.nature_people),
          label: "Example",
        ),
        const ExamplePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: children[selectedIndex],
      bottomNavigationBar: NavigationBar(
        destinations: items,
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
