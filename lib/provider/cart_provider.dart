import 'package:eshopee/models/cart_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, CartModel>>(
  (ref) {
    return CartNotifier();
  },
);

class CartNotifier extends StateNotifier<Map<String, CartModel>> {
  CartNotifier() : super({});

  void addProductToCart({
    required String productName,
    required int productPrice,
    required String categoryName,
    required List imageUrl,
    required int quantity,
    required int instock,
    required String productId,
    required String productSize,
    required int discount,
    required String description,
  }) {
    if (state.containsKey(productId)) {
      // Product already exists in cart, increment quantity
      state = {
        ...state,
        productId: CartModel(
          productName: state[productId]!.productName,
          productPrice: state[productId]!.productPrice,
          categoryName: state[productId]!.categoryName,
          imageUrl: state[productId]!.imageUrl,
          quantity: state[productId]!.quantity + 1,
          instock: state[productId]!.instock,
          productId: state[productId]!.productId,
          productSize: state[productId]!.productSize,
          discount: state[productId]!.discount,
          description: state[productId]!.description,
        ),
      };
    } else {
      // Product does not exist in cart, add new entry
      state = {
        ...state,
        productId: CartModel(
          productName: productName,
          productPrice: productPrice,
          categoryName: categoryName,
          imageUrl: imageUrl,
          quantity: quantity,
          instock: instock,
          productId: productId,
          productSize: productSize,
          discount: discount,
          description: description,
        )
      };
    }

    // Notify listeners that the state has changed
    state = {...state};
  }

  // Function to remove item from cart
  void removeItem(String productId) {
    state.remove(productId);
    // Notify listeners that the state has changed
    state = {...state};
  }

  // Function to increment cart item quantity
  void incrementItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.quantity++;
    }
    // Notify listeners that the state has changed
    state = {...state};
  }

  // Function to decrement cart item quantity
  void decrementItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.quantity--;
    }
    // Notify listeners that the state has changed
    state = {...state};
  }

  // Calculate total amount in cart
  double calculateTotalAmount() {
    double totalAmount = 0.0;
    state.forEach((productId, cartItem) {
      totalAmount +=
          cartItem.quantity * cartItem.productPrice; // Adjusted calculation
    });
    return totalAmount;
  }

  // Getter to retrieve all cart items
  Map<String, CartModel> get getCartItem => state;
}
