// Task: Safe E-Commerce Order Processor

double processOrder({
  required int orderId,
  required double itemPrice,
  String? promoCode,
  double? deliveryFee,
}) {
  double price = itemPrice;
  if (promoCode == 'SAVE10') {
    price = price * 0.9;
  }

  double fee = deliveryFee ?? 500.0;
  double total = price + fee;

  print(
    "Order #$orderId: item price $price T, delivery fee $fee T, total: $total T",
  );
  return total;
}

void main() {
  processOrder(orderId: 1, itemPrice: 10000.0);
  processOrder(orderId: 2, itemPrice: 10000.0, promoCode: 'SAVE10');
  processOrder(orderId: 3, itemPrice: 5000.0, deliveryFee: 0.0);
  processOrder(
    orderId: 4,
    itemPrice: 5000.0,
    promoCode: 'SAVE10',
    deliveryFee: 300.0,
  );
}