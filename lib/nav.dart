import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:wildlife_nl_app/pages/example.dart';
import 'package:wildlife_nl_app/utilities/app_icons.dart';

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
  Widget build(BuildContext context) {
    children.clear();
    items.clear();
    _addItem(
        NavigationDestination(
          icon: Icon(
            AppIcons.home_outlined,
            color: selectedIndex == 0
                ? Colors.green
                : Colors.black.withOpacity(0.6),
          ),
          label: "Home",
        ),
        const ExamplePage());
    _addItem(
        NavigationDestination(
          icon: Icon(
            AppIcons.deer,
            color: selectedIndex == 1
                ? Colors.green
                : Colors.black.withOpacity(0.6),
          ),
          label: "Activity",
        ),
        const ExamplePage());
    _addItem(
        NavigationDestination(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                  border: Border.fromBorderSide(BorderSide(
                    color: Colors.white,
                    width: 8,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ))),
              child: const Icon(
                AppIcons.map,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
          label: "",
        ),
        const ExamplePage());
    _addItem(
        NavigationDestination(
          icon: Icon(
            AppIcons.project_outlined,
            color: selectedIndex == 3
                ? Colors.green
                : Colors.black.withOpacity(0.6),
          ),
          label: "Project",
        ),
        const ExamplePage());
    _addItem(
        NavigationDestination(
          icon: Icon(
            AppIcons.profile_outlined,
            color: selectedIndex == 4
                ? Colors.green
                : Colors.black.withOpacity(0.6),
          ),
          label: "Profile",
        ),
        const ExamplePage());

    return Scaffold(
      body: children[selectedIndex],
      bottomNavigationBar: Stack(
        children: [
          Container(
            height: 100,
            width: double.maxFinite,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadiusDirectional.vertical(
                  top: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, -5),
                    blurRadius: 35,
                    spreadRadius: 0,
                  ),
                ]),
            foregroundDecoration: const BoxDecoration(
              borderRadius: BorderRadiusDirectional.vertical(
                top: Radius.circular(32),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: null,
          ),
          Theme(
            data: Theme.of(context).copyWith(splashColor: Colors.transparent),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: NavigationBar(
                animationDuration: Duration.zero,
                height: 80,
                indicatorColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                destinations: items,
                selectedIndex: selectedIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
