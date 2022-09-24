import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class UserModel{
  String? phone;
  String? name;
  String? id;
  String? email;
  Timestamp? date;

  UserModel({this.phone, this.name, this.id, this.email, this.date});

  UserModel.fromSnapshot(DataSnapshot snap){
    phone = (snap.value as dynamic)["phone"];
    name = (snap.value as dynamic)["name"];
    id = snap.key;
    email = (snap.value as dynamic)["email"];
  }

  factory UserModel.fromJson(DocumentSnapshot snapshot){
    return UserModel(
      email: snapshot['email'],
      name: snapshot['name'],
      date: snapshot['date'],
      id: snapshot['id'],
    );
  }
}