import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_app/api_client/api.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/widgets/alert_widget.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _dobController;
  TextEditingController _passwordController;
  TextEditingController _rePasswordController;
  TextEditingController _emailController;
  TextEditingController _userNameController;
  final key = GlobalKey<ScaffoldState>();
  Size size;
  Color color = colors.mainColor;
  bool passObs = true;
  bool repassObs = true;

  @override
  void initState() {
    super.initState();
    _dobController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _emailController = TextEditingController(text: "");
    _rePasswordController = TextEditingController(text: "");
    _userNameController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _dobController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _rePasswordController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void showSnackBar(String s) {
      key.currentState.showSnackBar(SnackBar(
        backgroundColor: color,
        content: Text(
          s,
          style: TextStyle(color: Colors.white, fontSize: 15.0),
        ),
        duration: Duration(milliseconds: 2000),
      ));
    }

    size = MediaQuery.of(context).size;
    return Scaffold(
        key: key,
        body: Center(
          child: Container(
            width: kIsWeb ||
                    Platform.isWindows ||
                    Platform.isMacOS ||
                    Platform.isLinux ||
                    Platform.isFuchsia
                ? MediaQuery.of(context).size.width / 3
                : MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  kIsWeb ||
                          Platform.isWindows ||
                          Platform.isMacOS ||
                          Platform.isLinux ||
                          Platform.isFuchsia
                      ? Icon(
                          Icons.dashboard,
                          size: 50.0,
                          color: color,
                        )
                      : SvgPicture.asset(
                          "assets/logo.svg",
                          height: 60.0,
                          width: 60.0,
                        ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 40.0, right: 40.0, bottom: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                                color: color.withOpacity(0.1), blurRadius: 1)
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
                          prefixIcon: Icon(
                            Icons.alternate_email,
                            color: color,
                          ),
                          hintStyle: TextStyle(
                              fontSize: 18, color: color.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 40.0, right: 40.0, bottom: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                                color: color.withOpacity(0.1), blurRadius: 1)
                          ]),
                      padding: const EdgeInsets.all(5.0),
                      child: TextField(
                        controller: _userNameController,
                        decoration: InputDecoration(
                          disabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: color,
                          ),
                          hintText: "Username",
                          hintStyle: TextStyle(
                              fontSize: 18, color: color.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 40.0, right: 40.0, bottom: 20.0),
                    child: GestureDetector(
                      onTap: () async {
                        var today = DateTime.now();
                        DateTime date = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2020),
                            firstDate: DateTime(1900),
                            lastDate:
                                DateTime(today.year, today.month, today.day));
                        if (date != null) {
                          _dobController.text = date.day.toString() +
                              "/" +
                              date.month.toString() +
                              "/" +
                              date.year.toString();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                  color: color.withOpacity(0.1), blurRadius: 1)
                            ]),
                        padding: const EdgeInsets.all(5.0),
                        child: TextField(
                          enabled: false,
                          controller: _dobController,
                          decoration: InputDecoration(
                            disabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.date_range,
                              color: color,
                            ),
                            hintText: "Date of Birth",
                            hintStyle: TextStyle(
                                fontSize: 18, color: color.withOpacity(0.5)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 40.0, right: 40.0, bottom: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                                color: color.withOpacity(0.1), blurRadius: 1)
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
                          hintText: "Password",
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
                              fontSize: 18, color: color.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 40.0, right: 40.0, bottom: 40.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                                color: color.withOpacity(0.1), blurRadius: 1)
                          ]),
                      padding: const EdgeInsets.all(5.0),
                      child: TextField(
                        obscureText: repassObs,
                        controller: _rePasswordController,
                        decoration: InputDecoration(
                          disabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                          hintText: "Re-enter Password",
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                repassObs = !repassObs;
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
                              fontSize: 18, color: color.withOpacity(0.5)),
                        ),
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
                        showSnackBar("Please Enter Valid Email");
                      } else if (_userNameController.text.isEmpty) {
                        showSnackBar("Please Enter UserName");
                      } else if (_dobController.text.isEmpty) {
                        showSnackBar("Please Select DOB");
                      } else if (_passwordController.text.isEmpty ||
                          _passwordController.text.length < 8) {
                        showSnackBar(
                            "Password must be 8 or more Character long");
                      } else if (_rePasswordController.text
                              .compareTo(_passwordController.text) !=
                          0) {
                        showSnackBar("Please Enter UserName");
                      } else {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => Alert());
                        String response = await ApiClient().signUp(
                            _emailController.text,
                            _userNameController.text,
                            _passwordController.text,
                            _dobController.text);
                        if (response.compareTo("sign") == 0) {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamedAndRemoveUntil('/',
                              (Route<dynamic> route) {
                            return false;
                          });
                        } else if (response.compareTo("exist") == 0) {
                          Navigator.pop(context);
                          showSnackBar("User Already Exist!");
                        } else {
                          Navigator.pop(context);
                          showSnackBar("Oops! Regestration Failed");
                        }
                      }
                    },
                    padding: EdgeInsets.only(
                        left: 80.0, right: 80.0, top: 15.0, bottom: 15.0),
                    color: color,
                    child: Text(
                      "SignUp",
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                  Center(
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(50.0),
),
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Text(
                        "Already Have an Account?",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 15, color: color.withOpacity(0.5)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
