# lab10 — Cloud Product Explorer & Detail Carousel

Flutter app for https://fakestoreapi.com/products.

- `lib/models/product.dart` — `Product` model, `Product.fromJson` with null-safe fallbacks and `(json['price'] as num).toDouble()`
- `lib/services/product_service.dart` — `http.get` with a 10-second timeout, try-catch, status code handling (200 / 404 / 500)
- `lib/screens/product_list_screen.dart` — 3 UI states: Loading / Feed (`ListView.separated` + `RefreshIndicator`) / Error with "Retry Connection"
- `lib/screens/product_detail_screen.dart` — Hero (`product_image_${id}`), `PageView.builder` carousel with "1 / 3" counter and animated dots, category badge, sticky "Add to Cart"
- `lib/widgets/share_sheet.dart` — bottom sheet with deep link `narxoz://store/product/{id}` and a copy button

Offline test: turn on Airplane mode → pull to refresh / restart → error screen → turn off Airplane mode → "Retry Connection".
