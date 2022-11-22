import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/domain/repository_base.dart';
import 'package:pokedex/main.dart';

typedef OnObservation = Function(
  Route<dynamic> route,
  Route<dynamic>? previousRoute,
);

class TestUtils {
  TestUtils._();

  static Future<void> pumpApp(
    WidgetTester tester, {
    required RepositoryBase repository,
    NavigatorObserver? observer,
  }) async {
    await tester.pumpWidget(
      MyApp(
        repository: repository,
        navigatorObserver: observer,
      ),
    );

    await tester.pumpAndSettle();
  }

  static Future<void> pushDetailScreen(
    WidgetTester tester, {
    required RepositoryBase repository,
    NavigatorObserver? observer,
    required ValueKey key,
  }) async {
    await pumpApp(tester, repository: repository, observer: observer);

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(key));

    await tester.pumpAndSettle();
  }

  static Future<void> scrollWidget(
    WidgetTester tester, {
    required Key visibleKey,
  }) async {
    await tester.scrollUntilVisible(
      find.byKey(visibleKey),
      500.0,
      scrollable: find.byType(Scrollable),
    );

    await tester.pumpAndSettle();

    await Future.delayed(const Duration(seconds: 2));
  }
}

class TestNavigatorObserver extends NavigatorObserver {
  TestNavigatorObserver({this.onPushed, this.onPopped});

  OnObservation? onPushed;
  OnObservation? onPopped;

  @override
  void didPush(Route route, Route? previousRoute) {
    if (onPushed != null) {
      onPushed!(route, previousRoute);
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (onPopped != null) {
      onPopped!(route, previousRoute);
    }
  }
}
