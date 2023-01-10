import 'package:user_app/HelperMethodes.dart';
import 'package:user_app/Trading/BusinessLogic/Models/Bidder.dart';
import 'package:user_app/Trading/BusinessLogic/Models/Transactions.dart';
import 'package:user_app/Trading/BusinessLogic/Models/TransactionTypeEnum.dart';
import 'package:user_app/Trading/DataAccess/DataAccess.dart';

class BusinessLogic {
  DataAccess dataAccess = DataAccess();

  Future<String?> newTransaction(Transactions transaction) async {
    String? value = await dataAccess.newTransaction(transaction.toJson());
    if (value == "success") {
      if (transaction.transactionType == TransactionType.LendingOffer) {
        consoleDisplayMessage("Lending offer successfully published");
      }
      if (transaction.transactionType == TransactionType.BorrowingRequest) {
        consoleDisplayMessage("Borrowing request successfully published");
      }
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }

  Future<String?> placeBid(String transactionId, Bidder bidder) async {
    String? value = await dataAccess.placeBid(transactionId, bidder.toJson());
    if (value == "success") {
      consoleDisplayMessage("Bid successfully placed");
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }

  Future<String?> viewBorrowingRequests() async {
    String? value;
    value = await dataAccess.viewBorrowingRequests();
    if (value != "" && value != null) {
      consoleDisplayMessage("Borrowing requests: $value");
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }

  Future<String?> viewLendingOffers() async {
    String? value;
    value = await dataAccess.viewLendingOffers();
    if (value != "" && value != null) {
      consoleDisplayMessage("Lending offers: $value");
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }

  Future<String?> viewTransactionDetails(String transactionId) async {
    String? value;
    value = await dataAccess.viewTransactionDetails(transactionId);
    if (value != "" && value != null) {
      consoleDisplayMessage("Borrowing request details: $value");
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }

  Future<String?> viewMyLendingOffers() async {
    String? value;
    value = await dataAccess.viewMyLendingOffers();
    if (value != "" && value != null) {
      consoleDisplayMessage("My lending offers: $value");
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }

  Future<String?> viewMyBorrowingRequests() async {
    String? value;
    value = await dataAccess.viewMyBorrowingRequests();
    if (value != "" && value != null) {
      consoleDisplayMessage("My borrowing requests: $value");
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }

  Future<String?> viewMyLendingBids() async {
    String? value;
    value = await dataAccess.viewMyLendingBids();
    if (value != "" && value != null) {
      consoleDisplayMessage("Borrowing requests: $value");
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }

  Future<String?> viewMyBorrowingBids() async {
    String? value;
    value = await dataAccess.viewMyBorrowingBids();
    if (value != "" && value != null) {
      consoleDisplayMessage("Lending Offers: $value");
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }

  Future<String?> cancelTransaction(String transactionId) async {
    String? value = await dataAccess.cancelTransaction(transactionId);
    if (value == "success") {
      consoleDisplayMessage("Transaction cancelled");
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }

  Future<String?> editBid(String transactionId, num amount, num interestRate) async {
    String? value = await dataAccess.editBid(transactionId, amount, interestRate);
    if (value == "success") {
      consoleDisplayMessage("Bid edited");
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }

  Future<String?> cancelBid(String transactionId) async {
    String? value = await dataAccess.cancelBid(transactionId);
    if (value == "success") {
      consoleDisplayMessage("Bid cancelled");
    } else {
      consoleDisplayMessage("$value");
    }
    return value;
  }
}
