import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/api_client/api.dart';
import 'package:todo_app/constants/colors.dart';

class ChangePassword extends StatefulWidget {

  final String password ;
  final String id;

  ChangePassword({Key key, this.password, this.id}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

    TextEditingController _passwordController = new TextEditingController();
  TextEditingController _rePasswordController = new TextEditingController();
  TextEditingController _oldpasswordController = new TextEditingController();
    bool oldPassObs = true;
  bool passObs = true;
  bool rePassObs = true;
    double width;
      Color color = colors.mainColor;

      final _scoffaldKey = GlobalKey<ScaffoldState>();


  @override
  void dispose() {
    _passwordController.dispose();
        _rePasswordController.dispose();
    _oldpasswordController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
        width = MediaQuery.of(context).size.width;
    return Scaffold(
        key : _scoffaldKey,
          body: Center(
            child: SingleChildScrollView(
                        child: Container(
                                padding: EdgeInsets.only(
                                    top: 10.0, left: 40.0, right: 40.0, bottom: 10.0),
                                width: kIsWeb ||
                                        Platform.isWindows ||
                                        Platform.isMacOS ||
                                        Platform.isLinux ||
                                        Platform.isFuchsia
                                    ? width / 3
                                    : width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Change Password",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                              color: Colors.black)),

                                    SizedBox(
                                      height: 40,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          boxShadow: [
                                            BoxShadow(
                                                color: color.withOpacity(0.1),
                                                blurRadius: 1)
                                          ]),
                                      padding: const EdgeInsets.all(5.0),
                                      child: TextField(
                                        controller: _oldpasswordController,
                                        obscureText: oldPassObs,
                                        decoration: InputDecoration(
                                          disabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          border: InputBorder.none,
                                          hintText: "Old Password",
                                          suffixIcon: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                oldPassObs = !oldPassObs;
                                              });
                                            },
                                            child: Icon(
                                              Icons.remove_red_eye,
                                              color: color,
                                            ),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.lock_outline,
                                            color: color,
                                          ),
                                          hintStyle: TextStyle(
                                              fontSize: 18,
                                              color: color.withOpacity(0.5)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          boxShadow: [
                                            BoxShadow(
                                                color: color.withOpacity(0.1),
                                                blurRadius: 1)
                                          ]),
                                      padding: const EdgeInsets.all(5.0),
                                      child: TextField(
                                        controller: _passwordController,
                                        obscureText: passObs,
                                        decoration: InputDecoration(
                                          disabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          border: InputBorder.none,
                                          hintText: "New Password",
                                          suffixIcon: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                passObs = !passObs;
                                              });
                                            },
                                            child: Icon(
                                              Icons.remove_red_eye,
                                              color: color,
                                            ),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.lock_outline,
                                            color: color,
                                          ),
                                          hintStyle: TextStyle(
                                              fontSize: 18,
                                              color: color.withOpacity(0.5)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          boxShadow: [
                                            BoxShadow(
                                                color: color.withOpacity(0.1),
                                                blurRadius: 1)
                                          ]),
                                      padding: const EdgeInsets.all(5.0),
                                      child: TextField(
                                        controller: _rePasswordController,
                                        obscureText: rePassObs,
                                        decoration: InputDecoration(
                                          disabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          border: InputBorder.none,
                                          hintText: "Re-enter password",
                                          suffixIcon: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                rePassObs = !rePassObs;
                                              });
                                            },
                                            child: Icon(
                                              Icons.remove_red_eye,
                                              color: color,
                                            ),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.lock_outline,
                                            color: color,
                                          ),
                                          hintStyle: TextStyle(
                                              fontSize: 18,
                                              color: color.withOpacity(0.5)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        MaterialButton(
                                          padding: EdgeInsets.only(
                                              top: 10.0,
                                              bottom: 10.0,
                                              left: 50.0,
                                              right: 50.0),
                                          color: colors.mainColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(50.0),
                                          ),
                                          onPressed: () async {
                                            if (_oldpasswordController.text.isEmpty ||
                                                _passwordController.text.isEmpty ||
                                                _rePasswordController.text.isEmpty) {
                                              _scoffaldKey.currentState
                                                  .showSnackBar(SnackBar(
                                                content: Text("Please Fill Details"),
                                                backgroundColor: colors.mainColor,
                                                duration: Duration(seconds: 2),
                                              ));
                                            } else if (_oldpasswordController.text
                                                    .compareTo(widget.password) !=
                                                0) {
                                              _scoffaldKey.currentState
                                                  .showSnackBar(SnackBar(
                                                content:
                                                    Text("Incorrect old Password"),
                                                backgroundColor: colors.mainColor,
                                                duration: Duration(seconds: 2),
                                              ));
                                            } else if (_passwordController.text
                                                    .compareTo(
                                                        _rePasswordController.text) !=
                                                0) {
                                              _scoffaldKey.currentState
                                                  .showSnackBar(SnackBar(
                                                content:
                                                    Text("Password doesn't Match!"),
                                                backgroundColor: colors.mainColor,
                                                duration: Duration(seconds: 2),
                                              ));
                                            } else {
                                              bool response = await ApiClient()
                                                  .updatePassword(widget.id,
                                                      _passwordController.text);
                                              if (response) {
                                                setState(() {
                                                  _oldpasswordController.text = _passwordController.text;
                                                  _passwordController.clear();
                                                  _rePasswordController.clear();
                                                });
                                                _scoffaldKey.currentState
                                                    .showSnackBar(SnackBar(
                                                  content:
                                                      Text("Password Updated"),
                                                  backgroundColor: colors.mainColor,
                                                  duration: Duration(seconds: 2),
                                                ));
                                              } else {
                                                _scoffaldKey.currentState
                                                    .showSnackBar(SnackBar(
                                                  content:
                                                      Text("Password Update Failed"),
                                                  backgroundColor: colors.mainColor,
                                                  duration: Duration(seconds: 2),
                                                ));
                                              }
                                            }
                                          },
                                          child: Text(
                                            "Update",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 18.0,
                                                fontStyle: FontStyle.normal),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                )),
            ),
          ),
    );
  }
}