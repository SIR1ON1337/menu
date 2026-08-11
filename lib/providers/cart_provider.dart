import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/menu_item.dart';

class CartItem {
  final MenuItem item;
  final int quantity;

  CartItem({required this.item, this.quantity = 1});

  CartItem copyWith({MenuItem? item, int? quantity}) {
    return CartItem(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(MenuItem menuItem) {
    final existingIndex = state.indexWhere((i) => i.item.id == menuItem.id);
    if (existingIndex != -1) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == existingIndex)
            state[i].copyWith(quantity: state[i].quantity + 1)
          else
            state[i]
      ];
    } else {
      state = [...state, CartItem(item: menuItem)];
    }
  }

  void removeItem(String itemId) {
    state = state.where((i) => i.item.id != itemId).toList();
  }

  void decreaseQuantity(String itemId) {
    final existingIndex = state.indexWhere((i) => i.item.id == itemId);
    if (existingIndex == -1) return;

    if (state[existingIndex].quantity > 1) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == existingIndex)
            state[i].copyWith(quantity: state[i].quantity - 1)
          else
            state[i]
      ];
    } else {
      removeItem(itemId);
    }
  }

  double get totalAmount {
    return state.fold(0, (sum, item) => sum + (item.item.price * item.quantity));
  }

  int get totalItems {
    return state.fold(0, (sum, item) => sum + item.quantity);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});
