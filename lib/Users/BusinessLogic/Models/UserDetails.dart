class UserDetails {
  late String userId;
  late String? address;
  late DateTime? dateOfBirth;
  late num? income;
  late String? occupation;
  late int? household; //Number of people at home
  late String? education; //Highest degree obtained
  late num? rent;

  UserDetails({
    required this.userId,
    required this.address,
    required this.dateOfBirth,
    required this.income,
    required this.occupation,
    required this.household,
    required this.education,
    required this.rent,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": this.userId,
      "address": this.address,
      "dateOfBirth": this.dateOfBirth,
      "income": this.income,
      "occupation": this.occupation,
      "household": this.household,
      "education": this.education,
      "rent": this.rent
    };
  }

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      userId: json["userId"],
      address: json["address"],
      dateOfBirth: (json["dateOfBirth"] == null) ? json["dateOfBirth"] : DateTime.parse(json["dateOfBirth"]),
      income: json["income"],
      occupation: json["occupation"],
      household: json["household"],
      education: json["education"],
      rent: json["rent"],
    );
  }
}
