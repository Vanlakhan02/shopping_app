import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import './product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavorite;
  const ProductGrid({
    required this.showFavorite,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  final productData =  Provider.of<Products>(context);
  final product =showFavorite ? productData.getFavoriteItem : productData.items;
    return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemCount: product.length,
        itemBuilder: (ctx, index) {
          return ChangeNotifierProvider.value(
            value: product[index],
           child: Product_Item(
         //     id: product[index].id,
         //     title: product[index].title,
         //     imageUrl:product[index].imageUrl) 
         ));
      });
  }
}