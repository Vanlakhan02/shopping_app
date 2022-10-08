import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/models/http_Exception.dart';

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
 /*   Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),*/
  ];
  // var _showFavoriteOnly = false;
  List<Product> get items {
    //    if (_showFavoriteOnly){
    //      return _items.where((element) => element.isFavorite).toList();
    //    }
    return [..._items];
  }

  List<Product> get getFavoriteItem {
    return _items.where((element) => element.isFavorite).toList();
  }

  //  void showFavoriteOnly(){
  //    _showFavoriteOnly = true;
  //    notifyListeners();
  //  }
  //   void showAll(){
  //    _showFavoriteOnly = false;
  //    notifyListeners();
  //  }
  final String userId;
  final String  authToken;
  Products(this.authToken,this._items, this.userId);
  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProduct([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse("https://learning-f4b67-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString");
    try{
       final respone =  await http.get(url);
       print(json.encode(respone.body));
       final extractData = jsonDecode(respone.body) as Map<String, dynamic>;
       if(extractData == null){
         return;
       }
       url = Uri.parse("https://learning-f4b67-default-rtdb.firebaseio.com/user-favorite/$userId.json?auth=$authToken&$filterString");
       final favoriteRespone = await http.get(url);
       final favoriteData = jsonDecode(favoriteRespone.body) as Map<String, dynamic>;
       final List<Product> loadedProduct = [];
       extractData.forEach((prodId, prodData) {
         loadedProduct.add(Product(id: prodId,
         title: prodData['title'] ,
         description: prodData['description'],
         price: prodData['price'],
         imageUrl: prodData['imageUrl'],
         isFavorite:favoriteData == null ? false : favoriteData[prodId] ?? false
         ));
        });
        _items = loadedProduct;
        notifyListeners();
    }catch(error){
       throw (error);
    }
  }
  Future<void> addProduct(Product product) async{
    final url = Uri.https("learning-f4b67-default-rtdb.firebaseio.com", "/products.json", {'auth': '$authToken'});
   try{
     
       final respone = await http.post(url,
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'price': product.price,
              'isFavorite': product.isFavorite
            }));
                    
      final newProduct = Product(
          id: json.encode(respone.body)[1],
          title: product.title,
          price: product.price,
          description: product.description,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
   }catch(error){
     print("it shown");
     throw error;
   }
  
  }

  Future<void> updateProduct(String id, Product newProduct) async{
    final productIndex = _items.indexWhere((element) => element.id == id);
    if (productIndex >= 0) {
       final url = Uri.https("learning-f4b67-default-rtdb.firebaseio.com", "/products/$id.json", {'auth': '$authToken'});
       await http.patch(url, body: json.encode({
         'title' : newProduct.title,
         'description' : newProduct.description,
         'imageUrl' : newProduct.imageUrl,
         'price' : newProduct.price
       }
         ));
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print(".... what!");
    }
  }

  Future<void> deleteProduct(String id) async{
    final url = Uri.https("learning-f4b67-default-rtdb.firebaseio.com", "/products/$id.json", {'auth': '$authToken'});
    final existingProductIndex = _items.indexWhere((element) => element.id == id);
    var existingProduct = items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
  ///  _items.removeWhere((element) => element.id == id);
  final respone = await  http.delete(url);
      if(respone.statusCode >= 400){
        _items.insert(existingProductIndex, existingProduct);
        throw HttpException("couldn't delete product.");
      }else{

      }
      existingProduct = null as dynamic;
  }
}
