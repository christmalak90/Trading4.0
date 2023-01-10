import 'package:enum_to_string/enum_to_string.dart';
import 'package:user_app/Trading/BusinessLogic/Models/BidStatusEnum.dart';

class Bidder {
  late String userId;
  late num amount;
  late num interestRate;
  late DateTime bidDate;
  late BidStatus bidStatus; //onGoing, selected, unsuccessful

  Bidder({
    required this.userId,
    required this.amount,
    required this.interestRate,
    required this.bidDate,
    required this.bidStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": this.userId,
      "bidDate": this.bidDate,
      "amount": this.amount,
      "bidStatus": EnumToString.convertToString(this.bidStatus),
      "interestRate": this.interestRate,
    };
  }

  factory Bidder.fromJson(Map<String, dynamic> json) {
    return Bidder(
      userId: json["userId"],
      bidDate: DateTime.parse(json["bidDate"]),
      amount: json["amount"],
      interestRate: json["interestRate"],
      bidStatus: EnumToString.fromString(BidStatus.values, json["bidStatus"])!,
    );
  }
}
