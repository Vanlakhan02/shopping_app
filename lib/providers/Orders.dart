import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shopping_app/widgets/Cart_item.dart';
import './carts.dart';

class OrderItem{
  final String id;
  final double amount;
  final List<cartItem> product;
  final DateTime datetime;


  OrderItem({
    required this.id,
    required this.amount,
    required this.product,
    required this.datetime
  });
}
class Orders with ChangeNotifier{
    List<OrderItem> _orders = [];
    final String authToken;
    final String userId;
 
    Orders(this.authToken, this._orders, this.userId);
    List<OrderItem> get orders{
      return [..._orders];
    }
    Future<void> fetchAndsetOrders() async{
       final url = Uri.parse("https://learning-f4b67-default-rtdb.firebaseio.com/Order/$userId.json?auth=$authToken");
       final respone = await http.get(url);
       final List<OrderItem> loadingOrder = [];
       final extractedData = json.decode(respone.body) as Map<String, dynamic>;
       if(extractedData == null){
         return;
       }
       extractedData.forEach((orderId, value) {
         loadingOrder.add(OrderItem(id: orderId, amount: value['amount'], datetime: DateTime.parse(value['dateTime']), product: (value['products'] as List<dynamic>).map((item){
           return cartItem(id: item['id'],price: item['price'], quantity: item['quantity'], title: item['title']);
         }).toList() ));
        });
        _orders = loadingOrder.reversed.toList();
        notifyListeners();
    }
    Future<void> addOrder(List<cartItem> cartProduct, double total) async{
      final url = Uri.parse("https://learning-f4b67-default-rtdb.firebaseio.com/Order/$userId.json?auth=$authToken");
      final timeStamp = DateTime.now();
     final respone = await http.post(url, body: json.encode({
        'amount' : total,
        'dateTime' : timeStamp.toIso8601String(),
        'products' : cartProduct.map((cp) { 
          return{
          'id' : cp.id,
          'title' : cp.title,
          'quantity' : cp.quantity,
          'price' : cp.price
        };}).toList()
      }));
      print(json.decode(respone.body)['name']);
      _orders.insert(0, OrderItem(id: json.decode(respone.body)['name'], amount: total, product: cartProduct, datetime: timeStamp));
    }
}