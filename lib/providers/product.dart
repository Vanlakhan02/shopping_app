import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.price,
      this.isFavorite = false});

     void _setFavorite(bool newValue){
        isFavorite = newValue;
        notifyListeners();
     }

     Future<void> toggleFavoriteStatus(String token, String userId) async{
        final oldStatus = isFavorite;
        isFavorite = !isFavorite;
        notifyListeners();
        final url = Uri.https("learning-f4b67-default-rtdb.firebaseio.com", "/user-favorite/$userId/$id.json", {'auth': '$token'});
        try{
        final respone = await http.put(url, body: json.encode(
           isFavorite
        ));
        if(respone.statusCode >= 400){
           _setFavorite(oldStatus);
        }
        }catch(error){
           _setFavorite(oldStatus);
        }
      }
}
