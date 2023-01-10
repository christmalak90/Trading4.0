enum TransactionStatus {
  onGoing, //the offer or request is ON
  expired, //the offer or request has expired and the matching algorithm is executed
  cancelled, //the offer or request is cancelled
  closed, //the matching algorithm is successfully executed on the lending offer or borrowing request and lender(s) or borrower(s) are selected
}
