import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/constants/shared_keys.dart';
import 'package:todo_app/models/lists.dart';
import 'package:todo_app/models/todos.dart';

class ApiClient {
  var client;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  ApiClient() {
    client = http.Client();

  }

  Future<bool> login(String email, String password) async {
    try {
      final SharedPreferences prefs = await _prefs;
      var response = await client.post("http://192.168.0.107:5000/userLog",
          body: {"email": email, "password": password});
      if (response.statusCode == 200) {
        var decode = jsonDecode(response.body);
        prefs.setString(SharedKeys.TOKEN_ID, decode["tokenId"].toString());
        prefs.setString(SharedKeys.USER_ID, decode["_id"].toString());
        prefs.setString(SharedKeys.LIST_ID, decode["listId"].toString());
        prefs.setBool(SharedKeys.LOGGED, true);
        return true;
      } else {
        return false;
      }
    } finally {
      client.close();
    }
  }

  Future<bool> hasToken(String id) async {
    try {
      final SharedPreferences prefs = await _prefs;
      var response = await client
          .post("http://192.168.0.107:5000/token", body: {"_id": id});
      if (response.statusCode == 200) {
        return true;
      } else {
        prefs.setBool(SharedKeys.LOGGED, false);
        return false;
      }
    } finally {
      client.close();
    }
  }

  Future<String> signUp(String email, String userName, String password, String dob) async {
    try {
      final SharedPreferences prefs = await _prefs;
      var response = await client.post("http://192.168.0.107:5000/userReg",
          body: {
            "email": email,
            "userName": userName,
            "password": password,
            "dob": dob
          });
      if (response.statusCode == 200) {
        var decode = jsonDecode(response.body);

        prefs.setString(SharedKeys.TOKEN_ID, decode["tokenId"].toString());
        prefs.setString(SharedKeys.LIST_ID, decode["listId"].toString());
        prefs.setBool(SharedKeys.LOGGED, true);

        return "sign";
      } else if (response.statusCode == 201) {
        return "exist";
      } else {
        return "failed";
      }
    } finally {
      client.close();
    }
  }

  Future<List<Lists>> getList(String listId) async {
    try {
      var response = await client
          .post("http://192.168.0.107:5000/lists", body: {"_id": listId});
      if (response.statusCode == 200) {
        List<dynamic> lists = json.decode(response.body);
        List<Lists> _list = lists.map((e) => Lists.fromJson(e)).toList();
        return _list;
      } else {
        return List<Lists>();
      }
    } finally {
      client.close();
    }
  }

  Future<bool> updateList(String title, List<Todos> todos) async {
    try {
      List<Map> todosMap = new List();
      todos.forEach((element) {
        todosMap.add(element.toJson());
      });
      final SharedPreferences prefs = await _prefs;
      var response = await client.post("http://192.168.0.107:5000/updateList",
          body: json.encode({
            "_id": prefs.getString(SharedKeys.LIST_ID),
            "listTitle": title,
            "todos": todosMap
          }),
          headers: {"content-type": "application/json"});
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } finally {
      client.close();
    }
  }

  Future<bool> addList(String title, List<Todos> todos) async {
    try {
      List<Map> todosMap = new List();
      todos.forEach((element) {
        todosMap.add(element.toJson());
      });
      final SharedPreferences prefs = await _prefs;
      var response = await client.post("http://192.168.0.107:5000/addList",
          body: json.encode({
            "_id": prefs.getString(SharedKeys.LIST_ID),
            "listTitle": title,
            "todos": todosMap
          }),
          headers: {"content-type": "application/json"});
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } finally {
      client.close();
    }
  }

  Future<bool> removeList(String title) async {
    try {
      final SharedPreferences prefs = await _prefs;
      var response = await client.post(
        "http://192.168.0.107:5000/removeList",
        body: {
          "_id": prefs.getString(SharedKeys.LIST_ID),
          "listTitle": title,
        },
      );
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } finally {
      client.close();
    }
  }


  Future<Map<String , dynamic>> getUser()
  async {
    try{
    final SharedPreferences prefs = await _prefs;
    var response = await client.post(
        "http://192.168.0.107:5000/user",
        body: {
          "_id": prefs.getString(SharedKeys.USER_ID),
        },
      );
    if (response.statusCode == 200)
    { 
       var res = jsonDecode(response.body);    
       prefs.setString(SharedKeys.TOKEN_ID, res['tokenId']);
      return res;
    }else
    {
      
    print("Failed"); 
      return null;
    }

    }
    finally{
      client.close();
    }
  }


  Future<bool> updateUserDetails( String _id , String uname , String dob) async {
    try{
      var response = await client.post( "http://192.168.0.107:5000/updateUserDetails" , body : {
        "_id" : _id,
        "userName" : uname,
        "dob" : dob
      });

      if (response.statusCode == 200)
      {
        return true;
      }else
      {
        return false;
      }
    }

    finally{
      client.close();
    }
  }


  Future<bool> updatePassword(String _id , String newPass) async {
    try{
      var response = await client.post( "http://192.168.0.107:5000/updatePassword" , body : {
        "_id" : _id,
        "password" : newPass
      });

      if (response.statusCode == 200)
      {
        return true;
      }else
      {
        return false;
      }
    }
    finally{
      client.close();
    }
  }


}
