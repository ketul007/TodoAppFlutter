
import 'package:todo_app/models/todos.dart';


class Lists 
{
  String  _listTitle;
  List<Todos> _todos;


  Lists(String title , List<Todos> todos)
  {
    this._listTitle = title;
    this._todos = todos;
  }

  String get listTitle => _listTitle;
  List<Todos> get todos => _todos;


  Lists.fromJson(Map<String, dynamic> jsonString)
  {
    _listTitle = jsonString['listTitle'];
    List<dynamic> todos = jsonString['todos'];
    _todos = todos.map((e) => Todos.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listTitle'] = this._listTitle;
    data['todos'] =  _todos.map((e) => e.toJson()).toList() ;
    return data;
  }

}