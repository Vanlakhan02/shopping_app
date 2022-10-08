import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/Orders.dart';
import '../widgets/Order_item.dart' as ordItem;

class OrderScreen extends StatelessWidget {
  static const routeName = "/orderScreen";
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   // final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(title: Text("YOUR ORDERS")),
        body: FutureBuilder(
            future:
                Provider.of<Orders>(context, listen: false).fetchAndsetOrders(),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                if (dataSnapshot.error != null) {
                  return Center(child: Text("An error occurred"));
                } else {
                  return Consumer<Orders>(builder: (ctx, orderData, child){
                    return ListView.builder(
                      itemCount: orderData.orders.length,
                      itemBuilder: (context, index) {
                        return ordItem.OrderItem(
                            order: orderData.orders[index]);
                      });
                  });
                }
              }
            }));
  }
}
