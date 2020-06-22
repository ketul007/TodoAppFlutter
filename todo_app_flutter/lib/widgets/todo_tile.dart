import 'package:flutter/material.dart';

class ToDoTile extends StatelessWidget {
  final bool val ;
  final String text;

  const ToDoTile({Key key, this.val, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              height: 20.0,
              width: 20.0,
              child: Checkbox(
                value: val,
                checkColor: Colors.transparent,
                activeColor: Colors.transparent,
                onChanged: (value) {},
              )),
          SizedBox(
            width: 10.0,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
  
            style: TextStyle(
              decoration: val ? TextDecoration.lineThrough : TextDecoration.none,
              decorationColor: Colors.redAccent,
              decorationThickness: 3.0,
              color: Colors.white,
            ),
          )
        ],
      ),
    ) ;
  }
}







