import 'dart:convert';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:user_app/HelperMethodes.dart';
import 'package:user_app/Trading/BusinessLogic/BusinessLogic.dart';
import 'package:user_app/Trading/BusinessLogic/Models/TransactionStatusEnum.dart';
import 'package:user_app/Trading/BusinessLogic/Models/TransactionTypeEnum.dart';
import 'package:user_app/Trading/BusinessLogic/Models/Transactions.dart';
import 'package:user_app/Trading/UserInterface/BorrowingRequests.dart';
import 'package:user_app/Trading/UserInterface/LendingOffers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String idScreen = "home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  late BusinessLogic businessLogic;
  late TransactionType transactionType; //Used when publishing a transaction to know if the transaction is a lending offer or borrowing request
  final publishTransactionFormGlobalKey = GlobalKey<FormState>();
  final TextEditingController txtTransactionAmount = TextEditingController();
  final TextEditingController txtInterestRate = TextEditingController();
  final TextEditingController txtDuration = TextEditingController();
  final TextEditingController txtDueDate = TextEditingController();

  @override
  void initState() {
    businessLogic = BusinessLogic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: buildAppBar("HOME", Colors.grey.shade300, Colors.black54),
        drawer: buildDrawer(context, "home"),
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
          (isLoading) ? displayWaitingIndicator() : Text(""),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
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
                    transactionType = TransactionType.LendingOffer;
                    displayAlert(context, "Publish lending offer", publishTransactionForm(), publishTransactionSubmitButton());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
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
                          "Publish Lending Offer",
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
                    transactionType = TransactionType.BorrowingRequest;
                    displayAlert(context, "Publish borrowing request", publishTransactionForm(), publishTransactionSubmitButton());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
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
                          "Publish Borrowing Request",
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
                    Navigator.pushNamed(context, LendingOffers.idScreen);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
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
                          "View Lending Offers",
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
                    Navigator.pushNamed(context, BorrowingRequests.idScreen);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
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
                          "View Borrowing Requests",
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

  //Form to publish a lending offer or borrowing request
  Widget publishTransactionForm() {
    return Form(
      key: publishTransactionFormGlobalKey,
      child: Column(
        children: [
          transactionAmountTextField(),
          interestRateTextField(),
          durationTextField(),
          dueDateTextField(),
        ],
      ),
    );
  }

  Widget publishTransactionSubmitButton() {
    return ElevatedButton(
      child: Text(
        "Submit",
        style: TextStyle(fontSize: 11, color: Colors.white),
      ),
      onPressed: () async {
        if (publishTransactionFormGlobalKey.currentState!.validate()) {
          FocusScope.of(context).requestFocus(FocusNode()); //hide the keyboard
          setState(() {
            isLoading = true;
          });
          Transactions trans = Transactions(
            //Will be updated later in the firebaseDatabase file
            transactionId: "null",
            //Will be updated later in the firebaseDatabase file
            userId: "null",
            transactionType: transactionType,
            amount: num.parse(txtTransactionAmount.text),
            interestRate: num.parse(txtInterestRate.text),
            duration: int.parse(txtDuration.text),
            dueDate: DateTime.parse(txtDueDate.text),
            publishedDate: DateTime.now(),
            transactionStatus: TransactionStatus.onGoing,
            bidders: [],
          );

          String? value = await businessLogic.newTransaction(trans);
          if (value == "success") {
            setState(() {
              isLoading = false;
            });
            Navigator.of(context).pop();
            displayToastMessage("${EnumToString.convertToString(transactionType, camelCase: true)} successfully published", "success", context);
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

  Widget transactionAmountTextField() {
    return TextFormField(
      maxLength: 5,
      controller: txtTransactionAmount,
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

  Widget durationTextField() {
    return TextFormField(
      controller: txtDuration,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 13),
      decoration: InputDecoration(
        labelText: 'Repayment duration',
        labelStyle: TextStyle(fontSize: 12),
        prefixText: "Month(S) ",
        prefixStyle: TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.bold),
        icon: Icon(Icons.access_time),
        isDense: true,
      ),
      validator: (text) {
        if (text == "") {
          return "Enter a duration";
        }
        if (int.tryParse(text!) == null) {
          return "Enter integer number";
        }
      },
    );
  }

  Widget dueDateTextField() {
    return DateTimePicker(
      controller: txtDueDate,
      icon: Icon(Icons.date_range),
      style: TextStyle(fontSize: 12),
      firstDate: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      lastDate: new DateTime(DateTime.now().year, DateTime.now().month + 3, DateTime.now().day),
      dateLabelText: '${EnumToString.convertToString(transactionType, camelCase: true)} expiration date',
      validator: (text) {
        if (text == "") {
          return "Enter a date";
        }
        if (DateTime.parse(text!).difference(DateTime.now()).inDays > 60) {
          return "The ${EnumToString.convertToString(transactionType, camelCase: true)} cannot be\npublished for more than 60 days";
        }
        if (DateTime.parse(text).difference(DateTime.now()).inDays < 7) {
          return "The ${EnumToString.convertToString(transactionType, camelCase: true)} must be\npublished for at least 7 days";
        }
      },
    );
  }
}
