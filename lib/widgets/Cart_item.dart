import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/carts.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  const CartItem(
      {required this.id,
      required this.productId,
      required this.price,
      required this.quantity,
      required this.title,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
          child: Icon(Icons.delete, color: Colors.white, size: 20),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          color: Theme.of(context).errorColor),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (contex) {
              return AlertDialog(
                  title: Text("Are your sure?"),
                  content:
                      Text("Do you want to remove the item from the carts"),
                  actions: [
                    TextButton(child: Text("NO"), onPressed: (){
                      Navigator.of(context).pop(false);
                    }),
                    TextButton(child: Text("YES"), onPressed: (){
                      Navigator.of(context).pop(true);
                    })
                  ]
                      );
            });
      },
      onDismissed: (direction) {
        Provider.of<carts>(context, listen: false).removeItem(productId);
      },
      child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: ListTile(
              leading: CircleAvatar(
                  child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(child: Text('\$ ${price}')),
              )),
              title: Text(title),
              subtitle: Text("Total: \$${price * quantity}"),
              trailing: Text('$quantity x'))),
    );
  }
}
