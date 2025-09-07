import 'package:flutter/material.dart';

class InheritedThemeModeNotifier extends InheritedWidget {
  final ValueNotifier<ThemeMode> notifier;
  const InheritedThemeModeNotifier({
    super.key,
    required this.notifier,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant InheritedThemeModeNotifier oldWidget) {
    return oldWidget.notifier != notifier;
  }
}