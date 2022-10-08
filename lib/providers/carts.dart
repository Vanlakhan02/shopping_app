import 'package:flutter/cupertino.dart';

class cartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  cartItem(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.price});
}

class carts with ChangeNotifier {
  Map<String, cartItem> _items = {};

  Map<String, cartItem> get items {
    return {..._items};
  }

  int get Itemcount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });

    return total;
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      //change the quantity
      _items.update(
          productId,
          (existingCartItem) => cartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity + 1));
    } else {
      // add the new entry to the cartitem
      _items.putIfAbsent(productId, () {
        return cartItem(
            id: DateTime.now().toString(),
            title: title,
            quantity: 1,
            price: price);
      });
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
          productId,
          (value) => cartItem(
                id: value.id,
                title: value.title,
                price: value.price,
                quantity: value.quantity,
              ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
