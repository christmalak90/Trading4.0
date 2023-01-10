import 'dart:convert';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user_app/HelperMethodes.dart';
import 'package:user_app/Users/BusinessLogic/BusinessLogic.dart';
import 'package:user_app/Users/BusinessLogic/Models/UserDetails.dart';
import 'package:user_app/Users/UserInterface/Login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const String idScreen = "profile";

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;
  late BusinessLogic businessLogic;
  late UserDetails userDetails;
  bool profileCompleted = false;
  final editPhoneFormGlobalKey = GlobalKey<FormState>();
  final editFullNameFormGlobalKey = GlobalKey<FormState>();
  final editAddressFormGlobalKey = GlobalKey<FormState>();
  final editDateOfBirthFormGlobalKey = GlobalKey<FormState>();
  final editIncomeFormGlobalKey = GlobalKey<FormState>();
  final editOccupationFormGlobalKey = GlobalKey<FormState>();
  final editHouseholdFormGlobalKey = GlobalKey<FormState>();
  final editEducationFormGlobalKey = GlobalKey<FormState>();
  final editRentFormGlobalKey = GlobalKey<FormState>();
  final editEmailFormGlobalKey = GlobalKey<FormState>();
  final editPasswordFormGlobalKey = GlobalKey<FormState>();
  final TextEditingController txtPhone = TextEditingController();
  final TextEditingController txtSMSCode = TextEditingController();
  final TextEditingController txtCurrentEmail = TextEditingController();
  final TextEditingController txtNewEmail = TextEditingController();
  final TextEditingController txtNewFullName = TextEditingController();
  final TextEditingController txtNewAddress = TextEditingController();
  final TextEditingController txtNewDateOfBirth = TextEditingController();
  final TextEditingController txtNewIncome = TextEditingController();
  final TextEditingController txtNewOccupation = TextEditingController();
  final TextEditingController txtNewHousehold = TextEditingController();
  final TextEditingController txtNewEducation = TextEditingController();
  final TextEditingController txtNewRent = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  final TextEditingController txtCurrentPassword = TextEditingController();
  final TextEditingController txtNewPassword = TextEditingController();
  final TextEditingController txtConfirmNewPassword = TextEditingController();

  @override
  void initState() {
    businessLogic = BusinessLogic();

    //initialize userDetails to avoid late initialization error
    userDetails = UserDetails(
      userId: "",
      address: null,
      dateOfBirth: null,
      income: null,
      occupation: null,
      household: null,
      education: null,
      rent: null,
    );

    //Get userDetails from database and verify if profile completed
    getUserDetails_and_verifyIfProfileCompleted();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar("PROFILE", Colors.grey.shade300, Colors.black54),
        drawer: buildDrawer(context, "profile"),
        body: buildBody(context),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10),
              ),
              (isLoading) ? displayWaitingIndicator() : Text(""),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              Image.asset(
                "images/user_icon.png",
                height: 100.0,
                width: 100.0,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              FutureBuilder(
                future: businessLogic.getDisplayName(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Text(
                      snapshot.data.toString(),
                      style: TextStyle(fontSize: 20.0, color: Colors.black54, fontWeight: FontWeight.bold),
                    );
                  }
                  return Text("");
                },
              ),
              FutureBuilder(
                future: businessLogic.getEmail(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Text(
                      snapshot.data.toString(),
                      style: TextStyle(fontSize: 12.0, fontFamily: "Brand Bold", color: Colors.grey),
                    );
                  }
                  return Text("");
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 40.0),
              ),
              (profileCompleted == false) ? Text("Complete profile in red to be able to start transactions", style: TextStyle(color: Colors.red, fontSize: 11)) : Text(""),
              Padding(
                padding: EdgeInsets.only(top: 5.0),
              ),
              Divider(
                color: Colors.grey,
                height: 0.0,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              ListTile(
                dense: true,
                leading: Icon(Icons.person),
                title: Text(
                  "Full name",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: FutureBuilder(
                  future: businessLogic.getDisplayName(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Text(
                        snapshot.data.toString(),
                        style: TextStyle(color: Colors.black54),
                      );
                    }
                    return Text("");
                  },
                ),
                trailing: GestureDetector(
                  onTap: () {
                    displayAlert(context, "Edit Full name", editFullNameFormField(), editFullNameSubmitButton());
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
                height: 0.0,
              ),
              ListTile(
                dense: true,
                leading: Icon(Icons.email),
                title: Text(
                  "Email",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: FutureBuilder(
                  future: businessLogic.getEmail(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Text(
                        snapshot.data.toString(),
                        style: TextStyle(color: Colors.black54),
                      );
                    }
                    return Text("");
                  },
                ),
                trailing: GestureDetector(
                  onTap: () {
                    displayAlert(context, "Enter new email", editEmailFormField(), editEmailSubmitButton());
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
                height: 0.0,
              ),
              ListTile(
                dense: true,
                leading: Icon(Icons.phone_android),
                title: Text(
                  "Phone",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: FutureBuilder(
                  future: businessLogic.getPhoneNumber(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data == null || snapshot.data == "") {
                        return Text("No phone provided", style: TextStyle(color: Colors.red, fontSize: 10));
                      } else {
                        return Text(
                          snapshot.data.toString(),
                          style: TextStyle(color: Colors.black54),
                        );
                      }
                    }
                    return Text("");
                  },
                ),
                trailing: GestureDetector(
                  onTap: () {
                    displayAlert(context, "Enter phone number", editPhoneFormField(), editPhoneSubmitButton());
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
                height: 0.0,
              ),
              ListTile(
                dense: true,
                leading: Icon(Icons.house),
                title: Text(
                  "Address",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: (userDetails.address.toString() == "null" || userDetails.address.toString() == "")
                    ? Text("No address provided", style: TextStyle(color: Colors.red, fontSize: 10))
                    : Text(userDetails.address.toString(), style: TextStyle(color: Colors.black54)),
                trailing: GestureDetector(
                  onTap: () {
                    displayAlert(context, "Edit Address", editAddressFormField(), editAddressSubmitButton());
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
                height: 0.0,
              ),
              ListTile(
                dense: true,
                leading: Icon(Icons.date_range),
                title: Text(
                  "Date of birth",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: (userDetails.dateOfBirth.toString() == "null" || userDetails.dateOfBirth.toString() == "")
                    ? Text("No date of birth provided", style: TextStyle(color: Colors.red, fontSize: 10))
                    : Text(DateFormat('yyyy MMMM dd').format(userDetails.dateOfBirth as DateTime), style: TextStyle(color: Colors.black54)),
                trailing: GestureDetector(
                  onTap: () {
                    displayAlert(context, "Edit Date of birth", editDateOfBirthFormField(), editDateOfBirthSubmitButton());
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
                height: 0.0,
              ),
              ListTile(
                dense: true,
                leading: Icon(Icons.money),
                title: Text(
                  "Income",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: (userDetails.income.toString() == "null" || userDetails.income.toString() == "")
                    ? Text("No income provided", style: TextStyle(color: Colors.red, fontSize: 10))
                    : Text("${userDetails.income.toString()} \$", style: TextStyle(color: Colors.black54)),
                trailing: GestureDetector(
                  onTap: () {
                    displayAlert(context, "Edit Income", editIncomeFormField(), editIncomeSubmitButton());
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
                height: 0.0,
              ),
              ListTile(
                dense: true,
                leading: Icon(Icons.work),
                title: Text(
                  "Occupation",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: (userDetails.occupation.toString() == "null" || userDetails.occupation.toString() == "")
                    ? Text("No occupation provided", style: TextStyle(color: Colors.red, fontSize: 10))
                    : Text(userDetails.occupation.toString(), style: TextStyle(color: Colors.black54)),
                trailing: GestureDetector(
                  onTap: () {
                    displayAlert(context, "Edit Occupation", editOccupationFormField(), editOccupationSubmitButton());
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
                height: 0.0,
              ),
              ListTile(
                dense: true,
                leading: Icon(Icons.people),
                title: Text(
                  "Household",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: (userDetails.household.toString() == "null" || userDetails.household.toString() == "")
                    ? Text("No household provided", style: TextStyle(color: Colors.red, fontSize: 10))
                    : Text("${userDetails.household.toString()} People", style: TextStyle(color: Colors.black54)),
                trailing: GestureDetector(
                  onTap: () {
                    displayAlert(context, "Edit Household", editHouseholdFormField(), editHouseholdSubmitButton());
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
                height: 0.0,
              ),
              ListTile(
                dense: true,
                leading: Icon(Icons.school),
                title: Text(
                  "Education",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: (userDetails.education.toString() == "null" || userDetails.education.toString() == "")
                    ? Text("No education provided", style: TextStyle(color: Colors.red, fontSize: 10))
                    : Text(userDetails.education.toString(), style: TextStyle(color: Colors.black54)),
                trailing: GestureDetector(
                  onTap: () {
                    displayAlert(context, "Edit Education", editEducationFormField(), editEducationSubmitButton());
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
                height: 0.0,
              ),
              ListTile(
                dense: true,
                leading: Icon(Icons.house_outlined),
                title: Text(
                  "Rent",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: (userDetails.rent.toString() == "null" || userDetails.rent.toString() == "")
                    ? Text("No rent provided", style: TextStyle(color: Colors.red, fontSize: 10))
                    : Text("${userDetails.rent.toString()} \$", style: TextStyle(color: Colors.black54)),
                trailing: GestureDetector(
                  onTap: () {
                    displayAlert(context, "Edit Rent", editRentFormField(), editRentSubmitButton());
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
                height: 0.0,
              ),
              FutureBuilder(
                future: FirebaseAuth.instance.fetchSignInMethodsForEmail(FirebaseAuth.instance.currentUser!.email.toString()),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data.toList().contains("password")) {
                      return ListTile(
                        tileColor: Colors.white,
                        dense: true,
                        leading: Icon(Icons.password),
                        title: Text(
                          "Password",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "************",
                          style: TextStyle(color: Colors.black54),
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            displayAlert(context, "Change password", editPasswordFormField(), editPasswordSubmitButton());
                          },
                          child: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                      );
                    }
                  }
                  return Padding(padding: EdgeInsets.zero);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget editPhoneFormField() {
    return Form(
      key: editPhoneFormGlobalKey,
      child: TextFormField(
        controller: txtPhone,
        keyboardType: TextInputType.phone,
        autofocus: true,
        style: TextStyle(fontSize: 13),
        decoration: InputDecoration(
          labelText: 'Phone number',
          labelStyle: TextStyle(fontSize: 12),
          prefixText: "+27",
          prefixStyle: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.bold),
          icon: Icon(Icons.phone_android),
          isDense: true,
        ),
        maxLength: 9,
        validator: (text) => RegExp(r"^[1-9]{1}[0-9]{8}$").hasMatch(text!) ? null : 'Enter a valid phone number',
      ),
    );
  }

  Widget editPhoneSubmitButton() {
    return ElevatedButton(
      child: Text(
        "Submit",
        style: TextStyle(fontSize: 11, color: Colors.white),
      ),
      onPressed: () async {
        if (editPhoneFormGlobalKey.currentState!.validate()) {
          FocusScope.of(context).requestFocus(FocusNode()); //hide the keyboard
          await businessLogic.verifyPhone(context, txtPhone.text.toString().trim());
          Navigator.of(context).pop();
          displayAlert(context, "Enter SMS Code", enterSMSCodeFormField(), enterSMSCodeButton());
        }
      },
    );
  }

  Widget enterSMSCodeFormField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Enter SMS Code that has been sent to your phone number, if you haven't received the code, please restart the process", style: TextStyle(color: Colors.red, fontSize: 10)),
        Form(
          //key: formGlobalKey,
          child: TextFormField(
            controller: txtSMSCode,
            keyboardType: TextInputType.text,
            autofocus: true,
            style: TextStyle(fontSize: 13),
            decoration: InputDecoration(
              labelText: 'SMS Code',
              labelStyle: TextStyle(fontSize: 12),
              icon: Icon(Icons.password),
              isDense: true,
            ),
            validator: (text) => RegExp(r"^[0-9 a-z]{6}$").hasMatch(text!) ? null : 'Enter a 6 digits SMS Code',
          ),
        ),
      ],
    );
  }

  Widget enterSMSCodeButton() {
    return ElevatedButton(
      child: Text(
        "Submit",
        style: TextStyle(fontSize: 11, color: Colors.white),
      ),
      onPressed: () async {
        String? value = await businessLogic.submitOTP(txtSMSCode.text.toString().trim());
        if (value == "success") {
          displayToastMessage("Phone verified", "success", context);
          Navigator.of(context).pop();
        } else {
          displayToastMessage("$value", "failed", context);
          Navigator.of(context).pop();
        }
      },
    );
  }

  Widget editAddressFormField() {
    return Form(
      key: editAddressFormGlobalKey,
      child: TextFormField(
        controller: txtNewAddress,
        keyboardType: TextInputType.streetAddress,
        autofocus: true,
        style: TextStyle(fontSize: 13),
        decoration: InputDecoration(
          labelText: 'New address',
          labelStyle: TextStyle(fontSize: 12),
          icon: Icon(Icons.house),
          isDense: true,
        ),
        validator: (text) => text == "" ? "Enter your address" : null,
      ),
    );
  }

  Widget editAddressSubmitButton() {
    return ElevatedButton(
      child: Text(
        "Submit",
        style: TextStyle(fontSize: 11, color: Colors.white),
      ),
      onPressed: () async {
        if (editAddressFormGlobalKey.currentState!.validate()) {
          FocusScope.of(context).requestFocus(FocusNode()); //hide the keyboard
          setState(() {
            isLoading = true;
          });
          String? value = await businessLogic.editAddress(txtNewAddress.text);
          if (value == "success") {
            setState(() {
              isLoading = false;
            });
            Navigator.of(context).pop();
            getUserDetails_and_verifyIfProfileCompleted();
            displayToastMessage("Address successfully edited", "success", context);
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

  Widget editFullNameFormField() {
    return Form(
      key: editFullNameFormGlobalKey,
      child: TextFormField(
        controller: txtNewFullName,
        keyboardType: TextInputType.name,
        autofocus: true,
        style: TextStyle(fontSize: 13),
        decoration: InputDecoration(
          labelText: 'Enter Full Name',
          labelStyle: TextStyle(fontSize: 12),
          icon: Icon(Icons.person),
          isDense: true,
        ),
        validator: (text) => text == "" ? "Enter your full name" : null,
      ),
    );
  }

  Widget editFullNameSubmitButton() {
    return ElevatedButton(
      child: Text(
        "Submit",
        style: TextStyle(fontSize: 11, color: Colors.white),
      ),
      onPressed: () async {
        if (editFullNameFormGlobalKey.currentState!.validate()) {
          FocusScope.of(context).requestFocus(FocusNode()); //hide the keyboard
          setState(() {
            isLoading = true;
          });
          String? value = await businessLogic.editFullName(txtNewFullName.text);
          if (value == "success") {
            setState(() {
              isLoading = false;
            });
            Navigator.of(context).pop();
            getUserDetails_and_verifyIfProfileCompleted();
            displayToastMessage("Full name successfully edited", "success", context);
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

  Widget editDateOfBirthFormField() {
    return Form(
      key: editDateOfBirthFormGlobalKey,
      child: DateTimePicker(
        controller: txtNewDateOfBirth,
        icon: Icon(Icons.date_range),
        autofocus: true,
        style: TextStyle(fontSize: 12),
        //initialValue: '',
        firstDate: DateTime(1950),
        lastDate: DateTime.now(),
        dateLabelText: 'New Date of birth',
        validator: (text) {
          if (text == "") {
            return "Enter your date of birth";
          }
          if (DateTime.now().year - DateTime.parse(text!).year < 18) {
            return "You must be 18 years old or older";
          }
        },
      ),
    );
  }

  Widget editDateOfBirthSubmitButton() {
    return ElevatedButton(
      child: Text(
        "Submit",
        style: TextStyle(fontSize: 11, color: Colors.white),
      ),
      onPressed: () async {
        if (editDateOfBirthFormGlobalKey.currentState!.validate()) {
          setState(() {
            isLoading = true;
          });
          String? value = await businessLogic.editDateOfBirth(DateTime.parse(txtNewDateOfBirth.text));
          if (value == "success") {
            setState(() {
              isLoading = false;
            });
            Navigator.of(context).pop();
            getUserDetails_and_verifyIfProfileCompleted();
            displayToastMessage("Date of birth successfully edited", "success", context);
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

  Widget editIncomeFormField() {
    return Form(
      key: editIncomeFormGlobalKey,
      child: TextFormField(
        controller: txtNewIncome,
        keyboardType: TextInputType.number,
        autofocus: true,
        style: TextStyle(fontSize: 13),
        decoration: InputDecoration(
          labelText: 'New Income',
          labelStyle: TextStyle(fontSize: 12),
          icon: Icon(Icons.money),
          isDense: true,
        ),
        validator: (text) {
          if (text == "") {
            return "Enter your income";
          }
          if (num.tryParse(text!) == null) {
            return "Enter a valid income";
          }
        },
      ),
    );
  }

  Widget editIncomeSubmitButton() {
    return ElevatedButton(
      child: Text(
        "Submit",
        style: TextStyle(fontSize: 11, color: Colors.white),
      ),
      onPressed: () async {
        if (editIncomeFormGlobalKey.currentState!.validate()) {
          setState(() {
            isLoading = true;
          });
          FocusScope.of(context).requestFocus(FocusNode()); //hide the keyboard
          String? value = await businessLogic.editIncome(num.parse(txtNewIncome.text));
          if (value == "success") {
            setState(() {
              isLoading = false;
            });
            Navigator.of(context).pop();
            getUserDetails_and_verifyIfProfileCompleted();
            displayToastMessage("Income successfully edited", "success", context);
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

  Widget editOccupationFormField() {
    return Form(
      key: editOccupationFormGlobalKey,
      child: TextFormField(
        controller: txtNewOccupation,
        keyboardType: TextInputType.text,
        autofocus: true,
        style: TextStyle(fontSize: 13),
        decoration: InputDecoration(
          labelText: 'New occupation',
          labelStyle: TextStyle(fontSize: 12),
          icon: Icon(Icons.work),
          isDense: true,
        ),
        validator: (text) => text == "" ? "Enter your occupation" : null,
      ),
    );
  }

  Widget editOccupationSubmitButton() {
    return ElevatedButton(
      child: Text(
        "Submit",
        style: TextStyle(fontSize: 11, color: Colors.white),
      ),
      onPressed: () async {
        if (editOccupationFormGlobalKey.currentState!.validate()) {
          setState(() {
            isLoading = true;
          });
          FocusScope.of(context).requestFocus(FocusNode()); //hide the keyboard
          String? value = await businessLogic.editOccupation(txtNewOccupation.text);
          if (value == "success") {
            setState(() {
              isLoading = false;
            });
            Navigator.of(context).pop();
            getUserDetails_and_verifyIfProfileCompleted();
            displayToastMessage("Occupation successfully edited", "success", context);
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

  Widget editHouseholdFormField() {
    return Form(
      key: editHouseholdFormGlobalKey,
      child: TextFormField(
        controller: txtNewHousehold,
        keyboardType: TextInputType.number,
        autofocus: true,
        style: TextStyle(fontSize: 13),
        decoration: InputDecoration(
          labelText: 'New household',
          labelStyle: TextStyle(fontSize: 12),
          icon: Icon(Icons.house),
          isDense: true,
        ),
        validator: (text) {
          if (text == "") {
            return "Enter your household";
          }
          if (int.tryParse(text!) == null) {
            return "Enter integer number";
          }
        },
      ),
    );
  }

  Widget editHouseholdSubmitButton() {
    return ElevatedButton(
      child: Text(
        "Submit",
        style: TextStyle(fontSize: 11, color: Colors.white),
      ),
      onPressed: () async {
        if (editHouseholdFormGlobalKey.currentState!.validate()) {
          setState(() {
            isLoading = true;
          });
          FocusScope.of(context).requestFocus(FocusNode()); //hide the keyboard
          String? value = await businessLogic.editHousehold(int.parse(txtNewHousehold.text));
          if (value == "success") {
            setState(() {
              isLoading = false;
            });
            Navigator.of(context).pop();
            getUserDetails_and_verifyIfProfileCompleted();
            displayToastMessage("Household successfully edited", "success", context);
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

  Widget editEducationFormField() {
    return Form(
      key: editEducationFormGlobalKey,
      child: DropdownButtonFormField<String>(
        validator: (text) => text == null ? "Select your education" : null,
        style: TextStyle(fontSize: 12, color: Colors.black54),
        icon: Icon(Icons.school),
        hint: Text(
          "Select",
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
        dropdownColor: Colors.white,
        iconSize: 20,
        onChanged: (String? newValue) {
          txtNewEducation.text = newValue!;
        },
        items: <String>['No education', 'Primary school', 'High school', 'College', 'Bachelor degree', 'Honours degree', 'Master degree', 'PhD'].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget editEducationSubmitButton() {
    return ElevatedButton(
      child: Text(
        "Submit",
        style: TextStyle(fontSize: 11, color: Colors.white),
      ),
      onPressed: () async {
        if (editEducationFormGlobalKey.currentState!.validate()) {
          setState(() {
            isLoading = true;
          });
          FocusScope.of(context).requestFocus(FocusNode()); //hide the keyboard
          String? value = await businessLogic.editEducation(txtNewEducation.text);
          if (value == "success") {
            setState(() {
              isLoading = false;
            });
            Navigator.of(context).pop();
            getUserDetails_and_verifyIfProfileCompleted();
            displayToastMessage("Education successfully edited", "success", context);
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

  Widget editRentFormField() {
    return Form(
      key: editRentFormGlobalKey,
      child: TextFormField(
        controller: txtNewRent,
        keyboardType: TextInputType.number,
        autofocus: true,
        style: TextStyle(fontSize: 13),
        decoration: InputDecoration(
          labelText: 'New rent',
          labelStyle: TextStyle(fontSize: 12),
          icon: Icon(Icons.money),
          isDense: true,
        ),
        validator: (text) {
          if (text == "") {
            return "Enter your rent";
          }
          if (num.tryParse(text!) == null) {
            return "Enter a valid rent";
          }
        },
      ),
    );
  }

  Widget editRentSubmitButton() {
    return ElevatedButton(
      child: Text(
        "Submit",
        style: TextStyle(fontSize: 11, color: Colors.white),
      ),
      onPressed: () async {
        if (editRentFormGlobalKey.currentState!.validate()) {
          setState(() {
            isLoading = true;
          });
          FocusScope.of(context).requestFocus(FocusNode()); //hide the keyboard
          String? value = await businessLogic.editRent(num.parse(txtNewRent.text));
          if (value == "success") {
            setState(() {
              isLoading = false;
            });
            Navigator.of(context).pop();
            getUserDetails_and_verifyIfProfileCompleted();
            displayToastMessage("Rent successfully edited", "success", context);
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

  Widget editEmailFormField() {
    return Form(
      key: editEmailFormGlobalKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: txtCurrentEmail,
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
            style: TextStyle(fontSize: 13),
            decoration: InputDecoration(
              labelText: 'Current email address',
              labelStyle: TextStyle(fontSize: 12),
              icon: Icon(Icons.email),
              isDense: true,
            ),
            validator: (text) => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(text!) ? null : 'Valid email is required',
          ),
          TextFormField(
            controller: txtNewEmail,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(fontSize: 13),
            decoration: InputDecoration(
              labelText: 'New email address',
              labelStyle: TextStyle(fontSize: 12),
              icon: Icon(Icons.email),
              isDense: true,
            ),
            validator: (text) {
              if (text == txtCurrentEmail.text) {
                return "Emails must not match";
              }
              if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(text!)) {
                return 'Valid email is required';
              }
            },
          ),
          TextFormField(
            controller: txtPassword,
            keyboardType: TextInputType.visiblePassword,
            style: TextStyle(fontSize: 13),
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(fontSize: 12),
              icon: Icon(Icons.enhanced_encryption),
              isDense: true,
            ),
            validator: (text) => text!.isEmpty ? 'Password is required' : null,
          ),
        ],
      ),
    );
  }

  Widget editEmailSubmitButton() {
    return ElevatedButton(
      child: Text(
        "Submit",
        style: TextStyle(fontSize: 11, color: Colors.white),
      ),
      onPressed: () async {
        if (editEmailFormGlobalKey.currentState!.validate()) {
          FocusScope.of(context).requestFocus(FocusNode()); //hide the keyboard
          setState(() {
            isLoading = true;
          });
          String? value = await businessLogic.logIn(txtCurrentEmail.text, txtPassword.text);
          if (value == "success") {
            String? value2 = await businessLogic.editEmail(txtNewEmail.text);
            if (value2 == "success") {
              setState(() {
                isLoading = false;
              });
              Navigator.of(context).pop();
              await businessLogic.logOut();
              Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
              displayAlert(
                  context,
                  "Email updated",
                  Text(
                    "You need to login with your new email",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(padding: EdgeInsets.zero));
            } else {
              setState(() {
                isLoading = false;
              });
              displayToastMessage("$value2", "failed", context);
            }
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

  Widget editPasswordFormField() {
    return Form(
      key: editPasswordFormGlobalKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: txtCurrentPassword,
            keyboardType: TextInputType.visiblePassword,
            autofocus: true,
            obscureText: true,
            style: TextStyle(fontSize: 13),
            decoration: InputDecoration(
              labelText: 'Current password',
              labelStyle: TextStyle(fontSize: 12),
              icon: Icon(Icons.password),
              isDense: true,
            ),
            validator: (text) => text!.isEmpty ? 'Password is required' : null,
          ),
          TextFormField(
            controller: txtNewPassword,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            style: TextStyle(fontSize: 13),
            decoration: InputDecoration(
              labelText: 'New password',
              labelStyle: TextStyle(fontSize: 12),
              icon: Icon(Icons.enhanced_encryption),
              isDense: true,
            ),
            validator: (text) => RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$").hasMatch(text!)
                ? null
                : '- At least one upper case \n- At least one lower case \n- At least one digit \n- At least one Special character \n- At least 8 characters in length',
          ),
          TextFormField(
            controller: txtConfirmNewPassword,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            style: TextStyle(fontSize: 13),
            decoration: InputDecoration(
              labelText: 'Confirm new password',
              labelStyle: TextStyle(fontSize: 12),
              icon: Icon(Icons.enhanced_encryption),
              isDense: true,
            ),
            validator: (text) => (text!) != txtNewPassword.text ? "Passwords don't match" : null,
          ),
        ],
      ),
    );
  }

  Widget editPasswordSubmitButton() {
    return ElevatedButton(
      child: Text(
        "Submit",
        style: TextStyle(fontSize: 11, color: Colors.white),
      ),
      onPressed: () async {
        if (editPasswordFormGlobalKey.currentState!.validate()) {
          setState(() {
            isLoading = true;
          });
          FocusScope.of(context).requestFocus(FocusNode()); //hide the keyboard
          String? email = await businessLogic.getEmail();
          String? value = await businessLogic.logIn(email!, txtCurrentPassword.text);
          if (value == "success") {
            await businessLogic.editPassword(txtNewPassword.text);
            Navigator.of(context).pop();
            setState(() {
              isLoading = false;
            });
            await businessLogic.logOut();
            Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
            displayAlert(
              context,
              "Password updated",
              Text(
                "You need to login with your new password",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.zero,
              ),
            );
          } else {
            displayToastMessage("$value", "failed", context);
          }
        }
      },
    );
  }

  //Get userDetails from database and verify if profile is completed
  Future<void> getUserDetails_and_verifyIfProfileCompleted() async {
    await businessLogic.getUserDetails(FirebaseAuth.instance.currentUser!.uid).then(
      (String? value) {
        if (value == null) {
        } else {
          Map<String, dynamic> json = jsonDecode(value);
          setState(
            () {
              userDetails = UserDetails.fromJson(json);
            },
          );
        }
      },
    );
    await businessLogic.profileCompleted().then((String? value) {
      if (value == "yes") {
        setState(() {
          profileCompleted = true;
        });
      }
      if (value == "no") {
        setState(() {
          profileCompleted = false;
        });
      }
    });
  }
}
