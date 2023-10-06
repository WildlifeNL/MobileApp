import 'dart:io';

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

  @override
  Widget build(BuildContext context) {
    var items = [
      (
        NavigationDestination(
          icon: Icon(
            AppIcons.home_outlined,
            color: selectedIndex == 0
                ? Colors.green
                : Colors.black.withOpacity(0.6),
          ),
          label: "Home",
        ),
        const ExamplePage(),
      ),
      (
        NavigationDestination(
          icon: Icon(
            AppIcons.deer,
            color: selectedIndex == 1
                ? Colors.green
                : Colors.black.withOpacity(0.6),
          ),
          label: "Activity",
        ),
        const ExamplePage(),
      ),
      (
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
        const ExamplePage(),
      ),
      (
        NavigationDestination(
          icon: Icon(
            AppIcons.project_outlined,
            color: selectedIndex == 3
                ? Colors.green
                : Colors.black.withOpacity(0.6),
          ),
          label: "Project",
        ),
        const ExamplePage(),
      ),
      (
        NavigationDestination(
          icon: Icon(
            AppIcons.profile_outlined,
            color: selectedIndex == 4
                ? Colors.green
                : Colors.black.withOpacity(0.6),
          ),
          label: "Profile",
        ),
        const ExamplePage(),
      ),
    ];

    return Scaffold(
      body: items[selectedIndex].$2,
      bottomNavigationBar: Transform.translate(
        offset: Offset(0, Platform.isAndroid ? 0 : 34),
        child: Stack(
          children: [
            const CustomNavBarBackground(),
            CustomNavBarForeground(
              onDestinationSelected: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              items: items.map((x) => x.$1).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomNavBarForeground extends StatefulWidget {
  const CustomNavBarForeground({
    super.key,
    required this.items,
    required this.onDestinationSelected,
  });

  final List<NavigationDestination> items;

  final Function(int)? onDestinationSelected;

  @override
  State<CustomNavBarForeground> createState() => _CustomNavBarForegroundState();
}

class _CustomNavBarForegroundState extends State<CustomNavBarForeground> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(splashColor: Colors.transparent),
      child: Transform(
        transform: Transform.translate(offset: const Offset(0, -10)).transform,
        child: NavigationBar(
          animationDuration: Duration.zero,
          height: 100,
          indicatorColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          destinations: widget.items,
          selectedIndex: selectedIndex,
          onDestinationSelected: widget.onDestinationSelected,
        ),
      ),
    );
  }
}

class CustomNavBarBackground extends StatelessWidget {
  const CustomNavBarBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
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
    );
  }
}
