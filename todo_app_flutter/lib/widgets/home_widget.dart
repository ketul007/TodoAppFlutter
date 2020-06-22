import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/api_client/api.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/constants/shared_keys.dart';
import 'package:todo_app/models/lists.dart';
import 'package:todo_app/screens/todo_screen.dart';
import 'package:todo_app/widgets/alert_widget.dart';
import 'package:todo_app/widgets/todo_list_card.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({
    Key key,
  }) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget>
    with SingleTickerProviderStateMixin {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var _tapPosition;


  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  Future<List<Lists>> getList() async {
    final SharedPreferences pref = await _prefs;
    List<Lists> response = await ApiClient()
        .getList(pref.getString(SharedKeys.LIST_ID) ?? "dfgdfgdgdfgdgdg");
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 30.0, top: 30.0, bottom: 100.0),
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
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("ToDo ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                        color: Colors.black)),
                Text("Lists",
                    style: TextStyle(fontSize: 24.0, color: Colors.grey)),
              ],
            ),
            Container(
              height: 300,
              margin: EdgeInsets.only(left: 40.0, bottom: 30.0, top: 100.0),
              padding: EdgeInsets.all(8.0),
              child: FutureBuilder<List<Lists>>(
                future: getList(),
                builder: (context, AsyncSnapshot<List<Lists>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTapDown: _storePosition,
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => TodoScreen(
                                              title: snapshot.data[index].listTitle,
                                              tasks: snapshot.data[index].todos,
                                              enable: false,
                                            )))
                                    .then((value) {
                                  setState(() {});
                                });
                              },
                              onLongPress: () {
                                final RenderBox overlay = Overlay.of(context)
                                    .context
                                    .findRenderObject();
                                showMenu(
                                    context: context,
                                    semanticLabel: "Remove List",
                                    position: RelativeRect.fromRect(
                                        _tapPosition & Size(40, 40),
                                        Offset.zero & overlay.size),
                                    items: [
                                      PopupMenuItem(
                                          enabled: false,
                                          child: GestureDetector(
                                            onTap: () async {
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (context) =>
                                                      Alert());
                                              bool res = await ApiClient()
                                                  .removeList(snapshot.data[index]
                                                      .listTitle);
                                              if (res) {
                                                Navigator.pop(context);
                                              }
                                              Navigator.pop(context);
                                              setState(() {});
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text("Remove"),
                                                Icon(
                                                  Icons.close,
                                                  color: colors.mainColor,
                                                ),
                                              ],
                                            ),
                                          ))
                                    ],
                                    captureInheritedThemes: true,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0)));
                              },
                              child: ToDoListCard(
                                index: index,
                                title: snapshot.data[index].listTitle,
                                tasks: snapshot.data[index].todos.sublist(
                                    0,
                                    snapshot.data[index].todos.length < 4
                                        ? snapshot.data[index].todos.length
                                        : 4),
                              ));
                        });
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
