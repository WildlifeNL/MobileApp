import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wildlife_nl_app/pages/example.dart';
import 'package:wildlife_nl_app/pages/report.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';
import 'package:wildlife_nl_app/utilities/app_icons.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    value: 1,
    lowerBound: 0,
    upperBound: 1,
    duration: Duration(
        milliseconds: MediaQuery.of(context).disableAnimations ? 0 : 175),
    vsync: this,
  );

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var items = [
      (
        const NavigationDestination(
          icon: Icon(
            AppIcons.home,
          ),
          label: "Home",
        ),
        const ExamplePage(),
      ),
      (
        const NavigationDestination(
          icon: Icon(
            AppIcons.report_list,
          ),
          label: "Activiteit",
        ),
        const ExamplePage(),
      ),
      (
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                //TODO: Scaffold should be replaced with the create a report page.
                builder: (context) => ReportPage(),
              ),
            );
          },
          child: NavigationDestination(
            icon: AnimatedReportIcon(
              controller: _controller,
              animationIntensity: 0.7,
              shadow: 1,
            ),
            label: "",
            enabled: false,
          ),
        ),
        const ExamplePage(),
      ),
      (
        const NavigationDestination(
          icon: Icon(
            AppIcons.map,
          ),
          label: "Kaart",
        ),
        const ExamplePage(),
      ),
      (
        const NavigationDestination(
          icon: Icon(
            AppIcons.person_outlined,
          ),
          label: "Profiel",
        ),
        const ExamplePage(),
      )
    ];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: AppColors.neutral_50,
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: items[selectedIndex].$2,
      ),
      backgroundColor: AppColors.neutral_50,
      extendBody: true,
      bottomNavigationBar: Transform.translate(
          offset: Offset(0, Platform.isAndroid ? 12 : 34),
          child: Stack(children: [
            const CustomNavBarBackground(),
            CustomNavBarForeground(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) {
                Future.delayed(Duration.zero, () async {
                  if (index == 2) {
                    await _controller.animateTo(0, curve: Curves.easeInCubic);
                    await _controller.animateBack(1, curve: Curves.easeInCubic);
                  }
                });
                setState(() {
                  selectedIndex = index;
                });
              },
              items: items.map((x) => x.$1).toList(),
            )
          ])),
    );
  }
}

class AnimatedReportIcon extends StatelessWidget {
  const AnimatedReportIcon({
    super.key,
    required AnimationController controller,
    required this.animationIntensity,
    required this.shadow,
  }) : _controller = controller;

  final AnimationController _controller;
  final double animationIntensity;
  final double shadow;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 8 +
                      2 * animationIntensity -
                      2 * _controller.value * animationIntensity,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
              ),
              child: Container(
                width: 52 -
                    4 * animationIntensity +
                    4 * _controller.value * animationIntensity,
                height: 52 -
                    4 * animationIntensity +
                    4 * _controller.value * animationIntensity,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                  boxShadow: [
                    BoxShadow(
                        //color: Colors.black.withOpacity(0.1 + _controller.value * 0.1),
                        color: Color.fromRGBO(190, 213, 88,
                            0.25 * shadow + _controller.value * 0.25 * shadow),
                        offset: const Offset(0, 4),
                        blurRadius: 20,
                        spreadRadius: 0)
                  ],
                ),
                child: const Icon(
                  AppIcons.report,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          );
        });
  }
}

class CustomNavBarForeground extends StatefulWidget {
  const CustomNavBarForeground({
    super.key,
    required this.items,
    required this.onDestinationSelected,
    required this.selectedIndex,
  });

  final List<Widget> items;

  final Function(int)? onDestinationSelected;

  final int selectedIndex;

  @override
  State<CustomNavBarForeground> createState() => _CustomNavBarForegroundState();
}

class _CustomNavBarForegroundState extends State<CustomNavBarForeground> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(splashColor: Colors.transparent),
      child: Transform(
        transform: Transform.translate(offset: const Offset(0, -10)).transform,
        child: NavigationBar(
          animationDuration: Duration.zero,
          height: 92,
          indicatorColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          destinations: widget.items,
          selectedIndex: widget.selectedIndex,
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
