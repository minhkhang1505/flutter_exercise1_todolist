import 'package:flutter/material.dart';

/// Custom tab bar widget for task filtering
class CustomTabBar extends StatelessWidget {
  final TabController controller;
  final List<String> tabs;

  const CustomTabBar({super.key, required this.controller, required this.tabs});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(50)),
      child: Container(
        height: 45,
        color: colorScheme.surfaceContainerHigh,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: TabBar(
            controller: controller,
            indicator: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            labelColor: colorScheme.onPrimary,
            unselectedLabelColor: colorScheme.primary,
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            tabs: tabs.map((tab) => Tab(text: tab)).toList(),
          ),
        ),
      ),
    );
  }
}