import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/screens/Edit_Product_Screen.dart';
import 'package:shopping_app/widgets/User_Product_Item.dart';
import '../providers/products.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product';
  const UserProductScreen({Key? key}) : super(key: key);
  Future<void> _refreshProduct(BuildContext context) async{
    await Provider.of<Products>(context, listen: false).fetchAndSetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
   // final productData = Provider.of<Products>(context);

    return Scaffold(
        appBar: AppBar(title: const Text("Your Product"), actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditScreen.routeName);
              })
        ]),
        body: FutureBuilder(
          future: _refreshProduct(context),
          builder:(context, snapshot)=> snapshot.connectionState == ConnectionState.waiting ? const Center(child: CircularProgressIndicator()) : RefreshIndicator(
            onRefresh: ()=> _refreshProduct(context),
            child: Consumer<Products>(
              builder:(ctx, productData, child)=> Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListView.builder(
                      itemCount: productData.items.length,
                      itemBuilder: (ctx, index) {
                        return Column(
                          children: [
                            UserItem(
                                id: productData.items[index].id,
                                title: productData.items[index].title,
                                imageUrl: productData.items[index].imageUrl),
                            Divider(),
                          ],
                        );
                      })),
            ),
          ),
        ));
  }
}
