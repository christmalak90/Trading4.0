import 'package:user_app/Users/DataAccess/Databases/DatabaseInterface.dart';
import 'package:user_app/Users/DataAccess/GetDatabase.dart';

class DataAccess {
  late IDatabase database;

  DataAccess() {
    database = getDatabase("firebase")!;
  }

  Future<String?> getUserId() async {
    return database.getUserId();
  }

  Future<String?> registerUser(Map<String, dynamic> user) async {
    return database.register(user);
  }

  Future<String?> logIn(String email, String password) async {
    return database.logIn(email, password);
  }

  Future<String?> loginWithGoogle() async {
    return database.loginWithGoogle();
  }

  Future<String?> signInWithFacebook() async {
    return database.signInWithFacebook();
  }

  Future<String?> logOut() async {
    return database.logOut();
  }

  Future<String?> verifyEmail() async {
    return database.verifyEmail();
  }

  Future<String?> emailVerified() async {
    return database.emailVerified();
  }

  Future<String?> editEmail(String newEmail) async {
    return database.editEmail(newEmail);
  }

  Future<String?> editFullName(String newFullName) async {
    return database.editFullName(newFullName);
  }

  Future<String?> editPassword(String newPassword) async {
    return database.editPassword(newPassword);
  }

  Future<String?> retrievePassword(String email) async {
    return database.retrievePassword(email);
  }

  Future<String?> phoneVerified() async {
    return database.phoneVerified();
  }

  Future<void> verifyPhone(dynamic context, String phone) async {
    database.verifyPhone(context, phone);
  }

  Future<String?> submitOTP(String smsCode) async {
    return database.submitOTP(smsCode);
  }

  Future<String?> getDisplayName() async {
    return database.getDisplayName();
  }

  Future<String?> getPhoneNumber() async {
    return database.getPhoneNumber();
  }

  Future<String?> getEmail() async {
    return database.getEmail();
  }

  Future<String?> getUserDetails(String userId) async {
    return database.getUserDetails(userId);
  }

  Future<String?> editAddress(String newAddress) async {
    return database.editAddress(newAddress);
  }

  Future<String?> editDateOfBirth(DateTime newDateOfBirth) async {
    return database.editDateOfBirth(newDateOfBirth);
  }

  Future<String?> editIncome(num newIncome) async {
    return database.editIncome(newIncome);
  }

  Future<String?> editOccupation(String newOccupation) async {
    return database.editOccupation(newOccupation);
  }

  Future<String?> editHousehold(int newHousehold) async {
    return database.editHousehold(newHousehold);
  }

  Future<String?> editEducation(String newEducation) async {
    return database.editEducation(newEducation);
  }

  Future<String?> editRent(num newRent) async {
    return database.editRent(newRent);
  }

  Future<String?> profileCompleted() async {
    return database.profileCompleted();
  }
}
