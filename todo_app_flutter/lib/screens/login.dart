
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_app/api_client/api.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/screens/forgetpass.dart';
import 'dart:io' show Platform;

import 'package:todo_app/widgets/alert_widget.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController;
  TextEditingController _passwordController;

  Color color = colors.mainColor;
  final key = GlobalKey<ScaffoldState>();

  bool passObs = true;
 

  @override
  void initState() {
    _passwordController = TextEditingController(text: "");
    _emailController = TextEditingController(text: "");

    super.initState();
  }

  void showSnackBar(String s) {
    key.currentState.showSnackBar(SnackBar(
      backgroundColor: color,
      content: Text(
        s,
        style: TextStyle(color: Colors.white, fontSize: 18.0),
      ),
      duration: Duration(milliseconds: 2000),
    ));
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        height: 70.0,
                        width: 70.0,
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
                        prefixIcon: Icon(Icons.alternate_email, color: color),
                        hintStyle: TextStyle(
                            fontSize: 18, color: color.withOpacity(0.5)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 40.0, right: 40.0, bottom: 5.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                              color: color.withOpacity(0.1), blurRadius: 1)
                        ]),
                    padding: const EdgeInsets.all(5.0),
                    child: TextField(
                      obscureText:passObs,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.lock_outline , color: color,),
                        suffixIcon: GestureDetector(
                            onTap: (){
                              setState(() {
                                                              passObs =!passObs;
                              });
                            },
                            child: Icon(
                            Icons.remove_red_eye,
                            color: color,
                          ),
                        ),
                        hintText: "Password",
                        hintStyle: TextStyle(
                            fontSize: 18, color: color.withOpacity(0.5)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 200.0),
                  child: FlatButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPass()));
                    },
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(50.0),
),
                    child: Text(
                      "Forgot Password?",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 15, color: color.withOpacity(0.5)),
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
                    } else if (_passwordController.text.isEmpty) {
                      showSnackBar("Please Enter Password");
                    } else {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return Alert();
                          });
                      bool response = await ApiClient().login(
                          _emailController.text, _passwordController.text);

                      if (response) {
                        Navigator.pop(context);
                      Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) {return false;});
                      } else {
                        Navigator.pop(context);
                        showSnackBar("Authentication Failed!");
                      }
                    }
                  },
                  padding: EdgeInsets.only(
                      left: 80.0, right: 80.0, top: 15.0, bottom: 15.0),
                  color: color,
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
                Center(
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/signup');
                    },
                    shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(50.0),
),
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: Text(
                      "Create New Account ?",
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
      ),
    );
  }
}
