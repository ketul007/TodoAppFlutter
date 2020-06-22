// import 'dart:convert';

// import 'package:todo_app/models/lists.dart';

// class TodoList 
// {
//   List<Lists> _lists;

//   TodoList(List<Lists> lists)
//   {
//     this._id = id;
//     this._lists = lists;
//   }

//   TodoList.fromJson(Map<String, dynamic> json)
//   {
//     _id = json['_id'];
//     List<dynamic> lists = jsonDecode(json['lists']);
//     _lists = lists.map((e) => Lists.fromJson(e)).toList();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this._lists;
//     data['lists'] =  _lists.map((e) => e.toJson()).toList() ;
//     return data;
//   }



// }