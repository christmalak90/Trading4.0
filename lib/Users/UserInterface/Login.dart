import 'package:flutter/material.dart';
import 'package:user_app/HelperMethodes.dart';
import 'package:user_app/Trading/UserInterface/Home.dart';
import 'package:user_app/Users/BusinessLogic/BusinessLogic.dart';
import 'package:user_app/Users/UserInterface/Register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String idScreen = "login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  late BusinessLogic businessLogic;
  final formGlobalKey = GlobalKey<FormState>();
  final resetPasswordFormGlobalKey = GlobalKey<FormState>();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  final TextEditingController txtResetPasswordEmail = TextEditingController();
  late String userEmail;

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
              "Login",
              style: TextStyle(color: Colors.black54, fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
            ),
            Form(
              key: formGlobalKey,
              child: Column(
                children: [
                  emailInput(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  passwordInput(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                  ),
                  btnLogIn(),
                  btnForgetPassword(),
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
                  BtnLoginWithGoogle(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                  ),
                  BtnLoginWithFacebook(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                  ),
                  btnRegister(),
                ],
              ),
            ),
          ],
        ),
      ),
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
      validator: (text) => text!.isEmpty ? 'Password is required' : null,
    );
  }

  Widget btnLogIn() {
    return Container(
      height: 50,
      child: ElevatedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Login",
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
            String? value = await businessLogic.logIn(txtEmail.text, txtPassword.text);
            if (value == "success") {
              if (await businessLogic.emailVerified() == "yes") {
                setState(() {
                  isLoading = false;
                });
                Navigator.pushNamedAndRemoveUntil(context, HomeScreen.idScreen, (route) => false);
              } else {
                setState(() {
                  isLoading = false;
                });
                displayAlert(
                  context,
                  "Verify email",
                  Text(
                    "You must verify your email to login",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  btnVerifyEmail(),
                );
              }
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

  Widget btnForgetPassword() {
    return TextButton(
      onPressed: () async {
        displayAlert(
          context,
          "Reset password",
          resetPasswordFormField(),
          resetPasswordSubmitButton(),
        );
      },
      child: Text(
        "Forgot Password?",
        style: TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }

  Widget resetPasswordFormField() {
    return Form(
      key: resetPasswordFormGlobalKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: txtResetPasswordEmail,
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
            style: TextStyle(fontSize: 13),
            decoration: InputDecoration(
              labelText: 'Email address',
              icon: Icon(Icons.email),
              isDense: true,
            ),
            validator: (text) => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(text!) ? null : 'Valid email is required',
          ),
        ],
      ),
    );
  }

  Widget resetPasswordSubmitButton() {
    return ElevatedButton(
      child: Text(
        "Submit",
        style: TextStyle(fontSize: 11, color: Colors.white),
      ),
      onPressed: () async {
        if (resetPasswordFormGlobalKey.currentState!.validate()) {
          FocusScope.of(context).requestFocus(FocusNode()); //hide the keyboard
          setState(() {
            isLoading = true;
          });
          String? value = await businessLogic.retrievePassword(txtResetPasswordEmail.text);
          if (value == "success") {
            setState(() {
              isLoading = false;
            });
            Navigator.of(context).pop();
            displayAlert(
              context,
              "Reset password",
              Text(
                "A email has been sent to you to reset your password, if you haven't received the email please restart the process",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(padding: EdgeInsets.zero),
            );
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

  Widget btnVerifyEmail() {
    return TextButton(
      onPressed: () async {
        setState(() {
          isLoading = true;
        });
        Navigator.of(context).pop();
        String? value = await businessLogic.verifyEmail();
        if (value == "success") {
          setState(() {
            isLoading = false;
          });
          displayAlert(
            context,
            "Email Verification",
            Text(
              "A verification email has been sent to your email address",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(padding: EdgeInsets.zero),
          );
        } else {
          setState(() {
            isLoading = false;
          });
          displayToastMessage("$value", "failed", context);
        }
      },
      child: Text(
        "Click here to verify your email",
        style: TextStyle(color: Colors.blue, fontSize: 10),
      ),
    );
  }

  Widget BtnLoginWithGoogle() {
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
              "Login with Google",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        onPressed: () async {
          businessLogic.loginWithGoogle().then(
            (value) {
              if (value == "login") {
                Navigator.pushNamedAndRemoveUntil(context, HomeScreen.idScreen, (route) => false);
              } else if (value == "success") {
                displayToastMessage("Sign up successful", "success", context);
                Navigator.pushNamedAndRemoveUntil(context, HomeScreen.idScreen, (route) => false);
              } else {
                displayToastMessage("$value", "failed", context);
              }
            },
          );
        },
      ),
    );
  }

  Widget BtnLoginWithFacebook() {
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
              "Login with Facebook",
              style: TextStyle(fontSize: 13, color: Colors.indigo),
            ),
          ],
        ),
        onPressed: () async {
          businessLogic.signInWithFacebook().then(
            (value) async {
              if (value == "login") {
                if (await businessLogic.emailVerified() == "yes") {
                  Navigator.pushNamedAndRemoveUntil(context, HomeScreen.idScreen, (route) => false);
                } else {
                  displayAlert(
                    context,
                    "Verify email",
                    Text(
                      "You must verify your email to login",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    btnVerifyEmail(),
                  );
                }
              } else if (value == "success") {
                displayToastMessage("Sign up successful", "success", context);
                if (await businessLogic.emailVerified() == "yes") {
                  Navigator.pushNamedAndRemoveUntil(context, HomeScreen.idScreen, (route) => false);
                } else {
                  displayAlert(
                    context,
                    "Verify email",
                    Text(
                      "You must verify your email to login",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    btnVerifyEmail(),
                  );
                }
              } else {
                displayToastMessage("$value", "failed", context);
              }
            },
          );
        },
      ),
    );
  }

  Widget btnRegister() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Doesn't has any account?",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, RegisterScreen.idScreen, (route) => false);
          },
          child: Text(
            "Register here",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
