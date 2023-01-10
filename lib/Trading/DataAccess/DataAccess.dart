import 'package:user_app/Trading/DataAccess/Databases/DatabaseInterface.dart';
import 'package:user_app/Trading/DataAccess/GetDatabase.dart';

class DataAccess {
  late IDatabase database;

  DataAccess() {
    database = getDatabase("firebase")!;
  }

  Future<String?> newTransaction(Map<String, dynamic> transaction) async {
    return database.newTransaction(transaction);
  }

  Future<String?> placeBid(String transactionId, Map<String, dynamic> bidder) async {
    return database.placeBid(transactionId, bidder);
  }

  Future<String?> viewBorrowingRequests() async {
    return database.viewBorrowingRequests();
  }

  Future<String?> viewLendingOffers() async {
    return database.viewLendingOffers();
  }

  Future<String?> viewTransactionDetails(String transactionId) async {
    return database.viewTransactionDetails(transactionId);
  }

  Future<String?> viewMyLendingOffers() async {
    return database.viewMyLendingOffers();
  }

  Future<String?> viewMyBorrowingRequests() async {
    return database.viewMyBorrowingRequests();
  }

  Future<String?> viewMyLendingBids() async {
    return database.viewMyLendingBids();
  }

  Future<String?> viewMyBorrowingBids() async {
    return database.viewMyBorrowingBids();
  }

  Future<String?> cancelTransaction(String transactionId) async {
    return database.cancelTransaction(transactionId);
  }

  Future<String?> editBid(String transactionId, num amount, num interestRate) async {
    return database.editBid(transactionId, amount, interestRate);
  }

  Future<String?> cancelBid(String transactionId) async {
    return database.cancelBid(transactionId);
  }
}
