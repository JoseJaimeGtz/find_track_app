import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class UsersDataProvider with ChangeNotifier {

  var _usersEndpoint = "https://jsonplaceholder.typicode.com/users";
  List<dynamic> _usersList = [];
  List<dynamic> get getUsersList => _usersList;

    Future<dynamic> getUsers() async{
    var _usersEndpoint = "https://jsonplaceholder.typicode.com/users";
    try{
      var _response = await get(Uri.parse(_usersEndpoint));
      if (_response.statusCode == 200) {
        var _content = jsonDecode(_response.body);
        _usersList = _content;
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
      _usersList = [];
      notifyListeners();
    }
  }

}