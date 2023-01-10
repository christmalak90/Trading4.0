import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:user_app/Users/DataAccess/Databases/DatabaseInterface.dart';

class FirebaseDatabase implements IDatabase {
  //Used in phone verification
  late String _verificationId;

  //Used in phone verification
  late PhoneAuthCredential _phoneAuthCredential;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String?> getUserId() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser!.uid;
      return userId;
    } catch (e) {
      return handleError(e);
    }
  }

  Future<String?> register(Map<String, dynamic> user) async {
    try {
      UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: user["email"], password: user["password"]);
      credential.user!.updateDisplayName("${user["firstName"]} ${user["surName"]}");

      //Create new document for the user in the userDetails collection in the database
      Map<String, dynamic> userDetails = {
        "userId": credential.user!.uid,
        "address": null,
        "dateOfBirth": null,
        "income": null,
        "occupation": null,
        "household": null,
        "education": null,
        "rent": null,
      };

      CollectionReference collection = firestore.collection('userDetails');
      collection.doc(credential.user!.uid).set(userDetails);

      //Create a new document in the transactions_bids collection
      //this document includes all the transactions where the user has placed bids
      //that will help us locate those transactions directly when needed instead of checking all the transactions one by one to check if the user has placed a bid on that transaction
      CollectionReference collection2 = firestore.collection('transactions_bids');
      collection2.doc(FirebaseAuth.instance.currentUser!.uid).set({
        "userId": FirebaseAuth.instance.currentUser!.uid,
        "transactions": [] //List of transactions where the user has placed bids
      });

      return "success";
    } catch (e) {
      return handleError(e);
    }
  }

  Future<String?> logIn(String email, String password) async {
    try {
      UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return "success";
    } catch (e) {
      return handleError(e);
    }
  }

  Future<String?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(authCredential);
      if (authResult.additionalUserInfo!.isNewUser) {
        //Create new document for the user in the userDetails collection in the database
        Map<String, dynamic> userDetails = {
          "userId": authResult.user!.uid,
          "address": null,
          "dateOfBirth": null,
          "income": null,
          "occupation": null,
          "household": null,
          "education": null,
          "rent": null,
        };

        CollectionReference collection = firestore.collection('userDetails');
        collection.doc(authResult.user!.uid).set(userDetails);

        //Create a new document in the transactions_bids collection
        //this document includes all the transactions where the user has placed bids
        //that will help us locate those transactions directly when needed instead of checking all the transactions one by one to check if the user has placed a bid on that transaction
        CollectionReference collection2 = firestore.collection('transactions_bids');
        collection2.doc(FirebaseAuth.instance.currentUser!.uid).set({
          "userId": FirebaseAuth.instance.currentUser!.uid,
          "transactions": [] //List of transactions where the user has placed bids
        });

        final User? user = authResult.user;
        if (user != null) {
          //return '$user';
          return 'success';
        }
      } else {
        return "login";
      }
    } catch (e) {
      return handleError(e);
    }
  }

  Future<String?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      switch (result.status) {
        case LoginStatus.success:
          final AuthCredential facebookCredential = FacebookAuthProvider.credential(result.accessToken!.token);
          final userCredential = await FirebaseAuth.instance.signInWithCredential(facebookCredential);
          if (userCredential.additionalUserInfo!.isNewUser) {
            //Create new document for the user in the userDetails collection in the database
            Map<String, dynamic> userDetails = {
              "userId": userCredential.user!.uid,
              "address": null,
              "dateOfBirth": null,
              "income": null,
              "occupation": null,
              "household": null,
              "education": null,
              "rent": null,
            };

            CollectionReference collection = firestore.collection('userDetails');
            collection.doc(userCredential.user!.uid).set(userDetails);

            //Create a new document in the transactions_bids collection
            //this document includes all the transactions where the user has placed bids
            //that will help us locate those transactions directly when needed instead of checking all the transactions one by one to check if the user has placed a bid on that transaction
            CollectionReference collection2 = firestore.collection('transactions_bids');
            collection2.doc(FirebaseAuth.instance.currentUser!.uid).set({
              "userId": FirebaseAuth.instance.currentUser!.uid,
              "transactions": [] //List of transactions where the user has placed bids
            });

            final User? user = userCredential.user;
            if (user != null) {
              //return '$user';
              return 'success';
            }
          }
          return "login";
        case LoginStatus.cancelled:
          return result.message;
        case LoginStatus.failed:
          return result.message;
        default:
          return null;
      }
    } catch (e) {
      return handleError(e);
    }
  }

  Future<String?> logOut() async {
    try {
      await FacebookAuth.instance.logOut();
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
      return "success";
    } catch (e) {
      return handleError(e);
    }
  }

  Future<String?> verifyEmail() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      return "success";
    } catch (e) {
      return handleError(e);
    }
  }

  Future<String?> editEmail(String newEmail) async {
    try {
      await FirebaseAuth.instance.currentUser!.updateEmail(newEmail);
      return "success";
    } catch (e) {
      return handleError(e);
    }
  }

  Future<String?> editFullName(String newFullName) async {
    try {
      await FirebaseAuth.instance.currentUser!.updateDisplayName(newFullName);
      return "success";
    } catch (e) {
      return handleError(e);
    }
  }

  Future<String?> editPassword(String newPassword) async {
    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
      return "success";
    } catch (e) {
      return handleError(e);
    }
  }

  Future<String?> retrievePassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return "success";
    } catch (e) {
      return handleError(e);
    }
  }

  Future<String?> emailVerified() async {
    try {
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        return "yes";
      }
      return "no";
    } catch (e) {
      return handleError(e);
    }
  }

  Future<String?> submitOTP(String smsCode) async {
    /// when used different phoneNumber other than the current (running) device
    /// we need to use OTP to get `phoneAuthCredential`
    try {
      this._phoneAuthCredential = PhoneAuthProvider.credential(verificationId: this._verificationId, smsCode: smsCode);
      await FirebaseAuth.instance.currentUser!.updatePhoneNumber(this._phoneAuthCredential);
      return "success";
    } catch (e) {
      return handleError(e);
    }
  }

  Future<void> verifyPhone(dynamic context, String phone) async {
    String phoneNumber = "+27 " + phone;

    /// The below functions are the callbacks, separated so as to make code more readable
    void verificationCompleted(PhoneAuthCredential phoneAuthCredential) {
      FirebaseAuth.instance.currentUser!.updatePhoneNumber(phoneAuthCredential);
      print("Phone Verification completed");
      //displayToastMessage("Phone verification completed", "success", context);
      Navigator.of(context).pop();
    }

    void verificationFailed(FirebaseAuthException error) {
      print("Error ${error.message}");
      //displayToastMessage("Error ${error.message}", "failed", context);
      Navigator.of(context).pop();
    }

    void codeSent(String verificationId, [int? code]) {
      this._verificationId = verificationId;
      print("Phone verification code sent");
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      print('Phone verification timeout');
      //displayToastMessage("Verification timeout, try again", "failed", context);
      Navigator.of(context).pop();
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,

      /// `seconds` didn't work. The underlying implementation code only reads in `millisenconds`
      timeout: Duration(milliseconds: 50000),

      /// If the SIM (with phoneNumber) is in the current device this function is called.
      /// This function gives `AuthCredential`. Moreover `login` function can be called from this callback
      /// When this function is called there is no need to enter the OTP, you can click on Login button to sigin directly as the device is now verified
      verificationCompleted: verificationCompleted,

      /// Called when the verification is failed
      verificationFailed: verificationFailed,

      /// This is called after the OTP is sent. Gives a `verificationId` and `code`
      codeSent: codeSent,

      /// After automatic code retrival `tmeout` this function is called
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    ); // All the callbacks are above
  }

  Future<String?> phoneVerified() async {
    try {
      if (FirebaseAuth.instance.currentUser!.phoneNumber != null && FirebaseAuth.instance.currentUser!.phoneNumber != "") {
        return "yes";
      }
      return "no";
    } catch (e) {
      return handleError(e);
    }
  }

  Future<String?> getDisplayName() async {
    try {
      String? name = FirebaseAuth.instance.currentUser!.displayName;
      return name;
    } catch (e) {
      return null;
    }
  }

  Future<String?> getPhoneNumber() async {
    try {
      String? phone = FirebaseAuth.instance.currentUser!.phoneNumber;
      return phone;
    } catch (e) {
      return null;
    }
  }

  Future<String?> getEmail() async {
    try {
      String? email = FirebaseAuth.instance.currentUser!.email;
      return email;
    } catch (e) {
      return null;
    }
  }

  Future<String?> getUserDetails(String userId) async {
    try {
      CollectionReference collection = firestore.collection('userDetails');
      QuerySnapshot snapshot = await collection.get();
      QueryDocumentSnapshot document = snapshot.docs.singleWhere((element) => element.id == userId);

      if (document.exists) {
        String? address = document.get('address');
        DateTime? dateOfBirth = (document.get('dateOfBirth') == null) ? document.get('dateOfBirth') : document.get('dateOfBirth').toDate();
        String? education = document.get('education');
        int? household = document.get('household');
        num? income = document.get('income');
        String? occupation = document.get('occupation');
        num? rent = document.get('rent');

        Map<String, dynamic> userDetails = {
          "userId": userId,
          "address": address,
          "dateOfBirth": (dateOfBirth == null) ? dateOfBirth : dateOfBirth!.toIso8601String(),
          "income": income,
          "occupation": occupation,
          "household": household,
          "education": education,
          "rent": rent,
        };
        return jsonEncode(userDetails);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String?> editAddress(String newAddress) async {
    try {
      CollectionReference collection = firestore.collection('userDetails');
      await collection.doc(FirebaseAuth.instance.currentUser!.uid).update({'address': newAddress});
      return "success";
    } catch (e) {
      return handleError(e);
    }
  }

  Future<String?> editDateOfBirth(DateTime newDateOfBirth) async {
    try {
      CollectionReference collection = firestore.collection('userDetails');
      await collection.doc(FirebaseAuth.instance.currentUser!.uid).update({'dateOfBirth': newDateOfBirth});
      return "success";
    } catch (e) {
      return handleError(e);
    }
  }

  Future<String?> editIncome(num newIncome) async {
    try {
      CollectionReference collection = firestore.collection('userDetails');
      await collection.doc(FirebaseAuth.instance.currentUser!.uid).update({'income': newIncome});
      return "success";
    } catch (e) {
      return handleError(e);
    }
  }

  Future<String?> editOccupation(String newOccupation) async {
    try {
      CollectionReference collection = firestore.collection('userDetails');
      await collection.doc(FirebaseAuth.instance.currentUser!.uid).update({'occupation': newOccupation});
      return "success";
    } catch (e) {
      return handleError(e);
    }
  }

  Future<String?> editHousehold(int newHousehold) async {
    try {
      CollectionReference collection = firestore.collection('userDetails');
      await collection.doc(FirebaseAuth.instance.currentUser!.uid).update({'household': newHousehold});
      return "success";
    } catch (e) {
      return handleError(e);
    }
  }

  Future<String?> editEducation(String newEducation) async {
    try {
      CollectionReference collection = firestore.collection('userDetails');
      await collection.doc(FirebaseAuth.instance.currentUser!.uid).update({'education': newEducation});
      return "success";
    } catch (e) {
      return handleError(e);
    }
  }

  Future<String?> editRent(num newRent) async {
    try {
      CollectionReference collection = firestore.collection('userDetails');
      await collection.doc(FirebaseAuth.instance.currentUser!.uid).update({'rent': newRent});
      return "success";
    } catch (e) {
      return handleError(e);
    }
  }

  Future<String?> profileCompleted() async {
    String? phoneNumber;
    Map<String, dynamic>? userDetails;
    try {
      await getPhoneNumber().then((String? value) {
        phoneNumber = value;
      });

      await getUserDetails(FirebaseAuth.instance.currentUser!.uid).then((String? value) {
        if (value == null) {
        } else {
          userDetails = jsonDecode(value);
        }
      });
      if (!FirebaseAuth.instance.currentUser!.emailVerified ||
          phoneNumber == null ||
          phoneNumber == "null" ||
          phoneNumber == "" ||
          userDetails!["address"] == null ||
          userDetails!["address"] == "null" ||
          userDetails!["address"] == "" ||
          userDetails!["dateOfBirth"] == null ||
          userDetails!["dateOfBirth"] == "" ||
          userDetails!["income"] == null ||
          userDetails!["income"] == "" ||
          userDetails!["occupation"] == null ||
          userDetails!["occupation"] == "null" ||
          userDetails!["occupation"] == "" ||
          userDetails!["household"] == null ||
          userDetails!["household"] == "" ||
          userDetails!["education"] == null ||
          userDetails!["education"] == "null" ||
          userDetails!["education"] == "" ||
          userDetails!["rent"] == null ||
          userDetails!["rent"] == "") {
        return "no";
      }
      return "yes";
    } catch (e) {
      return handleError(e);
    }
  }

  String handleError(e) {
    return "Error: ${e.message}";
  }
}
