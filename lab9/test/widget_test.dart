import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:lab9/data/product_data.dart';
import 'package:lab9/main.dart';
import 'package:lab9/providers/cart_provider.dart';

Widget _app() => ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const CartApp(),
    );

String _badge(WidgetTester tester) =>
    tester.widget<Text>(find.byKey(const Key('cartBadgeCount'))).data!;

void main() {
  test('CartProvider add / remove / toggle / clear / total', () {
    final cart = CartProvider();
    cart.add(kProducts[0]);
    cart.add(kProducts[0]); // duplicate ignored
    cart.toggle(kProducts[1]);
    expect(cart.itemCount, 2);
    expect(cart.totalPrice, closeTo(129.99 + 199.00, 0.001));
    cart.toggle(kProducts[1]);
    expect(cart.contains(kProducts[1]), isFalse);
    cart.clear();
    expect(cart.isEmpty, isTrue);
  });

  testWidgets('Catalog shows 6 products and badge updates live',
      (tester) async {
    await tester.pumpWidget(_app());
    for (final p in kProducts) {
      await tester.scrollUntilVisible(
        find.byKey(Key('toggle_${p.id}_add')),
        100,
      );
      expect(find.byKey(Key('toggle_${p.id}_add')), findsOneWidget);
    }
    await tester.drag(find.byType(ListView), const Offset(0, 2000));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('toggle_p1_add')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('toggle_p3_add')));
    await tester.pumpAndSettle();
    expect(_badge(tester), '2');

    await tester.tap(find.byKey(const Key('toggle_p1_added')));
    await tester.pumpAndSettle();
    expect(_badge(tester), '1');
  });

  testWidgets('Removing on Cart screen syncs back to Catalog',
      (tester) async {
    await tester.pumpWidget(_app());
    await tester.tap(find.byKey(const Key('toggle_p1_add')));
    await tester.tap(find.byKey(const Key('toggle_p2_add')));
    await tester.tap(find.byKey(const Key('toggle_p3_add')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('cartBadgeButton')));
    await tester.pumpAndSettle();
    expect(find.text('My Cart'), findsOneWidget);
    expect(find.text('\$388.49'), findsOneWidget);

    await tester.tap(find.byKey(const Key('remove_p2')));
    await tester.pumpAndSettle();
    expect(find.text('\$189.49'), findsOneWidget);
    expect(_badge(tester), '2');

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('toggle_p2_add')), findsOneWidget);
    expect(find.byKey(const Key('toggle_p1_added')), findsOneWidget);
    expect(_badge(tester), '2');
  });

  testWidgets('Clear All empties cart and resets Catalog', (tester) async {
    await tester.pumpWidget(_app());
    await tester.tap(find.byKey(const Key('toggle_p1_add')));
    await tester.tap(find.byKey(const Key('toggle_p2_add')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('cartBadgeButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('clearAll')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirmClear')));
    await tester.pumpAndSettle();
    expect(find.text('Your cart is empty'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('toggle_p1_add')), findsOneWidget);
    expect(find.byKey(const Key('toggle_p2_add')), findsOneWidget);
  });
}
