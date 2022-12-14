import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/Orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  const OrderItem({required this.order, Key? key}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded ? min(widget.order.product.length * 20.0 + 110, 280): 95,
      child: Card(
          margin: const EdgeInsets.all(10),
          child: Column(children: [
            ListTile(
                title: Text('\$${widget.order.amount}'),
                subtitle: Text(
                    DateFormat("dd-MM-yyyy hh:mm").format(widget.order.datetime)),
                trailing: IconButton(
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() => _expanded = !_expanded);
                  },
                )),
              AnimatedContainer(
                duration: Duration(milliseconds:  300),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                  height:_expanded? min(widget.order.product.length * 20.0 + 10, 180): 0,
                  child: ListView(
                      children: widget.order.product.map((element) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text(element.title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('${element.quantity} x \$${element.price}', style: TextStyle(fontSize: 18, color: Colors.grey))
                    ]);
                  }).toList()))
          ])),
    );
  }
}
