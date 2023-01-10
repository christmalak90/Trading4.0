import 'package:user_app/Trading/DataAccess/Databases/DatabaseInterface.dart';
import 'package:user_app/Trading/DataAccess/Databases/FirebaseDatabase.dart';

IDatabase? getDatabase(String database) {
  switch (database) {
    case "firebase":
      return FirebaseDatabase();
    default:
      return null;
  }
}
