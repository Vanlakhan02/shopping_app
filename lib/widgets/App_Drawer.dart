import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helper/custom_route.dart';
import '../providers/Auth.dart';
import 'package:shopping_app/screens/Order_Screeen.dart';
import '../screens/User_Product_Screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(children: [
      AppBar(
        title: Text("hello friend!"),
        automaticallyImplyLeading: false,
      ),
      Divider(),
      ListTile(
          leading: Icon(Icons.shop),
          title: Text("shop"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          }),
      Divider(),
      ListTile(
          leading: Icon(Icons.payment),
          title: Text("YOUR ORDERS"),
          onTap: () {
            //Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            Navigator.of(context).pushReplacement(CustomRoute(builder: (BuildContext context) => OrderScreen(), settings: null),);
          }),
      Divider(),
      ListTile(
          leading: Icon(Icons.edit),
          title: Text("MANAGE RPODUCT"),
          onTap: () {
            Navigator.of(context).pushNamed(UserProductScreen.routeName);
          }),
      Divider(),
      ListTile(
          leading: const Icon(Icons.exit_to_app),
          title:const Text("LOG OUT"),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/');
            Provider.of<Auth>(context, listen: false).logout();
          })
    ]));
  }
}
