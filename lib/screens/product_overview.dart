import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/widgets/App_Drawer.dart';
import '../widgets/Product_grid.dart';
import '../widgets/badge.dart';
import '../providers/carts.dart';
import 'CartScreen.dart';
import '../providers/products.dart';

enum FilterOption {
  Favorite,
  All,
}

class Product_overview extends StatefulWidget {
  @override
  State<Product_overview> createState() => _Product_overviewState();
}

class _Product_overviewState extends State<Product_overview> {
  var _showOnlyFavorite = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
   // Future.delayed(Duration.zero).then((value) {
  //      Provider.of<Products>(context).fetchAndSetProduct();
  //  },);
  //  Provider.of<Products>(context).fetchAndSetProduct();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if(_isInit){
      setState(() {
        _isLoading = true;
      });
       Provider.of<Products>(context).fetchAndSetProduct().then((_) {
         setState(() {
           print("is work?");
              _isLoading = false;
         });
       });
    }
    _isInit = false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    // final productsContainer = Provider.of<Products>(context, listen: false);
    return Scaffold(
        appBar: AppBar(title: const Text("My Shopping"), actions: [
          PopupMenuButton(
              onSelected: (FilterOption selectedValue) {
                setState(() {
                  if (selectedValue == FilterOption.Favorite) {
                    _showOnlyFavorite = true;
                  } else {
                    _showOnlyFavorite = false;
                  }
                });
              },
              itemBuilder: (_) => [
                    PopupMenuItem(
                        child: Text("only Favorite"),
                        value: FilterOption.Favorite),
                    PopupMenuItem(
                        child: Text("show all"), value: FilterOption.All),
                  ],
              icon: Icon(Icons.more_vert)),
          Consumer<carts>(
              builder: (_, cartData, ch) => Badge(
                  child: ch as Widget,
                  value: cartData.Itemcount.toString(),
                   ),
                  child: IconButton(icon: Icon(Icons.shopping_cart), onPressed: (){
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },)
                  )
        ]),
        drawer: AppDrawer(),
        body: _isLoading? Center(child: CircularProgressIndicator()) : ProductGrid(showFavorite: _showOnlyFavorite));
  }
}
