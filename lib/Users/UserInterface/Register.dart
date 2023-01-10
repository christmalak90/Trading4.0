import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:user_app/HelperMethodes.dart';
import 'package:user_app/Trading/UserInterface/Home.dart';
import 'package:user_app/Users/BusinessLogic/BusinessLogic.dart';
import 'package:user_app/Users/BusinessLogic/Models/User.dart';
import 'package:user_app/Users/UserInterface/Login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  static const String idScreen = "register";

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;
  late BusinessLogic businessLogic;
  final formGlobalKey = GlobalKey<FormState>();
  final TextEditingController txtFirstName = TextEditingController();
  final TextEditingController txtSurName = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  final TextEditingController txtConfirmPassword = TextEditingController();

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
        body: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
            (isLoading) ? displayWaitingIndicator() : Text(""),
            Padding(
              padding: EdgeInsets.only(top: 50),
            ),
            Text(
              "Trading4.0",
              style: TextStyle(color: Colors.black54),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            Text(
              "Register",
              style: TextStyle(color: Colors.black54, fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
            ),
            Form(
              key: formGlobalKey,
              child: Column(
                children: [
                  firstNameInput(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  surNameInput(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  emailInput(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  passwordInput(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  confirmPasswordInput(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                  ),
                  BtnSignUp(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                      ),
                      Text(
                        "Or",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  BtnSignupWithGoogle(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                  ),
                  BtnSignupWithFacebook(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                  ),
                  btnLogIn(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget firstNameInput() {
    return TextFormField(
      controller: txtFirstName,
      keyboardType: TextInputType.name,
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle),
        labelText: 'First name',
        isDense: true,
        border: OutlineInputBorder(),
      ),
      validator: (text) => text!.isEmpty ? 'First name is required' : null,
    );
  }

  Widget surNameInput() {
    return TextFormField(
      controller: txtSurName,
      keyboardType: TextInputType.name,
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: 'Surname',
        prefixIcon: Icon(Icons.account_circle_outlined),
        isDense: true,
        border: OutlineInputBorder(),
      ),
      validator: (text) => text!.isEmpty ? 'Surname is required' : null,
    );
  }

  Widget emailInput() {
    return TextFormField(
      controller: txtEmail,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email),
        isDense: true,
        border: OutlineInputBorder(),
      ),
      validator: (text) => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(text!) ? null : 'Valid email is required',
    );
  }

  Widget passwordInput() {
    return TextFormField(
      controller: txtPassword,
      keyboardType: TextInputType.visiblePassword,
      style: TextStyle(fontSize: 14),
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: Icon(Icons.enhanced_encryption),
        isDense: true,
        border: OutlineInputBorder(),
      ),
      validator: (text) => RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$").hasMatch(text!)
          ? null
          : 'Password must be  \n - At least one upper case \n - At least one lower case \n - At least one digit \n - Should contain at least one Special character \n - Must be at least 8 characters in length',
    );
  }

  Widget confirmPasswordInput() {
    return TextFormField(
      controller: txtConfirmPassword,
      keyboardType: TextInputType.visiblePassword,
      style: TextStyle(fontSize: 14),
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        prefixIcon: Icon(Icons.enhanced_encryption),
        isDense: true,
        border: OutlineInputBorder(),
      ),
      validator: (text) => (text!) != txtPassword.text ? "Passwords don't match" : null,
    );
  }

  Widget BtnSignUp() {
    return Container(
      height: 50,
      child: ElevatedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Register",
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ],
        ),
        onPressed: () async {
          if (formGlobalKey.currentState!.validate()) {
            FocusScope.of(context).requestFocus(FocusNode()); //hide the keyboard
            setState(() {
              isLoading = true;
            });
            User user = User(
              firstName: txtFirstName.text,
              surName: txtSurName.text,
              email: txtEmail.text,
              phone: null,
              password: txtPassword.text,
            );
            String? value = await businessLogic.register(user);
            if (value == "success") {
              setState(() {
                isLoading = false;
              });
              displayToastMessage("Sign up successful", "success", context);
              Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
            } else {
              setState(() {
                isLoading = false;
              });
              displayToastMessage("$value", "failed", context);
            }
          }
        },
      ),
    );
  }

  Widget BtnSignupWithGoogle() {
    return Container(
      height: 50,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "images/google_logo.png",
              height: 30.0,
              width: 30.0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
            ),
            Text(
              "Register with Google",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        onPressed: () async {
          businessLogic.loginWithGoogle().then(
            (value) async {
              if (value == "success") {
                displayToastMessage("Sign up successful", "success", context);
                Navigator.pushNamedAndRemoveUntil(context, HomeScreen.idScreen, (route) => false);
              } else if (value == "login") {
                displayToastMessage("The google account ${await businessLogic.getEmail()} is already registered", "failed", context);
                businessLogic.logOut();
              } else {
                displayToastMessage("$value", "failed", context);
              }
            },
          );
        },
      ),
    );
  }

  Widget BtnSignupWithFacebook() {
    return Container(
      height: 50,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          shadowColor: MaterialStateProperty.all<Color>(Colors.indigo),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "images/facebook_logo.png",
              height: 30.0,
              width: 30.0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
            ),
            Text(
              "Register with Facebook",
              style: TextStyle(fontSize: 13, color: Colors.indigo),
            ),
          ],
        ),
        onPressed: () async {
          businessLogic.signInWithFacebook().then(
            (value) async {
              if (value == "success") {
                displayToastMessage("Sign up successful", "success", context);
                Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
              } else if (value == "login") {
                displayToastMessage("The Facebook account ${await businessLogic.getEmail()} is already registered", "failed", context);
                businessLogic.logOut();
              } else {
                displayToastMessage("$value", "failed", context);
              }
            },
          );
        },
      ),
    );
  }

  Widget btnLogIn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Has an account?",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
          },
          child: Text(
            "Login here",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
