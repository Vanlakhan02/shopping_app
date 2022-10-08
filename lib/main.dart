import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/helper/custom_route.dart';
import 'package:shopping_app/screens/CartScreen.dart';
import 'package:shopping_app/screens/auth_screen.dart';
import './screens/product_overview.dart';
import './screens/product_detail.dart';
import './providers/products.dart';
import './providers/carts.dart';
import './providers/Orders.dart';
import 'screens/Order_Screeen.dart';
import './screens/User_Product_Screen.dart';
import './screens/Edit_Product_Screen.dart';
import './providers/Auth.dart';
import './screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(update:(ctx, authData, previousProducts)=> Products(authData.token,previousProducts == null? [] :previousProducts.items, authData.userID), create: (ctx)=> Products("", [], "")),
        ChangeNotifierProvider(
          create: (ctx) => carts(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(update: (ctx, authData, previousData)=> Orders(authData.token, previousData!.orders,authData.userId ), create:(ctx)=> Orders("", [], ""))
      ],
      child: Consumer<Auth>(builder:(ctx, authData, child){
          return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CustomPageTransitionBuilder(),
            TargetPlatform.iOS: CustomPageTransitionBuilder(),
          })
          // fontFamily: "Defago Notosans"
        ),
        home: authData.isAuth ?Product_overview() :FutureBuilder(future: authData.tryAutologin(), builder: (context, authResult)=> authResult.connectionState == ConnectionState.waiting? SplashScreen():AuthScreen()) ,
        routes: {
          Product_Detail_Screen.routeName: (context) => Product_Detail_Screen(),
          CartScreen.routeName :(context) => CartScreen(),
          OrderScreen.routeName : (context) => OrderScreen(  ),
          UserProductScreen.routeName : (context)=> UserProductScreen(),
          EditScreen.routeName : (context)=> EditScreen()
        },
      );
      } ),
    );
  }
}
