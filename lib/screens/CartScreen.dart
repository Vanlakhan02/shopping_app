import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/carts.dart';
import '../widgets/Cart_item.dart';
import '../providers/Orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<carts>(context);
    return Scaffold(
        appBar: AppBar(title: Text("Your cart")),
        body: Column(children: [
          Card(
              margin: const EdgeInsets.all(15),
              child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("total", style: TextStyle(fontSize: 20)),
                        Spacer(),
                        Chip(
                          label: Text('\$${cart.totalAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .primaryTextTheme
                                      .headline6!
                                      .color)),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        OrderButton(cart: cart)
                      ]))),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (ctx, index) {
              return CartItem(
                id: cart.items.values.toList()[index].id,
                price: cart.items.values.toList()[index].price,
                quantity: cart.items.values.toList()[index].quantity,
                title: cart.items.values.toList()[index].title, productId: cart.items.keys.toList()[index],
              );
            },
          ))
        ]));
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final carts cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed:(widget.cart.totalAmount <= 0 || _isLoading) ? null : () async{
          setState(() {
            _isLoading = true;
          });
         await Provider.of<Orders>(context, listen: false).addOrder(widget.cart.items.values.toList(), widget.cart.totalAmount);
          setState(() {
            _isLoading = false;
          });
          widget.cart.clear();
        },
        child:_isLoading ? CircularProgressIndicator() :const Text("order now"),
        style: TextButton.styleFrom(
            primary: Theme.of(context).primaryColor));
  }
}
