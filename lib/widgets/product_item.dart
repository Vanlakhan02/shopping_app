import 'package:flutter/material.dart';
import '../screens/product_detail.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import '../providers/carts.dart';
import '../providers/Auth.dart';

class Product_Item extends StatelessWidget {
  //final String id;
  //final String title;
  //final String imageUrl;
  // const Product_Item({required this.id, required this.title,required this.imageUrl, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<carts>(context, listen: false);
    final authData = Provider.of<Auth>(context);

    print('product rebuild');
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
          child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(Product_Detail_Screen.routeName,
                    arguments: product.id);
              },
              child: Hero(
                tag:product.id,
                child: FadeInImage(placeholder: AssetImage('Assets/Image/t-shirt.png'),image: NetworkImage(product.imageUrl), fit: BoxFit.cover))),
          footer: GridTileBar(
              backgroundColor: Colors.black87,
              leading: Consumer<Product>(
                builder: (context, product, child) => IconButton(
                  icon: Icon(product.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  onPressed: () {
                    product.toggleFavoriteStatus(authData.token, authData.userID);
                  },
                  color: Colors.red,
                ),
              ),
              trailing: IconButton(
                  onPressed: () {
                    cart.addItem(product.id, product.title, product.price);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "Added Item to carts",
                        textAlign: TextAlign.center,
                      ),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(label: "UNDO", onPressed: (){
                        cart.removeSingleItem(product.id);
                      },)
                    ));
                  },
                  icon: Icon(Icons.shopping_cart),
                  color: Theme.of(context).accentColor),
              title: Text(
                product.title,
                textAlign: TextAlign.center,
              ))),
    );
  }
}
