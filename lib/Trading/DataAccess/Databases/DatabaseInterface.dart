abstract class IDatabase {
  //Publish lending offer or borrowing request
  Future<String?> newTransaction(Map<String, dynamic> transaction);

  Future<String?> viewLendingOffers();

  Future<String?> viewBorrowingRequests();

  Future<String?> viewTransactionDetails(String transactionId);

  Future<String?> placeBid(String transactionId, Map<String, dynamic> bid);

  //View the offers that you published
  Future<String?> viewMyLendingOffers();

  //View the requests that you published
  Future<String?> viewMyBorrowingRequests();

  //View the lending bids that you placed
  Future<String?> viewMyLendingBids();

  //View the borrowing bids that you placed
  Future<String?> viewMyBorrowingBids();

  //Cancel lending offer or borrowing request
  Future<String?> cancelTransaction(String transactionId);

  Future<String?> editBid(String transactionId, num amount, num interestRate);

  Future<String?> cancelBid(String transactionId);
}
