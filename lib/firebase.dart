import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_any_code/bookMarkPage.dart';

CollectionReference users = FirebaseFirestore.instance.collection("Users");
FirebaseAuth auth = FirebaseAuth.instance;

Future<void> userSetup(String displayname) async {
  final uid = auth.currentUser?.uid.toString();
  // print(uid);
  // print(displayname);
  var result = await users.add({"displayName": displayname, "uid": uid});
  users.add({"DocID": result.id});
  return print(
      "added username: ${displayname} Uid: ${uid} DocID: ${result.id}");
}

Future<String?> getDocId() async {
  var collection = FirebaseFirestore.instance
      .collection("Users")
      .where("uid", isEqualTo: auth.currentUser?.uid);

  var doc = await collection.get();
  var docID = doc.docs.first.id;

  return docID.toString();
}

docIDString() {
  getDocId().then((DocID) {
    print("DocID type is ${DocID.runtimeType}");
    print("DocID is ${DocID}");

    return DocID;
  });
}

Future<void> saveBookmark(title, description) async {
  var collection = FirebaseFirestore.instance
      .collection("Users")
      .where("uid", isEqualTo: auth.currentUser?.uid);

  var doc = await collection.get();
  var docID = doc.docs.first.id;
  users
      .doc(docID)
      .collection("MyBookMark")
      .add({"title": title, "description": description, "isBooked": true});

  return print("adding successful data \"$title\" at $docID");
}

var doc_id = docIDString();

void loadData() async {
  QuerySnapshot<Map<String, dynamic>> bookMarkQuery =
      await users.doc(docIDString()).collection("MyBookMark").get();
}

printDoc() async {
  var collection = FirebaseFirestore.instance
      .collection("Users")
      .where("uid", isEqualTo: auth.currentUser?.uid);

  var doc = await collection.get();
  var docID = doc.docs.first.id;
  var result = await FirebaseFirestore.instance
      .collection("Users")
      .doc(docID)
      .collection("MyBookMark")
      .where("isBooked", isEqualTo: true)
      .get();

  print("result: ${result.docs.length}");
}
