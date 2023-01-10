import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:user_app/Trading/UserInterface/Activity.dart';
import 'package:user_app/Trading/UserInterface/Home.dart';
import 'package:user_app/Users/BusinessLogic/BusinessLogic.dart';
import 'package:user_app/Users/UserInterface/Login.dart';
import 'package:user_app/Users/UserInterface/Profile.dart';

late BusinessLogic userBusinessLogic = BusinessLogic();

AppBar buildAppBar(String title, Color backgroundColor, Color titleColor) {
  return AppBar(
    backgroundColor: backgroundColor,
    iconTheme: IconThemeData(color: titleColor),
    elevation: 0,
    title: Text(
      title,
      style: TextStyle(color: titleColor, fontSize: 13, fontWeight: FontWeight.bold),
    ),
    centerTitle: true,
  );
}

Widget buildDrawer(BuildContext context, String actualPage) {
  return Container(
    color: Colors.white,
    width: 255.0,
    child: Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  height: 165.0,
                  child: DrawerHeader(
                    decoration: BoxDecoration(color: Colors.grey.shade200),
                    margin: EdgeInsets.zero,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "images/user_icon.png",
                          height: 65.0,
                          width: 65.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16.0),
                        ),
                        FutureBuilder(
                          future: userBusinessLogic.getDisplayName(),
                          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return Text(
                                snapshot.data,
                                style: TextStyle(fontSize: 12.0, color: Colors.grey),
                              );
                            }
                            return Text("");
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    (actualPage == "home") ? null : Navigator.pushNamedAndRemoveUntil(context, HomeScreen.idScreen, (route) => false);
                  },
                  child: ListTile(
                    dense: true,
                    tileColor: (actualPage == "home") ? Colors.blue : null,
                    leading: Icon(
                      Icons.home,
                      color: (actualPage == "home") ? Colors.white : Colors.black54,
                    ),
                    title: (actualPage == "home") ? Text("Home", style: TextStyle(color: Colors.white)) : Text("Home", style: TextStyle(color: Colors.black54)),
                  ),
                ),
                Divider(
                  height: 0,
                ),
                GestureDetector(
                  onTap: () {
                    (actualPage == "profile") ? null : Navigator.pushNamedAndRemoveUntil(context, ProfileScreen.idScreen, (route) => false);
                  },
                  child: ListTile(
                    dense: true,
                    tileColor: (actualPage == "profile") ? Colors.blue : null,
                    leading: Icon(
                      Icons.person,
                      color: (actualPage == "profile") ? Colors.white : Colors.black54,
                    ),
                    title: (actualPage == "profile") ? Text("Profile", style: TextStyle(color: Colors.white)) : Text("Profile", style: TextStyle(color: Colors.black54)),
                  ),
                ),
                Divider(
                  height: 0,
                ),
                GestureDetector(
                  onTap: () {
                    (actualPage == "activity") ? null : Navigator.pushNamedAndRemoveUntil(context, ActivityScreen.idScreen, (route) => false);
                  },
                  child: ListTile(
                    dense: true,
                    tileColor: (actualPage == "activity") ? Colors.blue : null,
                    leading: Icon(
                      Icons.apps,
                      color: (actualPage == "activity") ? Colors.white : Colors.black54,
                    ),
                    title: (actualPage == "activity") ? Text("Activity", style: TextStyle(color: Colors.white)) : Text("Activity", style: TextStyle(color: Colors.black54)),
                  ),
                ),
                Divider(
                  height: 0,
                ),
                GestureDetector(
                  onTap: () {
                    //Navigator.push(context, AboutScreen.idScreen);
                  },
                  child: ListTile(
                    dense: true,
                    leading: Icon(Icons.info),
                    title: Text(
                      "About",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
                Divider(
                  height: 0,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              String? value = await userBusinessLogic.logOut();
              if (value == "success") {
                Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
              } else {
                displayToastMessage("$value", "failed", context);
              }
            },
            child: ListTile(
              tileColor: Colors.red,
              dense: true,
              leading: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title: Text(
                "Sign Out",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

void displayToastMessage(String message, String result, BuildContext context) {
  // Fluttertoast.showToast(
  //   msg: message,
  //   backgroundColor: Colors.red
  // );

  showToastWidget(
    Container(
      color: result == "success" ? Colors.green : Colors.red,
      padding: EdgeInsets.all(10),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(
            result == "success" ? Icons.assignment_turned_in : Icons.error_outline,
            color: Colors.white,
          ),
          Padding(padding: EdgeInsets.all(3)),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
            ),
          ),
        ],
      ),
    ),
    context: context,
    duration: Duration(seconds: 10),
    isHideKeyboard: true,
  );
}

void displayAlert(BuildContext context, String title, Widget content, Widget action) {
  final platform = Theme.of(context).platform;

  if (platform == TargetPlatform.iOS) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: content,
          actions: [
            action,
            CupertinoButton(
              child: Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  if (platform == TargetPlatform.android) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Container(
            color: Colors.blue,
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 15)),
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                Padding(padding: EdgeInsets.only(bottom: 15)),
              ],
            ),
          ),
          titlePadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              content,
            ],
          ),
          contentPadding: EdgeInsets.only(top: 20, bottom: 20, right: 15, left: 15),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                action,
                Padding(padding: EdgeInsets.only(left: 5)),
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
                  child: Text(
                    "Close",
                    style: TextStyle(fontSize: 11, color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

Widget displayWaitingIndicator() {
  return Container(
    padding: EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(5),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        Padding(padding: EdgeInsets.only(bottom: 10)),
        Text('loading...', style: TextStyle(color: Colors.white, fontSize: 12)),
      ],
    ),
  );
}

void consoleDisplayMessage(String message) {
  print(message);
}
