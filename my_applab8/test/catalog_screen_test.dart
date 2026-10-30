import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_applab8/data/product_data.dart';
import 'package:my_applab8/main.dart';

const _first = 'Aurora Wireless Headphones';
const _second = 'Pulse Fitness Band';

Future<void> _swipeDelete(WidgetTester tester, String title) async {
  await tester.drag(find.text(title), const Offset(-500, 0));
  await tester.pumpAndSettle();
}

Future<void> _pullToRefresh(WidgetTester tester) async {
  await tester.fling(find.byType(Scrollable).first, const Offset(0, 400), 1000);
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(milliseconds: 1500));
  await tester.pumpAndSettle();
}

double _top(WidgetTester tester, String title) =>
    tester.getTopLeft(find.text(title)).dy;

void main() {
  testWidgets('toggles between list and grid', (tester) async {
    await tester.pumpWidget(const SmartCatalogApp());
    expect(find.byType(ListView), findsOneWidget);

    await tester.tap(find.byIcon(Icons.grid_view));
    await tester.pumpAndSettle();
    expect(find.byType(GridView), findsOneWidget);
    expect(find.text(_first), findsOneWidget);

    await tester.tap(find.byIcon(Icons.view_list));
    await tester.pumpAndSettle();
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('swipe deletes and UNDO restores the original position', (
    tester,
  ) async {
    await tester.pumpWidget(const SmartCatalogApp());

    await _swipeDelete(tester, _second);
    expect(find.text(_second), findsNothing);
    expect(find.text('UNDO'), findsOneWidget);

    await tester.tap(find.text('UNDO'));
    await tester.pumpAndSettle();
    expect(_top(tester, _second), greaterThan(_top(tester, _first)));
    expect(
      _top(tester, _second),
      lessThan(_top(tester, 'Nimbus 14 Ultrabook')),
    );
  });

  testWidgets('swipe right does not delete', (tester) async {
    await tester.pumpWidget(const SmartCatalogApp());

    await tester.drag(find.text(_first), const Offset(500, 0));
    await tester.pumpAndSettle();
    expect(find.text(_first), findsOneWidget);
  });

  testWidgets('swipe deletes in grid mode too', (tester) async {
    await tester.pumpWidget(const SmartCatalogApp());
    await tester.tap(find.byIcon(Icons.grid_view));
    await tester.pumpAndSettle();

    await _swipeDelete(tester, _first);
    expect(find.text(_first), findsNothing);
    expect(find.text('UNDO'), findsOneWidget);
  });

  testWidgets('SnackBar with UNDO disappears by itself', (tester) async {
    await tester.pumpWidget(const SmartCatalogApp());

    await _swipeDelete(tester, _first);
    expect(find.byType(SnackBar), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('pull to refresh waits 1.5s and adds an item at index 0', (
    tester,
  ) async {
    await tester.pumpWidget(const SmartCatalogApp());

    await _pullToRefresh(tester);

    final newTitle = find.textContaining('#${seedProducts.length + 1}');
    expect(newTitle, findsOneWidget);
    expect(tester.getTopLeft(newTitle).dy, lessThan(_top(tester, _first)));
  });

  testWidgets('empty state appears and Reset Catalog restores seed data', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(400, 3000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const SmartCatalogApp());

    for (final product in seedProducts) {
      await _swipeDelete(tester, product.title);
    }
    expect(find.text('Catalog is Empty'), findsOneWidget);

    await tester.tap(find.text('Reset Catalog'));
    await tester.pumpAndSettle();
    expect(find.text(_first), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('UNDO brings back the last item from the empty state', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(400, 3000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const SmartCatalogApp());

    for (final product in seedProducts) {
      await _swipeDelete(tester, product.title);
    }
    await tester.tap(find.text('UNDO'));
    await tester.pumpAndSettle();

    expect(find.text('Catalog is Empty'), findsNothing);
    expect(find.text(seedProducts.last.title), findsOneWidget);
  });

  for (final (width, textScale) in [(280.0, 1.0), (320.0, 1.3), (412.0, 1.0)]) {
    testWidgets('no overflow at ${width}dp, text x$textScale', (tester) async {
      await tester.binding.setSurfaceSize(Size(width, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(
            size: Size(width, 900),
            textScaler: TextScaler.linear(textScale),
          ),
          child: const SmartCatalogApp(),
        ),
      );

      expect(tester.takeException(), isNull);

      await tester.tap(find.byIcon(Icons.grid_view));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
