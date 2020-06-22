class Todos 
{
  bool  _completed;
  String _title;



  Todos(bool completed , String title){
    this._completed = completed;
    this._title = title;
  }

  bool get  completed => _completed;
  String get title => _title;
  set completed(bool title) => _completed = title;

  Todos.fromJson(Map<String, dynamic> jsonString)
  {
    _completed = jsonString['completed'];
    _title = jsonString['title'];
  }

   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['completed'] = this._completed;
    data['title'] = this._title;
    return data;
  }

}