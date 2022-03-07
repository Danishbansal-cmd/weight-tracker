import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WeightModel {
  double weight;
  String day;
  String date;

  WeightModel({this.weight=0,this.day='',this.date=''});

  Map<String,dynamic> weightToMap() {
    return{
      'weight':weight,
      'day':day,
      'date':date,
    };
  }
  static List<WeightModel>? sampleList;

  static List<int> userWeights =[12,23,34,45,12,23,34,45];

  sendWeight() async{
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance.currentUser;
    await firebaseFirestore.collection("users").doc(_auth!.uid).collection("weight").doc(_auth.email).set(weightToMap());
  }

  factory WeightModel.fromMap(map){
    return WeightModel(
      weight: map['weight']
    );
  }

}