import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_app/api_client/api.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/models/todos.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/widgets/alert_widget.dart';

class TodoScreen extends StatefulWidget {
  final String title;
  final List<Todos> tasks;
  final bool enable;

  TodoScreen({this.title, this.tasks, this.enable});

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController _controller;
  Animation<Color> animation;
  AnimationController controller;
  int completed = 0;
  double progress = 0;

  @override
  void initState() {
    _controller = new TextEditingController(text: widget.title);
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    super.initState();
    animation =
        ColorTween(begin: colors.mainColor, end: colors.mainColor).animate(controller);

    widget.tasks.forEach((element) {
      if (element.completed) {
        completed++;
      }
    });

    if (widget.tasks.length > 0) {
      progress = completed / widget.tasks.length;
    }
  }

  Future<bool> onBackClick() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Alert());
    if (widget.enable) {
      if (widget.tasks.length != 0 && _controller.text.isNotEmpty) {

        bool response = await ApiClient().addList(_controller.text,widget.tasks);
        if (response) {
          Navigator.pop(context);
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(from:true)));
          return Future.value(true);
        } else {
          Navigator.pop(context);
          return Future.value(false);
        }
      } else {
        Navigator.pop(context);   
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(from:true)));
   return Future.value(true);

      }
    } else {
      bool response = await ApiClient().updateList(widget.title, widget.tasks);
      if (response) {
        Navigator.pop(context);
        return Future.value(true);
      } else {
        Navigator.pop(context);
        return Future.value(false);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: onBackClick,
        child: Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).orientation == Orientation.landscape
                  ? 10
                  : 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: 30.0,
                        top: 30.0,
                        bottom: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? 10
                            : 100.0),
                    child: kIsWeb ||
                            Platform.isWindows ||
                            Platform.isMacOS ||
                            Platform.isLinux ||
                            Platform.isFuchsia
                        ? Icon(
                            Icons.dashboard,
                            size: 50.0,
                            color: colors.mainColor,
                          )
                        : SvgPicture.asset(
                            "assets/logo.svg",
                            height: 70.0,
                            width: 70.0,
                          ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        right: 22.0,
                        top: 22.0,
                        bottom: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? 2
                            : 92.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).maybePop();
                      },
                      child: Transform.rotate(
                        angle: 90 * 3.1415 / 180,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      height: 20.0,
                      width: 20.0,
                      margin: EdgeInsets.only(left: 30),
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.grey[300],
                        value: progress,
                        valueColor: animation,
                      )),
                  Container(
                    width: MediaQuery.of(context).size.width - 80,
                    margin: EdgeInsets.only(left: 20.0),
                    child: TextField(
                        enabled: widget.enable,
                        controller: _controller,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Enter List Name",
                        ),
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 24.0,
                            color: Colors.black)),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 35.0, bottom: 20.0),
                child: Text(
                  "$completed of ${widget.tasks.length} tasks",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              Divider(
                height: 0.8,
                color: Colors.grey,
                indent: 30.0,
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 5.0),
                  child: ListView.builder(
                      itemCount: widget.tasks.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          onChanged: (value) {
                            setState(() {
                              widget.tasks[index].completed = value;
                              completed = 0;
                              widget.tasks.forEach((element) {
                                if (element.completed) {
                                  completed++;
                                }
                              });
                              progress = completed / widget.tasks.length;
                            });
                          },
                          value: widget.tasks[index].completed,
                          checkColor: Colors.transparent,
                          activeColor: Colors.transparent,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(widget.tasks[index].title,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  decoration: widget.tasks[index].completed
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  decorationColor: Colors.redAccent,
                                  decorationThickness: 3.0,
                                )),
                          ),
                        );
                      }),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 50.0,
                    width: 100.0,
                    margin:
                        EdgeInsets.only(top: 10.0, bottom: 30.0, left: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 5,
                          height: 15.0,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xff3A2C85),
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                          height: 30.0,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                          height: 15.0,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xffD5B58E),
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                          height: 15.0,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xffDF3435),
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                          height: 15.0,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xff3A2C85),
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                          height: 15.0,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xffD565E8),
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      TextEditingController _controller =
                          TextEditingController();
                      String todo = await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
                                title: Text("Add your todo"),
                                content: TextField(
                                  controller: _controller,
                                  decoration: InputDecoration(
                                    hintText: "Your Todo task",
                                  ),
                                ),
                                actions: [
                                  MaterialButton(
                                    color: colors.mainColor,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  MaterialButton(
                                    color: colors.mainColor,
                                    onPressed: () {
                                      if (_controller.text.isNotEmpty) {
                                        Navigator.of(context)
                                            .pop(_controller.text);
                                      } else {
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: Text("Add"),
                                  )
                                ]);
                          });
                      if (todo != null) {
                        setState(() {
                          widget.tasks.add(Todos(false, todo));
                          progress = completed / widget.tasks.length;
                        });
                      }
                    },
                    child: Tooltip(
                      message: "Add Todo",
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        margin: EdgeInsets.only(
                            top: 10.0, bottom: 30.0, right: 40.0),
                        decoration: BoxDecoration(
                            color: colors.mainColor,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Icon(Icons.add , color: Colors.white,),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
