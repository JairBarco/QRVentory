import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class DriverModel{
  String? phone;
  String? name;
  String? id;
  String? email;
  Timestamp? date;

  DriverModel({this.phone, this.name, this.id, this.email, this.date});

  DriverModel.fromSnapshot(DataSnapshot snap){
    phone = (snap.value as dynamic)["phone"];
    name = (snap.value as dynamic)["name"];
    id = snap.key;
    date = (snap.value as dynamic)['date'];
    email = (snap.value as dynamic)["email"];
  }

  factory DriverModel.fromJson(DocumentSnapshot snapshot){
    return DriverModel(
      email: snapshot['email'],
      name: snapshot['name'],
      date: snapshot['date'],
      id: snapshot['id'],
    );
  }
}