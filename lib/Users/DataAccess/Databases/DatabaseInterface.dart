
abstract class IDatabase {
  Future<String?> getUserId();

  Future<String?> register(Map<String, dynamic> user);

  Future<String?> logIn(String email, String password);

  Future<String?> loginWithGoogle();

  Future<String?> signInWithFacebook();

  Future<String?> logOut();

  Future<String?> verifyEmail();

  Future<String?> editEmail(String newEmail);

  Future<String?> editFullName(String newFullName);

  Future<String?> editPassword(String newPassword);

  Future<String?> retrievePassword(String email);

  Future<String?> emailVerified();

  Future<void> verifyPhone(dynamic context, String phone);

  Future<String?> submitOTP(String smsCode);

  Future<String?> phoneVerified();

  Future<String?> getDisplayName();

  Future<String?> getPhoneNumber();

  Future<String?> getEmail();

  Future<String?> getUserDetails(String userId);

  Future<String?> editAddress(String newAddress);

  Future<String?> editDateOfBirth(DateTime newDateOfBirth);

  Future<String?> editIncome(num newIncome);

  Future<String?> editOccupation(String newOccupation);

  Future<String?> editHousehold(int newHousehold);

  Future<String?> editEducation(String newEducation);

  Future<String?> editRent(num newRent);

  Future<String?> profileCompleted();
}
