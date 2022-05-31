import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  User? user;
  int checkFirstTimeUsingHeight = 0;
  @override
  void initState() {
    super.initState();
    getNextScreen();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getNextScreen() async {
    await onRefresh(FirebaseAuth.instance.currentUser);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = await preferences.getInt('initOnboardScreen');
    print('this is the sharedprefrences data $data');
    Future.delayed(
      const Duration(milliseconds: 1800),
      () => data == 0 || data == null
          ? Get.offNamed('/onboardingPages')
          : user == null
              ? Get.offNamed('/firstPage')
              : Get.offNamed('/homePage'),
    );
  }

  Future<void> onRefresh(userCred) async {
    setState(() {
      user = userCred;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 235, 235, 235),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              // Image.asset("assets/icon.png",scale: 1,),
              // const SizedBox(height: 5,),
              const Text(
                "Something",
                style: TextStyle(fontSize: 22, letterSpacing: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
