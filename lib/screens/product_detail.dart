import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class Product_Detail_Screen extends StatelessWidget {
  // final String title;
  // final double price;
  // const Product_Detail_Screen({required this.title,required this.price, Key? key }) : super(key: key);
  static const String routeName = "/product_detail";
  @override
  Widget build(BuildContext context) {
    final Pid = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(Pid);
    return Scaffold(
        //appBar: AppBar(title: Text(loadedProduct.title)),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(title: Text(loadedProduct.title),
             background:                     Hero(
                      tag:loadedProduct.id ,child: Image.network(loadedProduct.imageUrl, fit: BoxFit.cover)),
            )
            ),
            SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(height: 10),
            Text("\$${loadedProduct.price}",
                style: TextStyle(color: Colors.grey, fontSize: 20), textAlign: TextAlign.center,),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10,),
                child: Text(loadedProduct.description,
                    textAlign: TextAlign.center)),
                    SizedBox(height: 800,)
              ])
            ),
          ]
        ));
  }
}
