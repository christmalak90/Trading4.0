import 'package:user_app/HelperMethodes.dart';
import 'package:user_app/Users/BusinessLogic/Models/User.dart';
import 'package:user_app/Users/DataAccess/DataAccess.dart';

class BusinessLogic {
  DataAccess dataAccess = DataAccess();

  Future<String?> getUserId() async {
    String? value;
    value = await dataAccess.getUserId();
    if (value != "" && value != null) {
      consoleDisplayMessage("User ID: $value");
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }

  Future<String?> register(User user) async {
    //Email validation
    if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(user.email)) {
      //Password validation (at least one upper case, at least one lower case, at least one digit, should contain at least one Special character, Must be at least 8 characters in length)
      if (RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$").hasMatch(user.password)) {
        if (user.firstName != "") {
          if (user.surName != "") {
            String? value = await dataAccess.registerUser(user.toJson());
            if (value == "success") {
              consoleDisplayMessage("Registration Successful");
            } else {
              consoleDisplayMessage("$value");
            }
            return value;
          } else {
            consoleDisplayMessage("Error: Please enter surname");
            return "Error: Please enter surname";
          }
        } else {
          consoleDisplayMessage("Error: Please enter first name");
          return "Error: Please enter first name";
        }
      } else {
        consoleDisplayMessage("Error: Invalid password");
        return "Error: Invalid password";
      }
    } else {
      consoleDisplayMessage("Error: Invalid email");
      return "Error: Invalid email";
    }
  }

  Future<String?> logIn(String email, String password) async {
    //Email validation
    if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      //Password validation (at least one upper case, at least one lower case, at least one digit, should contain at least one Special character, Must be at least 8 characters in length)
      if (password != "") {
        String? value;
        value = await dataAccess.logIn(email, password);
        if (value == "success") {
          consoleDisplayMessage("Login Successful");
        } else {
          consoleDisplayMessage("$value");
        }
        return value;
      } else {
        consoleDisplayMessage("Error: Please enter password");
        return "Error: Please enter password";
      }
    } else {
      consoleDisplayMessage("Error: Please enter a valid email");
      return "Error: Please enter a valid email";
    }
  }

  Future<String?> loginWithGoogle() async {
    String? value;
    value = await dataAccess.loginWithGoogle();
    if (value == "success") {
      consoleDisplayMessage("Signup Successful");
    } else if (value == "login") {
      consoleDisplayMessage("login successful");
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }

  Future<String?> signInWithFacebook() async {
    String? value;
    value = await dataAccess.signInWithFacebook();
    if (value == "success") {
      consoleDisplayMessage("Signup successful");
    } else if (value == "login") {
      consoleDisplayMessage("login successful");
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }

  Future<String?> logOut() async {
    String? value = await dataAccess.logOut();
    if (value == "success") {
      consoleDisplayMessage("Logout Successful");
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }

  Future<String?> verifyEmail() async {
    String? value = await dataAccess.verifyEmail();
    if (value == "success") {
      consoleDisplayMessage("Email verification sent");
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }

  Future<String?> editEmail(String newEmail) async {
    String? currentEmail = await dataAccess.getEmail();
    if (newEmail != currentEmail) {
      if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(newEmail)) {
        String? value = await dataAccess.editEmail(newEmail);
        if (value == "success") {
          consoleDisplayMessage("Email updated");
        } else {
          consoleDisplayMessage("$value");
        }
        return value;
      } else {
        consoleDisplayMessage("Error: Invalid email");
      }
    } else {
      consoleDisplayMessage("Error: Enter different email from your current email");
    }
  }

  Future<String?> editFullName(String newFullName) async {
    if (newFullName != "") {
      String? value = await dataAccess.editFullName(newFullName);
      if (value == "success") {
        consoleDisplayMessage("Full name updated");
      } else {
        consoleDisplayMessage("$value");
      }
      return value;
    } else {
      consoleDisplayMessage("Error: Invalid full name");
    }
  }

  Future<String?> editPassword(String newPassword) async {
    if (RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$").hasMatch(newPassword)) {
      String? value = await dataAccess.editPassword(newPassword);
      if (value == "success") {
        consoleDisplayMessage("Password updated");
      } else {
        consoleDisplayMessage("$value");
      }
      return value;
    } else {
      consoleDisplayMessage("Error: Invalid password");
    }
  }

  Future<String?> retrievePassword(String email) async {
    String? value = await dataAccess.retrievePassword(email);
    if (value == "success") {
      consoleDisplayMessage("Password reset email sent");
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }

  Future<String?> emailVerified() async {
    String? value = await dataAccess.emailVerified();
    if (value == "yes") {
      consoleDisplayMessage("Email is verified");
    } else if (value == "no") {
      consoleDisplayMessage("Email not verified");
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }

  Future<String?> phoneVerified() async {
    String? value = await dataAccess.phoneVerified();
    if (value == "yes") {
      consoleDisplayMessage("Phone is verified");
    } else if (value == "no") {
      consoleDisplayMessage("Phone not verified");
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }

  Future<void> verifyPhone(dynamic context, String phone) async {
    await dataAccess.verifyPhone(context, phone);
  }

  Future<String?> submitOTP(String smsCode) async {
    String? value = await dataAccess.submitOTP(smsCode);
    if (value == "success") {
      consoleDisplayMessage("Phone verified");
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }

  Future<String?> getDisplayName() async {
    String? value;
    value = await dataAccess.getDisplayName();
    if (value != "" && value != null) {
      consoleDisplayMessage("Display name: $value");
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }

  Future<String?> getPhoneNumber() async {
    String? value;
    value = await dataAccess.getPhoneNumber();
    if (value != "") {
      consoleDisplayMessage("Phone Number: $value");
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }

  Future<String?> getEmail() async {
    String? value;
    value = await dataAccess.getEmail();
    if (value != "" && value != null) {
      consoleDisplayMessage("Email Address: $value");
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }

  Future<String?> getUserDetails(String userId) async {
    String? value;
    value = await dataAccess.getUserDetails(userId);
    if (value != "" && value != null) {
      consoleDisplayMessage("User details: $value");
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }

  Future<String?> editAddress(String newAddress) async {
    if (newAddress != "") {
      String? value = await dataAccess.editAddress(newAddress);
      if (value == "success") {
        consoleDisplayMessage("Address updated");
      } else {
        consoleDisplayMessage("$value");
      }
      return value;
    } else {
      consoleDisplayMessage("Error: Invalid Address");
    }
  }

  Future<String?> editDateOfBirth(DateTime newDateOfBirth) async {
    String? value = await dataAccess.editDateOfBirth(newDateOfBirth);
    if (value == "success") {
      consoleDisplayMessage("Date of birth updated");
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }

  Future<String?> editIncome(num newIncome) async {
    String? value = await dataAccess.editIncome(newIncome);
    if (value == "success") {
      consoleDisplayMessage("Income updated");
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }

  Future<String?> editOccupation(String newOccupation) async {
    if (newOccupation != "") {
      String? value = await dataAccess.editOccupation(newOccupation);
      if (value == "success") {
        consoleDisplayMessage("Occupation updated");
      } else {
        consoleDisplayMessage("$value");
      }
      return value;
    } else {
      consoleDisplayMessage("Error: Invalid occupation");
    }
  }

  Future<String?> editHousehold(int newHousehold) async {
    String? value = await dataAccess.editHousehold(newHousehold);
    if (value == "success") {
      consoleDisplayMessage("Household updated");
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }

  Future<String?> editEducation(String newEducation) async {
    if (newEducation != "") {
      String? value = await dataAccess.editEducation(newEducation);
      if (value == "success") {
        consoleDisplayMessage("Education updated");
      } else {
        consoleDisplayMessage("$value");
      }
      return value;
    } else {
      consoleDisplayMessage("Error: Invalid education");
    }
  }

  Future<String?> editRent(num newRent) async {
    String? value = await dataAccess.editRent(newRent);
    if (value == "success") {
      consoleDisplayMessage("Rent updated");
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }

  Future<String?> profileCompleted() async {
    String? value = await dataAccess.profileCompleted();
    if (value == "yes") {
      consoleDisplayMessage("Profile completed");
    } else if (value == "no") {
      consoleDisplayMessage("Profile not completed");
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }
}
