import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:user_app/Trading/UserInterface/Activity.dart';
import 'package:user_app/Trading/UserInterface/BorrowingRequestDetails.dart';
import 'package:user_app/Trading/UserInterface/BorrowingRequests.dart';
import 'package:user_app/Trading/UserInterface/Home.dart';
import 'package:user_app/Trading/UserInterface/LendingOfferDetails.dart';
import 'package:user_app/Trading/UserInterface/LendingOffers.dart';
import 'package:user_app/Trading/UserInterface/MyBorrowingBids.dart';
import 'package:user_app/Trading/UserInterface/MyBorrowingRequests.dart';
import 'package:user_app/Trading/UserInterface/MyLendingBids.dart';
import 'package:user_app/Trading/UserInterface/MyLendingOffers.dart';
import 'package:user_app/Users/UserInterface/Login.dart';
import 'package:user_app/Users/UserInterface/Profile.dart';
import 'package:user_app/Users/UserInterface/Register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser!.emailVerified) ? HomeScreen.idScreen : LoginScreen.idScreen,
      routes: {
        RegisterScreen.idScreen: (context) => RegisterScreen(),
        LoginScreen.idScreen: (context) => LoginScreen(),
        HomeScreen.idScreen: (context) => HomeScreen(),
        ProfileScreen.idScreen: (context) => ProfileScreen(),
        ActivityScreen.idScreen: (context) => ActivityScreen(),
        LendingOffers.idScreen: (context) => LendingOffers(),
        MyLendingOffers.idScreen: (context) => MyLendingOffers(),
        BorrowingRequests.idScreen: (context) => BorrowingRequests(),
        MyBorrowingRequests.idScreen: (context) => MyBorrowingRequests(),
        MyLendingBids.idScreen: (context) => MyLendingBids(),
        MyBorrowingBids.idScreen: (context) => MyBorrowingBids(),
        },
    );
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Firebase Phone Auth Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//
//       initialRoute: FirebaseAuth.instance.currentUser == null ? LoginScreen.idScreen : MyHomePage.idScreen,
//          routes: {
//            RegisterScreen.idScreen: (context) => RegisterScreen(),
//            LoginScreen.idScreen: (context) => LoginScreen(),
//            MainScreen.idScreen: (context) => MainScreen(),
//            MyHomePage.idScreen: (context) => MyHomePage(key: null, title: '',),
//          }
//       // home: MyHomePage(
//       //   title: 'Phone Authentication',
//       //   key: null,
//       // ),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({required Key? key, required this.title}) : super(key: key);
//   static const String idScreen = "main";
//
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   TextEditingController _phoneNumberController = TextEditingController();
//   TextEditingController _otpController = TextEditingController();
//
//   late User? _firebaseUser;
//   late String _status;
//
//   late PhoneAuthCredential _phoneAuthCredential;
//   late String _verificationId;
//   late int _code;
//
//   @override
//   void initState() {
//     super.initState();
//     _getFirebaseUser();
//   }
//
//   void _handleError(e) {
//     print(e.message);
//     setState(() {
//       _status += e.message + '\n';
//     });
//   }
//
//   Future<void> _getFirebaseUser() async {
//     this._firebaseUser = FirebaseAuth.instance.currentUser;
//     setState(() {
//       _status = (_firebaseUser == null) ? 'Not Logged In\n' : 'Already LoggedIn\n';
//     });
//   }
//
//   /// phoneAuthentication works this way:
//   ///     AuthCredential is the only thing that is used to authenticate the user
//   ///     OTP is only used to get AuthCrendential after which we need to authenticate with that AuthCredential
//   ///
//   /// 1. User gives the phoneNumber
//   /// 2. Firebase sends OTP if no errors occur
//   /// 3. If the phoneNumber is not in the device running the app
//   ///       We have to first ask the OTP and get `AuthCredential`(`_phoneAuthCredential`)
//   ///       Next we can use that `AuthCredential` to signIn
//   ///    Else if user provided SIM phoneNumber is in the device running the app,
//   ///       We can signIn without the OTP.
//   ///       because the `verificationCompleted` callback gives the `AuthCredential`(`_phoneAuthCredential`) needed to signIn
//   Future<void> _login() async {
//     /// This method is used to login the user
//     /// `AuthCredential`(`_phoneAuthCredential`) is needed for the signIn method
//     /// After the signIn method from `AuthResult` we can get `FirebaserUser`(`_firebaseUser`)
//     // try {
//     //   await FirebaseAuth.instance
//     //       .signInWithCredential(this._phoneAuthCredential)
//     //       .then((AuthResult authRes) {
//     //     _firebaseUser = authRes.user;
//     //     print(_firebaseUser.toString());
//     //   }).catchError((e) => _handleError(e));
//     //   setState(() {
//     //     _status += 'Signed In\n';
//     //   });
//     // } catch (e) {
//     //   _handleError(e);
//     // }
//   }
//
//   Future<void> _logout() async {
//     /// Method to Logout the `FirebaseUser` (`_firebaseUser`)
//     try {
//       // signout code
//       await FirebaseAuth.instance.signOut();
//       _firebaseUser = null;
//       setState(() {
//         _status += 'Signed out\n';
//       });
//     } catch (e) {
//       _handleError(e);
//     }
//   }
//
//   Future<void> _submitPhoneNumber() async {
//     /// NOTE: Either append your phone number country code or add in the code itself
//     /// Since I'm in India we use "+91 " as prefix `phoneNumber`
//     String phoneNumber = "+27 " + _phoneNumberController.text.toString().trim();
//     //print(phoneNumber);
//
//     /// The below functions are the callbacks, separated so as to make code more redable
//     void verificationCompleted(PhoneAuthCredential phoneAuthCredential) {
//       //print('verificationCompleted');
//       this._firebaseUser!.updatePhoneNumber(phoneAuthCredential);
//       setState(() {
//         _status += 'verificationCompleted\n';
//       });
//       this._phoneAuthCredential = phoneAuthCredential;
//       //print("PhoneAuthCredential: $phoneAuthCredential");
//     }
//
//     void verificationFailed(FirebaseAuthException error) {
//       print('verificationFailed');
//       _handleError(error);
//     }
//
//     void codeSent(String verificationId, [int? code]) {
//       print('codeSent');
//       this._verificationId = verificationId;
//       print(verificationId);
//       this._code = code!;
//       print(code.toString());
//       setState(() {
//         _status += 'Code Sent\n';
//       });
//     }
//
//     void codeAutoRetrievalTimeout(String verificationId) {
//       print('codeAutoRetrievalTimeout');
//       setState(() {
//         _status += 'codeAutoRetrievalTimeout\n';
//       });
//       print(verificationId);
//     }
//
//     await FirebaseAuth.instance.verifyPhoneNumber(
//       /// Make sure to prefix with your country code
//       phoneNumber: phoneNumber,
//
//       /// `seconds` didn't work. The underlying implementation code only reads in `millisenconds`
//       timeout: Duration(milliseconds: 10000),
//
//       /// If the SIM (with phoneNumber) is in the current device this function is called.
//       /// This function gives `AuthCredential`. Moreover `login` function can be called from this callback
//       /// When this function is called there is no need to enter the OTP, you can click on Login button to sigin directly as the device is now verified
//       verificationCompleted: verificationCompleted,
//
//       /// Called when the verification is failed
//       verificationFailed: verificationFailed,
//
//       /// This is called after the OTP is sent. Gives a `verificationId` and `code`
//       codeSent: codeSent,
//
//       /// After automatic code retrival `tmeout` this function is called
//       codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
//     ); // All the callbacks are above
//   }
//
//   void _submitOTP() {
//     /// get the `smsCode` from the user
//     String smsCode = _otpController.text.toString().trim();
//
//     /// when used different phoneNumber other than the current (running) device
//     /// we need to use OTP to get `phoneAuthCredential` which is inturn used to signIn/login
//     this._phoneAuthCredential = PhoneAuthProvider.credential(verificationId: this._verificationId, smsCode: smsCode);
//     this._firebaseUser!.updatePhoneNumber(this._phoneAuthCredential);
//     //_login();
//   }
//
//   void _reset() {
//     _phoneNumberController.clear();
//     _otpController.clear();
//     setState(() {
//       _status = "";
//     });
//   }
//
//   void _displayUser() {
//     setState(() {
//       _status += _firebaseUser.toString() + '\n';
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         actions: [
//           GestureDetector(
//             child: Icon(Icons.refresh),
//             onTap: _reset,
//           ),
//         ],
//       ),
//       body: ListView(
//         padding: EdgeInsets.all(16),
//         // mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           SizedBox(height: 24),
//           Row(
//             children: <Widget>[
//               Expanded(
//                 flex: 2,
//                 child: TextField(
//                   controller: _phoneNumberController,
//                   decoration: InputDecoration(
//                     hintText: 'Phone Number',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//               ),
//               Spacer(),
//               Expanded(
//                 flex: 1,
//                 child: MaterialButton(
//                   onPressed: _submitPhoneNumber,
//                   child: Text('Submit'),
//                   color: Theme.of(context).accentColor,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 48),
//           Row(
//             children: <Widget>[
//               Expanded(
//                 flex: 2,
//                 child: TextField(
//                   controller: _otpController,
//                   decoration: InputDecoration(
//                     hintText: 'OTP',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//               ),
//               Spacer(),
//               Expanded(
//                 flex: 1,
//                 child: MaterialButton(
//                   onPressed: _submitOTP,
//                   child: Text('Submit'),
//                   color: Theme.of(context).accentColor,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 48),
//           Text('$_status'),
//           SizedBox(height: 48),
//           MaterialButton(
//             onPressed: _login,
//             child: Text('Login'),
//             color: Theme.of(context).accentColor,
//           ),
//           SizedBox(height: 24),
//           MaterialButton(
//             onPressed: _logout,
//             child: Text('Logout'),
//             color: Theme.of(context).accentColor,
//           ),
//           SizedBox(height: 24),
//           MaterialButton(
//             onPressed: _displayUser,
//             child: Text('FirebaseUser'),
//             color: Theme.of(context).accentColor,
//           )
//         ],
//       ),
//     );
//   }
// }
