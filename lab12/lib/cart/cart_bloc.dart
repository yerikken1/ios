import 'package:flutter_bloc/flutter_bloc.dart';

import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState.initial()) {
    on<AddProductEvent>((event, emit) {
      final updatedItems = [...state.items, event.product];

      emit(
        CartState(
          items: updatedItems,
          totalPrice: updatedItems.fold(
            0.0,
            (sum, item) => sum + item.price,
          ),
          count: updatedItems.length,
        ),
      );
    });

    on<RemoveProductEvent>((event, emit) {
      final updatedItems = [...state.items];
      final index = updatedItems.indexWhere(
        (item) => item.id == event.productId,
      );

      if (index != -1) {
        updatedItems.removeAt(index);
      }

      emit(
        CartState(
          items: updatedItems,
          totalPrice: updatedItems.fold(
            0.0,
            (sum, item) => sum + item.price,
          ),
          count: updatedItems.length,
        ),
      );
    });

    on<ClearCartEvent>((event, emit) {
      emit(CartState.initial());
    });
  }
}
