import 'dart:convert';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:user_app/HelperMethodes.dart';
import 'package:user_app/Trading/BusinessLogic/BusinessLogic.dart';
import 'package:user_app/Trading/BusinessLogic/Models/Transactions.dart';
import 'package:user_app/Trading/UserInterface/MyLendingBidDetails.dart';

class MyLendingBids extends StatefulWidget {
  static const String idScreen = "myLendingBids";

  const MyLendingBids({Key? key}) : super(key: key);

  @override
  _MyLendingBidsState createState() => _MyLendingBidsState();
}

class _MyLendingBidsState extends State<MyLendingBids> {
  late BusinessLogic businessLogic;
  late List<Transactions> transactions;
  bool isLoading = true;

  @override
  void initState() {
    businessLogic = BusinessLogic();

    //initialize transactions to avoid late initialization error
    transactions = [];
    getMyLendingBids();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: buildAppBar("MY LENDING BIDS", Colors.grey, Colors.white),
        drawer: buildDrawer(context, ""),
        body: BuildBody(context),
      ),
    );
  }

  Widget BuildBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5, left: 5, right: 5),
      child: Column(
        children: [
          SizedBox(height: 10),
          Text(
            "This page shows all the bids that you have placed to lend money.",
            style: TextStyle(color: Colors.black54, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          (isLoading)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    displayWaitingIndicator(),
                  ],
                )
              : (transactions.isEmpty)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 50),
                        Text("No bids to display", style: TextStyle(color: Colors.black54, fontSize: 12)),
                      ],
                    )
                  : Expanded(
                      child: new ListView(
                        children: transactions.map((transaction) {
                          late Widget widget;
                          transaction.bidders.forEach((bidder) {
                            if (bidder.userId == FirebaseAuth.instance.currentUser!.uid) {
                              widget = GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyLendingBidDetails(transactionId: transaction.transactionId)));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 2.5, bottom: 2.5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        spreadRadius: 0,
                                        blurRadius: 0,
                                        offset: Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              EnumToString.convertToString(transaction.transactionType, camelCase: true),
                                              style: TextStyle(color: Colors.grey, fontSize: 10),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Amount: ',
                                                  style: TextStyle(color: Colors.black, fontSize: 12),
                                                ),
                                                Text(
                                                  "\$${NumberFormat("###,000").format(transaction.amount).replaceAll(",", " ")}",
                                                  style: TextStyle(fontSize: 12, color: Colors.black54),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Rate(%): ',
                                                  style: TextStyle(color: Colors.black, fontSize: 12),
                                                ),
                                                Text(
                                                  transaction.interestRate.toString(),
                                                  style: TextStyle(fontSize: 12, color: Colors.black54),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Duration(Month): ',
                                                  style: TextStyle(color: Colors.black, fontSize: 12),
                                                ),
                                                Text(
                                                  transaction.duration.toString(),
                                                  style: TextStyle(color: Colors.black54, fontSize: 12),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Published on: ',
                                                  style: TextStyle(color: Colors.black, fontSize: 12),
                                                ),
                                                Text(
                                                  DateFormat('yyyy MMM dd').format(transaction.publishedDate),
                                                  style: TextStyle(color: Colors.black54, fontSize: 12),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Expires on: ',
                                                  style: TextStyle(color: Colors.black, fontSize: 12),
                                                ),
                                                Text(
                                                  DateFormat('yyyy MMM dd').format(transaction.dueDate),
                                                  style: TextStyle(color: Colors.black54, fontSize: 12),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Status: ',
                                                  style: TextStyle(color: Colors.black, fontSize: 12),
                                                ),
                                                Text(
                                                  EnumToString.convertToString(transaction.transactionStatus),
                                                  style: TextStyle(
                                                    color: (EnumToString.convertToString(transaction.transactionStatus) == "cancelled" ||
                                                            EnumToString.convertToString(transaction.transactionStatus) == "expired")
                                                        ? Colors.red
                                                        : Colors.black54,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(),
                                            Text(
                                              "My lending bid",
                                              style: TextStyle(color: Colors.grey, fontSize: 10),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Amount: ',
                                                  style: TextStyle(color: Colors.black, fontSize: 12),
                                                ),
                                                Text(
                                                  "\$${NumberFormat("###,000").format(bidder.amount).replaceAll(",", " ")}",
                                                  style: TextStyle(fontSize: 12, color: Colors.black54),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Rate(%): ',
                                                  style: TextStyle(color: Colors.black, fontSize: 12),
                                                ),
                                                Text(
                                                  bidder.interestRate.toString(),
                                                  style: TextStyle(fontSize: 12, color: Colors.black54),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Bid on: ',
                                                  style: TextStyle(color: Colors.black, fontSize: 12),
                                                ),
                                                Text(
                                                  DateFormat('yyyy MMM dd').format(bidder.bidDate),
                                                  style: TextStyle(color: Colors.black54, fontSize: 12),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Status: ',
                                                  style: TextStyle(color: Colors.black, fontSize: 12),
                                                ),
                                                Text(
                                                  EnumToString.convertToString(bidder.bidStatus),
                                                  style: TextStyle(
                                                    color: (EnumToString.convertToString(bidder.bidStatus) == "cancelled" || EnumToString.convertToString(bidder.bidStatus) == "unsuccessful")
                                                        ? Colors.red
                                                        : Colors.black54,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                                        ),
                                        width: 50,
                                        height: 200,
                                        child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          });
                          return widget;
                        }).toList(),
                      ),
                    ),
        ],
      ),
    );
  }

  Future<void> getMyLendingBids() async {
    await businessLogic.viewMyLendingBids().then(
      (String? value) {
        if (value == null) {
          setState(() {
            transactions = [];
            isLoading = false;
          });
        } else {
          var json = jsonDecode(value);
          List<Transactions> trans = [];
          json.forEach((tr) {
            trans.add(Transactions.fromJson(tr));
          });
          setState(() {
            transactions = trans;
            isLoading = false;
          });
        }
      },
    );
  }
}
