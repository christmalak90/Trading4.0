import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_app/Trading/DataAccess/Databases/DatabaseInterface.dart';

class FirebaseDatabase implements IDatabase {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //Publish lending offer or borrowing request
  Future<String?> newTransaction(Map<String, dynamic> transaction) async {
    try {
      CollectionReference collection = firestore.collection('transactions');
      DocumentReference docRef = await collection.add(transaction);
      //Update the transactionId field of the document with the same value as the document ID
      docRef.update({
        "transactionId": docRef.id,
        "userId": FirebaseAuth.instance.currentUser!.uid,
      });

      return "success";
    } catch (e) {
      return handleError(e);
    }
  }

  Future<String?> placeBid(String transactionId, Map<String, dynamic> bidder) async {
    try {
      CollectionReference collection = firestore.collection('transactions');
      DocumentReference docRef = collection.doc(transactionId);
      docRef.update({
        "bidders": FieldValue.arrayUnion([bidder]),
      });

      //Update the list of transactions where the user has placed bids in the transactions_bids collection
      //this collection includes all the transactions where the user has placed bids
      //that will help us locate those transactions directly when needed instead of checking all the transactions one by one to check if the user has placed a bid on that transaction
      CollectionReference collection2 = firestore.collection('transactions_bids');
      collection2.doc(FirebaseAuth.instance.currentUser!.uid).update({
        "transactions": FieldValue.arrayUnion([transactionId])
      });

      return "success";
    } catch (e) {
      return handleError(e);
    }
  }

  Future<String?> viewBorrowingRequests() async {
    try {
      CollectionReference collection = firestore.collection('transactions');
      QuerySnapshot snapshot = await collection.get();
      Iterable<QueryDocumentSnapshot> documents = snapshot.docs.where((element) => element["transactionType"].toLowerCase() == "borrowing request");

      if (documents.isNotEmpty) {
        List<Map<String, dynamic>> bidders = [];
        List<Map<String, dynamic>> borrowingRequests = [];

        documents.forEach((document) {
          document.get('bidders').forEach((bidder) {
            bidders.add({
              "userId": bidder["userId"],
              "bidDate": bidder["bidDate"].toDate().toIso8601String(),
              "amount": bidder["amount"],
              "interestRate": bidder["interestRate"],
              "bidStatus": bidder["bidStatus"],
            });
          });

          Map<String, dynamic> request = {
            "transactionId": document.get('transactionId'),
            "userId": document.get('userId'),
            "publishedDate": document.get('publishedDate').toDate().toIso8601String(),
            "dueDate": document.get('dueDate').toDate().toIso8601String(),
            "transactionType": document.get('transactionType'),
            "amount": document.get('amount'),
            "interestRate": document.get('interestRate'),
            "duration": document.get('duration'),
            "transactionStatus": document.get('transactionStatus'),
            "bidders": bidders,
          };
          borrowingRequests.add(request);
          bidders = [];
        });
        return jsonEncode(borrowingRequests);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String?> viewLendingOffers() async {
    try {
      CollectionReference collection = firestore.collection('transactions');
      QuerySnapshot snapshot = await collection.get();
      Iterable<QueryDocumentSnapshot> documents = snapshot.docs.where((element) => element["transactionType"].toLowerCase() == "lending offer");

      if (documents.isNotEmpty) {
        List<Map<String, dynamic>> bidders = [];
        List<Map<String, dynamic>> lendingOffers = [];

        documents.forEach((document) {
          document.get('bidders').forEach((bidder) {
            bidders.add({
              "userId": bidder["userId"],
              "bidDate": bidder["bidDate"].toDate().toIso8601String(),
              "amount": bidder["amount"],
              "interestRate": bidder["interestRate"],
              "bidStatus": bidder["bidStatus"],
            });
          });

          Map<String, dynamic> offer = {
            "transactionId": document.get('transactionId'),
            "userId": document.get('userId'),
            "publishedDate": document.get('publishedDate').toDate().toIso8601String(),
            "dueDate": document.get('dueDate').toDate().toIso8601String(),
            "transactionType": document.get('transactionType'),
            "amount": document.get('amount'),
            "interestRate": document.get('interestRate'),
            "duration": document.get('duration'),
            "transactionStatus": document.get('transactionStatus'),
            "bidders": bidders,
          };
          lendingOffers.add(offer);
          bidders = [];
        });
        return jsonEncode(lendingOffers);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  //View lending offer or borrowing request details
  Future<String?> viewTransactionDetails(String transactionId) async {
    try {
      CollectionReference collection = firestore.collection('transactions');
      QuerySnapshot snapshot = await collection.get();
      QueryDocumentSnapshot document = snapshot.docs.singleWhere((element) => element.id == transactionId);

      if (document.exists) {
        List<Map<String, dynamic>> bidders = [];

        document.get('bidders').forEach((bidder) {
          bidders.add({
            "userId": bidder["userId"],
            "bidDate": bidder["bidDate"].toDate().toIso8601String(),
            "amount": bidder["amount"],
            "interestRate": bidder["interestRate"],
            "bidStatus": bidder["bidStatus"],
          });
        });

        Map<String, dynamic> transaction = {
          "transactionId": document.get('transactionId'),
          "userId": document.get('userId'),
          "dueDate": document.get('dueDate').toDate().toIso8601String(),
          "publishedDate": document.get('publishedDate').toDate().toIso8601String(),
          "transactionType": document.get('transactionType'),
          "amount": document.get('amount'),
          "interestRate": document.get('interestRate'),
          "duration": document.get('duration'),
          "transactionStatus": document.get('transactionStatus'),
          "bidders": bidders,
        };

        return jsonEncode(transaction);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  //View the offers that you published
  Future<String?> viewMyLendingOffers() async {
    try {
      CollectionReference collection = firestore.collection('transactions');
      QuerySnapshot snapshot = await collection.get();
      Iterable<QueryDocumentSnapshot> documents =
          snapshot.docs.where((element) => element["transactionType"].toLowerCase() == "lending offer" && element["userId"] == FirebaseAuth.instance.currentUser!.uid);

      if (documents.isNotEmpty) {
        List<Map<String, dynamic>> bidders = [];
        List<Map<String, dynamic>> lendingOffers = [];

        documents.forEach((document) {
          document.get('bidders').forEach((bidder) {
            bidders.add({
              "userId": bidder["userId"],
              "bidDate": bidder["bidDate"].toDate().toIso8601String(),
              "amount": bidder["amount"],
              "interestRate": bidder["interestRate"],
              "bidStatus": bidder["bidStatus"],
            });
          });

          Map<String, dynamic> offer = {
            "transactionId": document.get('transactionId'),
            "userId": document.get('userId'),
            "publishedDate": document.get('publishedDate').toDate().toIso8601String(),
            "dueDate": document.get('dueDate').toDate().toIso8601String(),
            "transactionType": document.get('transactionType'),
            "amount": document.get('amount'),
            "interestRate": document.get('interestRate'),
            "duration": document.get('duration'),
            "transactionStatus": document.get('transactionStatus'),
            "bidders": bidders,
          };
          lendingOffers.add(offer);
          bidders = [];
        });
        return jsonEncode(lendingOffers);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  //View the requests that you published
  Future<String?> viewMyBorrowingRequests() async {
    try {
      CollectionReference collection = firestore.collection('transactions');
      QuerySnapshot snapshot = await collection.get();
      Iterable<QueryDocumentSnapshot> documents =
          snapshot.docs.where((element) => element["transactionType"].toLowerCase() == "borrowing request" && element["userId"] == FirebaseAuth.instance.currentUser!.uid);

      if (documents.isNotEmpty) {
        List<Map<String, dynamic>> bidders = [];
        List<Map<String, dynamic>> borrowingRequests = [];

        documents.forEach((document) {
          document.get('bidders').forEach((bidder) {
            bidders.add({
              "userId": bidder["userId"],
              "bidDate": bidder["bidDate"].toDate().toIso8601String(),
              "amount": bidder["amount"],
              "interestRate": bidder["interestRate"],
              "bidStatus": bidder["bidStatus"],
            });
          });

          Map<String, dynamic> request = {
            "transactionId": document.get('transactionId'),
            "userId": document.get('userId'),
            "publishedDate": document.get('publishedDate').toDate().toIso8601String(),
            "dueDate": document.get('dueDate').toDate().toIso8601String(),
            "transactionType": document.get('transactionType'),
            "amount": document.get('amount'),
            "interestRate": document.get('interestRate'),
            "duration": document.get('duration'),
            "transactionStatus": document.get('transactionStatus'),
            "bidders": bidders,
          };
          borrowingRequests.add(request);
          bidders = [];
        });
        return jsonEncode(borrowingRequests);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  //View the lending bids that you placed
  Future<String?> viewMyLendingBids() async {
    try {
      //Get the list of transaction ids where the user has place bids
      CollectionReference collection = firestore.collection('transactions_bids');
      QuerySnapshot snapshot = await collection.get();
      QueryDocumentSnapshot document = snapshot.docs.singleWhere((element) => element.id == FirebaseAuth.instance.currentUser!.uid);

      if (document.exists) {
        List<String> transactionIds = [];

        document["transactions"].forEach((transId) {
          transactionIds.add(transId);
        });

        if (transactionIds.isNotEmpty) {
          //Get the list of transactions where the user has placed bids
          CollectionReference collection = firestore.collection('transactions');
          QuerySnapshot snapshot = await collection.get();
          Iterable<QueryDocumentSnapshot> documents =
              snapshot.docs.where((element) => transactionIds.contains(element["transactionId"]) && element["transactionType"].toLowerCase() == "borrowing request");

          List<Map<String, dynamic>> bidders = [];
          List<Map<String, dynamic>> borrowingRequests = [];

          documents.forEach((document) {
            document.get('bidders').forEach((bidder) {
              bidders.add({
                "userId": bidder["userId"],
                "bidDate": bidder["bidDate"].toDate().toIso8601String(),
                "amount": bidder["amount"],
                "interestRate": bidder["interestRate"],
                "bidStatus": bidder["bidStatus"],
              });
            });

            Map<String, dynamic> request = {
              "transactionId": document.get('transactionId'),
              "userId": document.get('userId'),
              "publishedDate": document.get('publishedDate').toDate().toIso8601String(),
              "dueDate": document.get('dueDate').toDate().toIso8601String(),
              "transactionType": document.get('transactionType'),
              "amount": document.get('amount'),
              "interestRate": document.get('interestRate'),
              "duration": document.get('duration'),
              "transactionStatus": document.get('transactionStatus'),
              "bidders": bidders,
            };
            borrowingRequests.add(request);
            bidders = [];
          });
          return jsonEncode(borrowingRequests);
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  //View the borrowing bids that you placed
  Future<String?> viewMyBorrowingBids() async {
    try {
      //Get the list of transaction ids where the user has place bids
      CollectionReference collection = firestore.collection('transactions_bids');
      QuerySnapshot snapshot = await collection.get();
      QueryDocumentSnapshot document = snapshot.docs.singleWhere((element) => element.id == FirebaseAuth.instance.currentUser!.uid);

      if (document.exists) {
        List<String> transactionIds = [];

        document["transactions"].forEach((transId) {
          transactionIds.add(transId);
        });

        if (transactionIds.isNotEmpty) {
          //Get the list of transactions where the user has placed bids
          CollectionReference collection = firestore.collection('transactions');
          QuerySnapshot snapshot = await collection.get();
          Iterable<QueryDocumentSnapshot> documents =
              snapshot.docs.where((element) => transactionIds.contains(element["transactionId"]) && element["transactionType"].toLowerCase() == "lending offer");

          List<Map<String, dynamic>> bidders = [];
          List<Map<String, dynamic>> lendingOffers = [];

          documents.forEach((document) {
            document.get('bidders').forEach((bidder) {
              bidders.add({
                "userId": bidder["userId"],
                "bidDate": bidder["bidDate"].toDate().toIso8601String(),
                "amount": bidder["amount"],
                "interestRate": bidder["interestRate"],
                "bidStatus": bidder["bidStatus"],
              });
            });

            Map<String, dynamic> offer = {
              "transactionId": document.get('transactionId'),
              "userId": document.get('userId'),
              "publishedDate": document.get('publishedDate').toDate().toIso8601String(),
              "dueDate": document.get('dueDate').toDate().toIso8601String(),
              "transactionType": document.get('transactionType'),
              "amount": document.get('amount'),
              "interestRate": document.get('interestRate'),
              "duration": document.get('duration'),
              "transactionStatus": document.get('transactionStatus'),
              "bidders": bidders,
            };
            lendingOffers.add(offer);
            bidders = [];
          });
          return jsonEncode(lendingOffers);
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String?> cancelTransaction(String transactionId) async {
    try {
      CollectionReference collection = firestore.collection('transactions');
      QuerySnapshot snapshot = await collection.get();
      QueryDocumentSnapshot document = snapshot.docs.singleWhere((element) => element.id == transactionId);

      if (document.exists) {
        List<Map<String, dynamic>> bidders = [];
        document.get('bidders').forEach((bidder) {
          bidders.add({
            "userId": bidder["userId"],
            "bidDate": bidder["bidDate"],
            "amount": bidder["amount"],
            "interestRate": bidder["interestRate"],
            "bidStatus": "cancelled",
          });
        });

        document.reference.update(
          {
            "transactionStatus": "cancelled",
            "bidders": bidders,
          },
        );

        return "success";
      }
    } catch (e) {
      return handleError(e);
    }
  }

  Future<String?> editBid(String transactionId, num amount, num interestRate) async {
    try {
      CollectionReference collection = firestore.collection('transactions');
      QuerySnapshot snapshot = await collection.get();
      QueryDocumentSnapshot document = snapshot.docs.singleWhere((element) => element.id == transactionId);

      if (document.exists) {
        List<Map<String, dynamic>> bidders = [];
        document.get('bidders').forEach((bidder) {
          if (bidder["userId"] == FirebaseAuth.instance.currentUser!.uid) {
            bidders.add({
              "userId": bidder["userId"],
              "bidDate": bidder["bidDate"],
              "amount": amount,
              "interestRate": interestRate,
              "bidStatus": "onGoing",
            });
          } else {
            bidders.add({
              "userId": bidder["userId"],
              "bidDate": bidder["bidDate"],
              "amount": bidder["amount"],
              "interestRate": bidder["interestRate"],
              "bidStatus": bidder["bidStatus"],
            });
          }
          document.reference.update(
            {
              "bidders": bidders,
            },
          );
        });
        return "success";
      }
    } catch (e) {
      return handleError(e);
    }
  }

  Future<String?> cancelBid(String transactionId) async {
    try {
      CollectionReference collection = firestore.collection('transactions');
      QuerySnapshot snapshot = await collection.get();
      QueryDocumentSnapshot document = snapshot.docs.singleWhere((element) => element.id == transactionId);

      if (document.exists) {
        List<Map<String, dynamic>> bidders = [];
        document.get('bidders').forEach((bidder) {
          if (bidder["userId"] == FirebaseAuth.instance.currentUser!.uid) {
            bidders.add({
              "userId": bidder["userId"],
              "bidDate": bidder["bidDate"],
              "amount": bidder["amount"],
              "interestRate": bidder["interestRate"],
              "bidStatus": "cancelled",
            });
          } else {
            bidders.add({
              "userId": bidder["userId"],
              "bidDate": bidder["bidDate"],
              "amount": bidder["amount"],
              "interestRate": bidder["interestRate"],
              "bidStatus": bidder["bidStatus"],
            });
          }
          document.reference.update(
            {
              "bidders": bidders,
            },
          );
        });
        return "success";
      }
    } catch (e) {
      return handleError(e);
    }
  }

  String handleError(e) {
    return "Error: ${e.message}";
  }
}
