import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shopping_app/models/http_Exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String token = "";
  DateTime? expireDate;
  String userId = "";
  Timer? autoTimer = null;
  bool get isAuth {
    return _token != "";
  }

  String get _token {
    if (expireDate != null &&
        expireDate!.isAfter(DateTime.now()) &&
        token != null) {
      return token;
    }
    return "";
  }

  String get userID {
    return userId;
  }

  Future<void> _Authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyC3wm9yh_ErSVwoQycL4o6X8VawaAVr-Y4');
    try {
      final respone = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responeData = json.decode(respone.body);
      if (responeData['error'] != null) {
        throw HttpException(responeData['error']['message']);
      }
      token = responeData['idToken'];
      userId = responeData['localId'];
      expireDate = DateTime.now()
          .add(Duration(seconds: int.parse(responeData['expiresIn'])));
      print(expireDate);
      _autoLogout();
      notifyListeners();
      final prefers = await SharedPreferences.getInstance();
      final userData = json.encode({'token': token, 'userId': userId, 'expireData': expireDate!.toIso8601String() });
      prefers.setString('userData', userData);
    } catch (error) {
      print(error);
      throw error;
    }
  }
Future<bool> tryAutologin() async{
  final prefers = await SharedPreferences.getInstance();
  if(prefers.containsKey('userData')){
    return false;
  }
  final extracUserData = json.decode(prefers.getString('userData') as String);
  final expirDate = DateTime.parse(extracUserData['expirDate'] as String);
  if(expirDate.isBefore(DateTime.now())){
    return false;
  }
  token = extracUserData['token'] as String;
  userId = extracUserData['userId'] as String;
  expireDate = expirDate;
  notifyListeners();
  _autoLogout();
  return true;
}

  Future<void> sigup(String email, String password) async {
    return _Authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _Authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async{
    token = "";
    expireDate = null;
    userId = "";
    if(autoTimer != null){
      autoTimer!.cancel();
      autoTimer = null;
    }
    notifyListeners();
   final prefers = await SharedPreferences.getInstance();
   prefers.clear();
  }

  void _autoLogout() {
    if (autoTimer != null) {
      autoTimer!.cancel();
    }
    final timeToExpire = expireDate!.difference(DateTime.now()).inSeconds;
    autoTimer = Timer(Duration(seconds: timeToExpire), logout);
  }
}
