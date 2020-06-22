
import 'package:flutter/material.dart';
import 'package:todo_app/models/todos.dart';
import 'package:todo_app/widgets/todo_tile.dart';

class ToDoListCard extends StatelessWidget {
  final int index;
  final List<Todos> tasks;
  final String title;
  ToDoListCard({Key key , this.index , this.title,  this.tasks}) : super(key: key);

  List<Color> _colors = <Color>[
    Color(0xff3A2C85),
    Color(0xffDF3435),
    Color(0xffD5B58E),
    Colors.redAccent,
    Color(0xffDF8453),
    Color(0xffD565E8)
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180.0,
      margin: EdgeInsets.only(right: 10.0),
      padding: EdgeInsets.only(top: 30.0, left: 20.0),
      decoration: BoxDecoration(
          color: _colors[index % 6],
          borderRadius: BorderRadius.circular(10.0),
          ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
              textAlign: TextAlign.start,
            ),
          SizedBox(
            height: 10.0,
          ),
          Divider(
            height: 1,
            color: Colors.white,
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            height: 200.0,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context , index){
              return Container(
                margin: EdgeInsets.only(bottom : 20.0),
                child: ToDoTile(val : tasks[index].completed , text : tasks[index].title),
              );
            }, itemCount: tasks.length,),
          )
        ],
      ),
    );
  }


}

