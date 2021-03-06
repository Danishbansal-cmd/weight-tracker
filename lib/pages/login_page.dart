import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:try1_something/pages/home_page.dart';
import 'package:try1_something/pages/signup_page.dart';
import 'package:try1_something/utils/themes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name = '';
  String emails = '';
  String passwords = '';
  TextEditingController emailsController = TextEditingController();
  TextEditingController passwordsController = TextEditingController();
  bool _passwordVisible = false;

  //initializing getx controller
  final loginPageStateController = Get.put(LoginPageState());

  bool changeButton = false;
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  FocusNode node1 = new FocusNode();
  FocusNode node2 = new FocusNode();

  int checkFirstTimeUsingHeight = 0;

  // moveToHome(BuildContext context) async {
  //   signIn();
  //   setState(() {
  //     changeButton = true;
  //   });
  //   await Future.delayed(Duration(seconds: 1));
  //   setState(() {
  //     changeButton = false;
  //   });
  // }

  int testingHeightValue = 0;
  // CollectionReference firestoreReference = FirebaseFirestore.instance
  //     .collection("users")
  //     .doc(FirebaseAuth.instance.currentUser!.uid)
  //     .collection("moreInfo");

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailsController.dispose();
    passwordsController.dispose();
    node1.dispose();
    node2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // we call also wrap safearea with material
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          physics: const ScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Logo box
                SizedBox(
                  height: (MediaQuery.of(context).size.height / 10) * 4,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "WeightTracker",
                        style: Theme.of(context).textTheme.headline1!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      Text(
                        "weigh every moment",
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              wordSpacing: 12,
                              letterSpacing: 2,
                              fontSize: 16,
                            ),
                      ),
                    ],
                  ),
                ),

                //form box
                SizedBox(
                  width: (MediaQuery.of(context).size.width / 4) * 3,
                  height: (MediaQuery.of(context).size.height / 100) * 56,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () => Text(
                          "Welcome ${loginPageStateController.loginEmailValue.value}",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      //
                      //email row
                      TextFormField(
                        focusNode: node1,
                        controller: emailsController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(node2);
                          // setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: "Enter Email",
                          labelText: "EMAIL",
                          labelStyle: TextStyle(
                            color: node1.hasFocus
                                ? Colors.deepPurple
                                : const Color(0xFF909090),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Email cannot be empty";
                          }
                          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                              .hasMatch(value)) {
                            return "Please enter valid email";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          // emails = emailsController.text;
                          // welcomeProvider.onChangeEmail(value);
                          loginPageStateController.loginEmailValue.value =
                              value;
                        },
                      ),
                      //
                      //password row
                      TextFormField(
                        focusNode: node2,
                        controller: passwordsController,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          hintText: "Enter Password",
                          labelText: "PASSWORD",
                          labelStyle: TextStyle(
                            color: node2.hasFocus
                                ? Colors.deepPurple
                                : const Color(0xFF909090),
                          ),
                        ),
                        validator: (value) {
                          RegExp regex = new RegExp(r'^.{6,}$');
                          if (value!.isEmpty) {
                            return ("Password is required for login");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Enter Valid Password(Min. 6 Character)");
                          }
                        },
                        onChanged: (value) {
                          passwords = passwordsController.text;
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(4),
                            splashColor: Colors.deepPurple,
                            onTap: () {
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                Get.toNamed('/forgotPasswordPage');
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              // color: Colors.green,
                              // width: (MediaQuery.of(context).size.width),
                              child: Text(
                                "Forgot Password?",
                                style: Theme.of(context).textTheme.headline6,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //
                      //login button
                      Material(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(13),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(13),
                          onTap: () {
                            signIn(emailsController.text,
                                passwordsController.text);

                            // moveToHome(context);
                          },
                          child: AnimatedContainer(
                            height: 55,
                            alignment: Alignment.center,
                            duration: Duration(seconds: 1),
                            width: changeButton
                                ? 55
                                : MediaQuery.of(context).size.width,
                            child: changeButton
                                ? const Icon(
                                    Icons.done,
                                    color: Colors.white,
                                  )
                                : Text(
                                    "LOGIN",
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      //
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account.",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                _createRoute(),
                              );
                            },
                            child: Text(
                              "Sign up",
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //animation to jump from one page to another for signup and signin
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignupPage(),
      transitionDuration: const Duration(milliseconds: 600),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  //sign in function
  Future<void> signIn(String emails, String passwords) async {
    print("begin to work");
    if (_formKey.currentState!.validate()) {
      setState(() {
        changeButton = true;
      });
      try {
        final User user = (await _auth.signInWithEmailAndPassword(
                email: emails, password: passwords))
            .user!;
        if (user != null) {
          setState(() async {
            final snapshot = await FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection("moreinfo").get();
            if (snapshot.docs.length == 0) {
              print("snapshot ${snapshot}");
              print("i run with 0");
              Get.offNamed('/informationPage');
            } else if (snapshot.docChanges.length != 0) {
              print("snapshot ${snapshot}");
              print("i run with 1");
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("moreinfo")
                  .doc('aboutdata')
                  .get()
                  .then((value) {
                testingHeightValue = value['height'];
              });
              testingHeightValue == null || testingHeightValue == 0
                  ? Get.offNamed('/informationPage')
                  : Get.offNamed('/homePage');
            }
          });
          loginPageStateController.loginEmailValue.value = '';
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "user not found",
              ),
            ),
          );
          setState(() {
            changeButton = false;
          });
        } else if (e.code == "wrong-password") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Wrong username or password",
              ),
            ),
          );
          setState(() {
            changeButton = false;
          });
        }
      }
    }
  }
}

class LoginPageState extends GetxController {
  RxString loginEmailValue = ''.obs;
  RxInt testing = 0.obs;
}
