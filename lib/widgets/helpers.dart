import 'package:flutter/material.dart';

typedef Widget IndexedDividedBuilder<T>(int index, T child);

NavigatorState rootNavigator(BuildContext context) {
  return Navigator.of(context, rootNavigator: true);
}

PageRouteBuilder<T> fadeInRoute<T>(
  Widget page, {
  Duration? duration,
  RouteSettings? settings,
}) {
  return new PageRouteBuilder<T>(
    settings: settings,
    pageBuilder: (_, __, ___) => page,
    transitionDuration: duration ?? Duration(milliseconds: 400),
    transitionsBuilder: (_, animation, __, child) {
      final tween = Tween<double>(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: Curves.ease),
      );
      return FadeTransition(opacity: tween.animate(animation), child: child);
    },
  );
}

Iterable<Widget> divideWidgets<T>({
  required Widget divider,
  required List<T> list,
  required IndexedDividedBuilder<T> builder,
}) sync* {
  if (list.isEmpty) return;

  final Iterator<T> iterator = list.iterator;
  final bool isNotEmpty = iterator.moveNext();

  T tile = iterator.current;
  int index = 0;
  while (iterator.moveNext()) {
    yield builder(index, tile);
    yield divider;
    tile = iterator.current;
    index++;
  }
  if (isNotEmpty) yield builder(index, tile);
}
