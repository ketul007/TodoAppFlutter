import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';

class ForgetPass extends StatelessWidget {
  TextEditingController _emailController = new TextEditingController(text: "");
  Color color = colors.mainColor;
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
          key: _scaffoldKey,
          body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Forgot Password",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                      color: Colors.black)),
              Container(
                margin: const EdgeInsets.only(
                    left: 40.0, right: 40.0, bottom: 20.0, top: 40.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(color: color.withOpacity(0.1), blurRadius: 1)
                    ]),
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none,
                    hintText: "Email Address",
                    prefixIcon: Icon(Icons.alternate_email, color: color),
                    hintStyle:
                        TextStyle(fontSize: 18, color: color.withOpacity(0.5)),
                  ),
                ),
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                onPressed: () async {
                 if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(_emailController.text)) {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Enter Valid Email") , backgroundColor: color, duration: Duration(seconds: 2),));
                    }
                  else
                  {

                  }
                },
                padding: EdgeInsets.only(
                    left: 80.0, right: 80.0, top: 15.0, bottom: 15.0),
                color: color,
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
