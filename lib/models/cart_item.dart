// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:coffeapp/models/coffe.dart'; 

class CartItem {
  final Coffee coffee;
  int quantity;

  CartItem({required this.coffee, this.quantity = 1});
}

final ValueNotifier<List<CartItem>> globalCart = ValueNotifier([]);

void addToCart(Coffee coffee) {
  bool itemDitemukan = false;

  for (var item in globalCart.value) {
    if (item.coffee.id == coffee.id) {
      item.quantity++; 
      itemDitemukan = true; 
      break; 
    }
  }

  if (!itemDitemukan) {
    globalCart.value.add(CartItem(coffee: coffee));
  }

  globalCart.notifyListeners();
}

void removeFromCart(CartItem cartItem) {
  if (cartItem.quantity > 1) {
    cartItem.quantity--;
  } else {
    globalCart.value.remove(cartItem);
  }
  globalCart.notifyListeners();
}

double calculateTotalPrice() {
  double total = 0;
  for (var item in globalCart.value) {
    total += item.coffee.price * item.quantity;
  }
  return total;
}