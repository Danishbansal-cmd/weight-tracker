import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:try1_something/pages/first_page.dart';
import 'package:try1_something/pages/home_page.dart';

class DecisionTree extends StatefulWidget {
  const DecisionTree({ Key? key }) : super(key: key);

  @override
  _DecisionTreeState createState() => _DecisionTreeState();
}

class _DecisionTreeState extends State<DecisionTree> {
  late User user;
  @override
  void initState(){
    super.initState();
    onRefresh(FirebaseAuth.instance.currentUser);
  }

  onRefresh(userCred){
    setState(() {
      user = userCred;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(user == null){
      return FirstPage();
    }
    return HomePage();
  }
}