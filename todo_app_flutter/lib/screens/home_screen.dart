
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/api_client/api.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/constants/shared_keys.dart';
import 'package:todo_app/screens/todo_screen.dart';
import 'package:todo_app/widgets/alert_widget.dart';
import 'package:todo_app/widgets/home_widget.dart';
import 'package:todo_app/widgets/setting_widget.dart';

class HomeScreen extends StatefulWidget {

  final bool from ;

  HomeScreen({Key key, this.from}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int max;
  int _selected = 0;

  List<Widget> screens = new List();



   Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<bool> hasToken() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) { 
          return Alert();
          });
     final SharedPreferences pref= await _prefs;
     return await ApiClient().hasToken(pref.getString(SharedKeys.TOKEN_ID) ?? "5ec751b8eb9b6311fc9232b9") && pref.getBool(SharedKeys.LOGGED ?? false);
  }

  @override
  void initState() {
    super.initState();
    if (!widget.from)
    {
      Timer(Duration(seconds: 0), () async {
      bool res = await hasToken();
      if (!res) {
        Navigator.pop(context);
        Navigator.of(context).pushReplacementNamed("/login");
      } else {
Navigator.pop(context);
      }
    });
    }
    screens.add(HomeWidget(
    ));
    screens.add(SettingWidget());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomPadding: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor: colors.mainColor,
        tooltip: "Add List",
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => TodoScreen(
                    title: "",
                    tasks: [],
                    enable: true,
                  )));
        },
        child: Icon(
          Icons.add,
          size: 30.0,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 25.0,
        currentIndex: _selected,
        selectedItemColor: colors.mainColor,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selected = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            title: Text("Home"),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            title: Text("Settings"),
            icon: Icon(Icons.line_weight),
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: (){
          if (_selected == 1)
          {
            setState(() {
              _selected = 0;
            });
                        return Future.value(false);

          }else
          {
            return Future.value(true);
          }

        },
        child: screens.elementAt(_selected)),
    );
  }

}
