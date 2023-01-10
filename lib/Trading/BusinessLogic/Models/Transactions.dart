import 'package:enum_to_string/enum_to_string.dart';
import 'package:user_app/Trading/BusinessLogic/Models/Bidder.dart';
import 'package:user_app/Trading/BusinessLogic/Models/TransactionStatusEnum.dart';
import 'package:user_app/Trading/BusinessLogic/Models/TransactionTypeEnum.dart';

class Transactions {
  late String transactionId;
  late String userId;
  late TransactionType transactionType; //Lending offer or borrowing request
  late num amount;
  late num interestRate;
  late int duration; //The duration in which the loan must be reimbursed
  late DateTime publishedDate;
  late DateTime dueDate; //The date on which the offer/request expires
  late TransactionStatus transactionStatus;
  late List<Bidder> bidders;

  Transactions({
    required this.transactionId,
    required this.userId,
    required this.transactionType,
    required this.amount,
    required this.interestRate,
    required this.duration,
    required this.publishedDate,
    required this.dueDate,
    required this.transactionStatus,
    required this.bidders,
  });

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> bidders = [];

    this.bidders.forEach((bidder) {
      bidders.add(bidder.toJson());
    });

    return {
      "transactionId": this.transactionId,
      "userId": this.userId,
      "publishedDate": this.publishedDate,
      "dueDate": this.dueDate,
      "transactionType": EnumToString.convertToString(this.transactionType, camelCase: true),
      "amount": this.amount,
      "interestRate": this.interestRate,
      "duration": this.duration,
      "transactionStatus": EnumToString.convertToString(this.transactionStatus),
      "bidders": bidders,
    };
  }

  factory Transactions.fromJson(Map<String, dynamic> json) {
    List<Bidder> bidders = [];

    json["bidders"].forEach((bidder) {
      bidders.add(Bidder.fromJson(bidder));
    });

    return Transactions(
      transactionId: json["transactionId"],
      userId: json["userId"],
      publishedDate: DateTime.parse(json["publishedDate"]),
      dueDate: DateTime.parse(json["dueDate"]),
      transactionType: EnumToString.fromString(TransactionType.values, json["transactionType"], camelCase: true)!,
      amount: json["amount"],
      interestRate: json["interestRate"],
      duration: json["duration"],
      transactionStatus: EnumToString.fromString(TransactionStatus.values, json["transactionStatus"])!,
      bidders: bidders,
    );
  }
}
