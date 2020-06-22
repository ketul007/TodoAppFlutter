import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/api_client/api.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/constants/shared_keys.dart';
import 'package:todo_app/screens/changepass.dart';
import 'package:todo_app/screens/forgetpass.dart';
import 'package:todo_app/widgets/alert_widget.dart';

class SettingWidget extends StatefulWidget {
  @override
  _SettingWidgetState createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  int angle = -90;

  TextEditingController _userNameController;
  TextEditingController _dobController;

  Color color = colors.mainColor;
  double width;

  final _scoffaldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> res;

  @override
  void initState() {
    Timer(Duration(seconds: 0), () async {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Alert());
      res = await ApiClient().getUser();
      if (res.isNotEmpty) {
        _dobController = TextEditingController(text: res['dob']);
        _userNameController = TextEditingController(text: res['userName']);

        Navigator.pop(context);
      } else {
        _dobController = TextEditingController(text: "");
        _userNameController = TextEditingController(text: "");
        Navigator.pop(context);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _dobController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _scoffaldKey,
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 60.0, left: 30.0, bottom: 20.0),
                  child: Text("Settings",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                          color: Colors.black)),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  decoration: BoxDecoration(
                      border: Border(
                    top: BorderSide(color: Colors.grey.withOpacity(0.3)),
                    bottom: BorderSide(color: Colors.grey.withOpacity(0.3)),
                  )),
                  child: ExpansionTile(
                    onExpansionChanged: (boo) {
                      setState(() {
                        if (boo) {
                          angle = 90;
                        } else {
                          angle = -90;
                        }
                      });
                    },
                    leading: SizedBox(
                      height: 30.0,
                      width: 30.0,
                      child: Icon(
                        Icons.person_outline,
                        color: color,
                        size: 30.0,
                      ),
                    ),
                    title: Text(
                      "Your Details",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 20.0,
                          color: Colors.black),
                    ),
                    trailing: Transform.rotate(
                      angle: angle * 3.1415 / 180,
                      child: SizedBox(
                        height: 25.0,
                        width: 25.0,
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: colors.mainColor,
                          size: 25.0,
                        ),
                      ),
                    ),
                    children: [
                      Container(
                          alignment: Alignment.center,
                          width: kIsWeb ||
                                  Platform.isWindows ||
                                  Platform.isMacOS ||
                                  Platform.isLinux ||
                                  Platform.isFuchsia
                              ? width / 3
                              : width,
                          padding: EdgeInsets.only(
                              top: 10.0, left: 40.0, right: 40.0, bottom: 10.0),
                          child: Column(
                            children: [
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
                                  controller: _userNameController,
                                  decoration: InputDecoration(
                                    disabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.people_outline,
                                      color: color,
                                    ),
                                    hintText: "Username",
                                    hintStyle: TextStyle(
                                        fontSize: 18,
                                        color: color.withOpacity(0.5)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  var today = DateTime.now();
                                  DateTime date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime(2020),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(
                                          today.year, today.month, today.day));
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
                                            color: color.withOpacity(0.1),
                                            blurRadius: 1)
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
                                          fontSize: 18,
                                          color: color.withOpacity(0.5)),
                                    ),
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
                                      if (_userNameController.text
                                                  .compareTo(res['userName']) !=
                                              0 ||
                                          _dobController.text
                                                  .compareTo(res['dob']) !=
                                              0) {
                                        bool response = await ApiClient()
                                            .updateUserDetails(
                                                res['_id'],
                                                _userNameController.text,
                                                _dobController.text);

                                        if (response) {
                                          setState(() {
                                            res['userName'] = _userNameController.text;
                                            res['dob'] = _dobController.text;
                                          });
                                          _scoffaldKey.currentState
                                              .showSnackBar(SnackBar(
                                            content:
                                                Text("User Details Updated"),
                                            backgroundColor: colors.mainColor,
                                            duration: Duration(seconds: 2),
                                          ));
                                        } else {
                                          _scoffaldKey.currentState
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "User Details Update Failed!"),
                                            backgroundColor: colors.mainColor,
                                            duration: Duration(seconds: 2),
                                          ));
                                        }
                                      } else {
                                        _scoffaldKey.currentState
                                            .showSnackBar(SnackBar(
                                          content:
                                              Text("Please Change Details"),
                                          backgroundColor: colors.mainColor,
                                          duration: Duration(seconds: 2),
                                        ));
                                      }
                                    },
                                    child: Text(
                                      "Update",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                          fontStyle: FontStyle.normal),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ))
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  decoration: BoxDecoration(
                      border: Border(
                    top: BorderSide(color: Colors.grey.withOpacity(0.3)),
                    bottom: BorderSide(color: Colors.grey.withOpacity(0.3)),
                  )),
                  child: ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ChangePassword(id: res['_id'],password: res['password'],)));
                    },
                    leading: SizedBox(
                      height: 30.0,
                      width: 30.0,
                      child: Icon(
                        Icons.lock_outline,
                        color: color,
                        size: 30.0,
                      ),
                    ),
                    title: Text(
                      "Change Password",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 20.0,
                          color: Colors.black),
                    ),
                    trailing: SizedBox(
                      height: 25.0,
                      width: 25.0,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: colors.mainColor,
                        size: 25.0,
                      ),
                    ),
                  ),
                ),Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  decoration: BoxDecoration(
                      border: Border(
                    top: BorderSide(color: Colors.grey.withOpacity(0.3)),
                    bottom: BorderSide(color: Colors.grey.withOpacity(0.3)),
                  )),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPass()));
                    },
                    leading: Icon(
                      Icons.lock_open,
                      color: colors.mainColor,
                      size: 30.0,
                    ),
                    title: Text(
                      "Forgot Password",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 20.0,
                          color: Colors.black),
                    ),
                    trailing:SizedBox(
                      height: 25.0,
                      width: 25.0,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: colors.mainColor,
                        size: 25.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  decoration: BoxDecoration(
                      border: Border(
                    top: BorderSide(color: Colors.grey.withOpacity(0.3)),
                    bottom: BorderSide(color: Colors.grey.withOpacity(0.3)),
                  )),
                  child: ListTile(
                    onTap: () async {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (con) {
                            return AlertDialog(
                              title: Text(
                                "Are You Sure?",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20.0,
                                    color: Colors.black),
                              ),
                              actions: [
                                FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel"),
                                ),
                                FlatButton(
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (con) => Alert());
                                    Future<SharedPreferences> _pref =
                                        SharedPreferences.getInstance();
                                    final SharedPreferences pref = await _pref;
                                    pref.setBool(SharedKeys.LOGGED, false);
                                    Navigator.pop(context);
                                    Navigator.pop(context);

                                    Navigator.pushReplacementNamed(
                                        context, "/login");
                                  },
                                  child: Text("Logout"),
                                )
                              ],
                            );
                          });
                    },
                    leading: Icon(
                      Icons.exit_to_app,
                      color: colors.mainColor,
                      size: 30.0,
                    ),
                    title: Text(
                      "Logout",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 20.0,
                          color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
