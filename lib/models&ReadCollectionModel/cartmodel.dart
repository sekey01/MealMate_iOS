import 'package:flutter/material.dart';

class CartFood extends ChangeNotifier {
  final String imgUrl;
  final String restaurant;
  final String foodName;
  final double price;
  final String id;
  final String location;
  final String time;
  final String vendorId;
  final bool isAvailable;
  final String adminEmail;
  final int adminContact;
  final int maxDistance;

  CartFood({
    required this.imgUrl,
    required this.restaurant,
    required this.foodName,
    required this.price,
    required this.id,
    required this.location,
    required this.time,
    required this.vendorId,
    required this.isAvailable,
    required this.adminEmail,
    required this.adminContact,
    required this.maxDistance,
  });
}

class CartModel extends ChangeNotifier {
  List<CartFood> cart = [];

  double get tPrice {
    double total = 0;
    for (int i = 0; i < cart.length; i++) {
      total += cart[i].price;
    }
    return total;
  }

  String getId(int index) {
    if (index >= 0 && index < cart.length) {
      return cart[index].id;
    } else {
      throw RangeError('Index out of bounds');
    }
  }

  void add(CartFood cartItem) {
    cart.add(cartItem);
    notifyListeners();
  }

  void removeAt(int index) {
    if (index >= 0 && index < cart.length) {
      cart.removeAt(index);
      notifyListeners();
    } else {
      throw RangeError('Index out of bounds');
    }
  }
  void remove(int index) {
    for (int i = 0; i < cart.length; i++) {
      if (cart[i].id == index) {
        cart.removeAt(i);
        notifyListeners();
        break; // Remove only the first match
      }
    }
  }

  void clearCart() {
    cart.clear();
    notifyListeners();
  }

  int quantity = 1;

  int get getQuantity => quantity;

  set setQuantity(int totalQuantity) {
    quantity = totalQuantity;
    notifyListeners();
  }

  void incrementQuantity() {
    quantity++;
    notifyListeners();
  }

  void decrementQuantity() {
    if (quantity > 1) {
      quantity--;
    }
    notifyListeners();
  }
}