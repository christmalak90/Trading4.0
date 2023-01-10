import 'dart:convert';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:user_app/HelperMethodes.dart';
import 'package:user_app/Trading/BusinessLogic/BusinessLogic.dart';
import 'package:user_app/Trading/BusinessLogic/Models/BidStatusEnum.dart';
import 'package:user_app/Trading/BusinessLogic/Models/Bidder.dart';
import 'package:user_app/Trading/BusinessLogic/Models/TransactionStatusEnum.dart';
import 'package:user_app/Trading/BusinessLogic/Models/TransactionTypeEnum.dart';
import 'package:user_app/Trading/BusinessLogic/Models/Transactions.dart';

class MyLendingBidDetails extends StatefulWidget {
  final String transactionId;

  const MyLendingBidDetails({Key? key, required this.transactionId}) : super(key: key);

  @override
  _MyLendingBidDetailsState createState() => _MyLendingBidDetailsState();
}

class _MyLendingBidDetailsState extends State<MyLendingBidDetails> {
  late BusinessLogic businessLogic;
  late Transactions transaction;
  final editBidFormGlobalKey = GlobalKey<FormState>();
  final TextEditingController txtBidAmount = TextEditingController();
  final TextEditingController txtInterestRate = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    businessLogic = BusinessLogic();

    //initialize transaction to avoid late initialization error
    transaction = Transactions(
      transactionId: widget.transactionId,
      userId: "",
      transactionType: TransactionType.BorrowingRequest,
      amount: 0.0,
      interestRate: 0.0,
      duration: 0,
      publishedDate: DateTime.now(),
      dueDate: DateTime.now(),
      transactionStatus: TransactionStatus.onGoing,
      bidders: [],
    );

    getMyLendingBidDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: buildAppBar("MY LENDING BID DETAILS", Colors.grey, Colors.white),
        drawer: buildDrawer(context, ""),
        body: BuildBody(context),
      ),
    );
  }

  Widget BuildBody(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 190,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
          ),
          child: Row(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 42.0),
                  ),
                  Column(
                    children: [
                      Text(
                        'Duration(Month)',
                        style: TextStyle(color: Colors.grey.shade900, fontSize: 11),
                      ),
                      Text(
                        transaction.duration.toString(),
                        style: TextStyle(color: Colors.grey.shade900, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Expanded(child: Text("")),
                  Column(
                    children: [
                      Text(
                        'Published',
                        style: TextStyle(color: Colors.grey.shade900, fontSize: 11),
                      ),
                      Text(
                        DateFormat('yyyy MMM dd').format(transaction.publishedDate),
                        style: TextStyle(color: Colors.grey.shade900, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(child: Text("")),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Amount',
                          style: TextStyle(color: Colors.grey.shade900, fontSize: 11),
                        ),
                        Text(
                          "\$${NumberFormat("###,000").format(transaction.amount).replaceAll(",", " ")}",
                          style: TextStyle(color: Colors.grey.shade900, fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: Text("")),
                  Column(
                    children: [
                      Text(
                        'Status',
                        style: TextStyle(color: Colors.grey.shade900, fontSize: 11),
                      ),
                      Text(
                        EnumToString.convertToString(transaction.transactionStatus),
                        style: TextStyle(
                          color: (EnumToString.convertToString(transaction.transactionStatus) == "cancelled" || EnumToString.convertToString(transaction.transactionStatus) == "expired")
                              ? Colors.red
                              : Colors.grey.shade900,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(child: Text("")),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 42.0),
                  ),
                  Column(
                    children: [
                      Text(
                        'Rate(%)',
                        style: TextStyle(color: Colors.grey.shade900, fontSize: 11),
                      ),
                      Text(
                        transaction.interestRate.toString(),
                        style: TextStyle(color: Colors.grey.shade900, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Expanded(child: Text("")),
                  Column(
                    children: [
                      Text(
                        'Expires',
                        style: TextStyle(color: Colors.grey.shade900, fontSize: 11),
                      ),
                      Text(
                        DateFormat('yyyy MMM dd').format(transaction.dueDate),
                        style: TextStyle(color: Colors.grey.shade900, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
          child: Row(
            children: [
              Text("Bids(${transaction.bidders.length}):", style: TextStyle(color: Colors.black54, fontSize: 13)),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: (isLoading)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      displayWaitingIndicator(),
                    ],
                  )
                : (transaction.bidders.isEmpty)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 50),
                          Text("No bids to display", style: TextStyle(color: Colors.black54, fontSize: 12)),
                        ],
                      )
                    : new ListView(
                        children: transaction.bidders.map((bidder) {
                          return Container(
                            margin: EdgeInsets.only(top: 5, bottom: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
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
                                Container(
                                  decoration: BoxDecoration(
                                    color: (bidder.userId == FirebaseAuth.instance.currentUser!.uid) ? Colors.green.shade200 : Colors.grey.shade200,
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                  ),
                                  width: 70,
                                  height: (bidder.userId == FirebaseAuth.instance.currentUser!.uid)
                                      ? (EnumToString.convertToString(bidder.bidStatus) == "cancelled")
                                          ? 70
                                          : 110
                                      : 70,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Rate(%)",
                                        style: TextStyle(
                                          color: (bidder.userId == FirebaseAuth.instance.currentUser!.uid) ? Colors.green.shade700 : Colors.grey.shade700,
                                          fontSize: 11,
                                        ),
                                      ),
                                      Text(
                                        bidder.interestRate.toString(),
                                        style: TextStyle(
                                          color: (bidder.userId == FirebaseAuth.instance.currentUser!.uid) ? Colors.green.shade700 : Colors.grey.shade700,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (bidder.userId == FirebaseAuth.instance.currentUser!.uid) ? "My lending bid" : "Lending bid",
                                        style: TextStyle(color: (bidder.userId == FirebaseAuth.instance.currentUser!.uid) ? Colors.green : Colors.grey, fontSize: 10),
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
                                Row(
                                  children: [
                                    Text(
                                      "\$${NumberFormat("###,000").format(bidder.amount).replaceAll(",", " ")}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                  ],
                                ),
                                (bidder.userId == FirebaseAuth.instance.currentUser!.uid)
                                    ? Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                                        ),
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                displayAlert(context, "Edit bid", editBidForm(), editBidSubmitButton());
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(top: 7, bottom: 7),
                                                decoration: BoxDecoration(
                                                  color: Colors.green.shade300,
                                                  borderRadius: BorderRadius.only(
                                                      topRight: Radius.circular(10),
                                                      bottomRight: (EnumToString.convertToString(bidder.bidStatus) == "cancelled" ? Radius.circular(10) : Radius.circular(0))),
                                                ),
                                                width: 50,
                                                height: (EnumToString.convertToString(bidder.bidStatus) == "cancelled") ? 69 : 55,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.edit, color: Colors.white),
                                                    SizedBox(height: 3),
                                                    Text("Edit", style: TextStyle(color: Colors.white, fontSize: 11)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            (EnumToString.convertToString(bidder.bidStatus) == "cancelled")
                                                ? SizedBox(height: 0)
                                                : GestureDetector(
                                                    onTap: () {
                                                      displayAlert(
                                                          context,
                                                          "Cancel bid",
                                                          Text(
                                                            "Do you really want to cancel your bid",
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 12,
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                          cancelBidSubmitButton());
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.only(top: 7, bottom: 7),
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(10)),
                                                      ),
                                                      width: 50,
                                                      child: Column(
                                                        children: [
                                                          Icon(Icons.cancel, color: Colors.white),
                                                          SizedBox(height: 3),
                                                          Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 11)),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      )
                                    : Text(""),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.crop_square, color: Colors.grey),
                  SizedBox(width: 5),
                  Text("Bid(s) that other users have placed", style: TextStyle(color: Colors.black, fontSize: 11)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.crop_square, color: Colors.green),
                  SizedBox(width: 5),
                  Text("bid that you have placed", style: TextStyle(color: Colors.black, fontSize: 11)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget editBidForm() {
    return Form(
      key: editBidFormGlobalKey,
      child: Column(
        children: [
          bidAmountTextField(),
          interestRateTextField(),
        ],
      ),
    );
  }

  Widget bidAmountTextField() {
    return TextFormField(
      maxLength: 5,
      controller: txtBidAmount,
      keyboardType: TextInputType.number,
      autofocus: true,
      style: TextStyle(fontSize: 13),
      decoration: InputDecoration(
        labelText: 'Amount',
        labelStyle: TextStyle(fontSize: 12),
        icon: Icon(Icons.money),
        isDense: true,
      ),
      validator: (text) {
        if (text == "") {
          return "Enter an amount";
        }
        if (num.tryParse(text!) == null) {
          return "Enter a valid amount";
        }
      },
    );
  }

  Widget interestRateTextField() {
    return TextFormField(
      controller: txtInterestRate,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 13),
      maxLength: 4,
      decoration: InputDecoration(
        labelText: 'Interest rate',
        labelStyle: TextStyle(fontSize: 12),
        prefixText: "% ",
        prefixStyle: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.bold),
        icon: Icon(Icons.add_box),
        isDense: true,
      ),
      validator: (text) {
        if (text == "") {
          return "Enter an interest rate";
        }
        if (num.tryParse(text!) == null) {
          return "Enter a valid number";
        }
      },
    );
  }

  Widget editBidSubmitButton() {
    return ElevatedButton(
      child: Text(
        "Submit",
        style: TextStyle(fontSize: 11, color: Colors.white),
      ),
      onPressed: () async {
        if (editBidFormGlobalKey.currentState!.validate()) {
          FocusScope.of(context).requestFocus(FocusNode()); //hide the keyboard
          setState(() {
            isLoading = true;
          });
          String? value = await businessLogic.editBid(transaction.transactionId, num.parse(txtBidAmount.text), num.parse(txtInterestRate.text));
          if (value == "success") {
            displayToastMessage("Bid successfully edited", "success", context);
            Navigator.of(context).pop();
            getMyLendingBidDetails();
          } else {
            setState(() {
              isLoading = false;
            });
            displayToastMessage("$value", "failed", context);
          }
        }
      },
    );
  }

  Widget cancelBidSubmitButton() {
    return ElevatedButton(
      child: Text(
        "Yes",
        style: TextStyle(fontSize: 11, color: Colors.white),
      ),
      onPressed: () async {
        setState(() {
          isLoading = true;
        });
        String? value = await businessLogic.cancelBid(transaction.transactionId);
        if (value == "success") {
          displayToastMessage("Bid cancelled", "success", context);
          Navigator.of(context).pop();
          getMyLendingBidDetails();
        } else {
          setState(() {
            isLoading = false;
          });
          displayToastMessage("$value", "failed", context);
        }
      },
    );
  }

  Future<void> getMyLendingBidDetails() async {
    await businessLogic.viewTransactionDetails(widget.transactionId).then(
      (String? value) {
        if (value == null) {
          setState(() {
            isLoading = false;
          });
        } else {
          var json = jsonDecode(value);

          setState(() {
            transaction = Transactions.fromJson(json);
            isLoading = false;
          });
        }
      },
    );
  }
}
