import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:user_app/HelperMethodes.dart';
import 'package:user_app/Trading/UserInterface/MyBorrowingBids.dart';
import 'package:user_app/Trading/UserInterface/MyBorrowingRequests.dart';
import 'package:user_app/Trading/UserInterface/MyLendingBids.dart';
import 'package:user_app/Trading/UserInterface/MyLendingOffers.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);
  static const String idScreen = "activity";

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: buildAppBar("ACTIVITY", Colors.grey.shade300, Colors.black54),
        drawer: buildDrawer(context, "activity"),
        body: BuildBody(context),
      ),
    );
  }

  Widget BuildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50.0),
          ),
          Image.asset(
            "images/moneyLending.png",
            height: 150.0,
            width: 150.0,
          ),
          Padding(
            padding: EdgeInsets.only(top: 50.0),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    Navigator.pushNamed(context, MyLendingOffers.idScreen);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 100,
                    margin: EdgeInsets.only(top: 5, left: 5, bottom: 2.5, right: 2.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.publish_outlined,
                          size: 50,
                          color: Colors.white,
                        ),
                        Text(
                          "My Lending offers",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    Navigator.pushNamed(context, MyBorrowingRequests.idScreen);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 100,
                    margin: EdgeInsets.only(top: 5, left: 2.5, bottom: 2.5, right: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.publish,
                          size: 50,
                          color: Colors.white,
                        ),
                        Text(
                          "My Borrowing Requests",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    Navigator.pushNamed(context, MyLendingBids.idScreen);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 100,
                    margin: EdgeInsets.only(top: 2.5, left: 5, bottom: 5, right: 2.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.view_list_outlined,
                          size: 50,
                          color: Colors.white,
                        ),
                        Text(
                          "My Lending bids",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    Navigator.pushNamed(context, MyBorrowingBids.idScreen);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 100,
                    margin: EdgeInsets.only(top: 2.5, left: 2.5, bottom: 5, right: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.view_list,
                          size: 50,
                          color: Colors.white,
                        ),
                        Text(
                          "My Borrowing Bids",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
