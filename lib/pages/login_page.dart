import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:try1_something/all_notifiers.dart/welcom_notifier.dart';
import 'package:try1_something/pages/home_page.dart';
import 'package:try1_something/pages/signup_page.dart';
import 'package:try1_something/utils/themes.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  bool changeButton = false;
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  FocusNode node1 = new FocusNode();
  FocusNode node2 = new FocusNode();

  moveToHome(BuildContext context) async {
    signIn();
    setState(() {
      changeButton = true;
    });
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      changeButton = false;
    });
  }

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
    final _colorScheme = Theme.of(context).colorScheme;
    final _textTheme = Theme.of(context).textTheme;
    final welcomeProvider = Provider.of<WelcomeNotifier>(context);

    // we call also wrap safearea with material
    return SafeArea(
      child: Scaffold(
        backgroundColor: _colorScheme.background,
        body: SingleChildScrollView(
          physics: const ScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    "WeightTracker"
                        .text
                        .xl4
                        .bold
                        .color(Colors.deepPurple)
                        .center
                        .makeCentered(),
                    Text(
                      "weigh every moment",
                      style: _textTheme.headline6?.copyWith(
                          wordSpacing: 12,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ).h40(context),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Welcome ${welcomeProvider.text}"),
                    TextFormField(
                      focusNode: node1,
                      controller: emailsController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(node2);
                        setState(() {});
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
                        emails = emailsController.text;
                        welcomeProvider.onChangeEmail(value);
                      },
                    ),
                    TextFormField(
                      focusNode: node2,
                      controller: passwordsController,
                      obscureText: true,
                      decoration: InputDecoration(
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
                    10.heightBox,
                    Text(
                      "Forgot Password?",
                      style: _textTheme.headline6,
                      textAlign: TextAlign.right,
                    ).wThreeForth(context),
                    30.heightBox,
                    Material(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(50),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          signIn();

                          // moveToHome(context);
                        },
                        child: AnimatedContainer(
                          height: 50,
                          alignment: Alignment.center,
                          duration: Duration(seconds: 1),
                          width: changeButton
                              ? 50
                              : MediaQuery.of(context).size.width,
                          child: changeButton
                              ?const Icon(
                                  Icons.done,
                                  color: Colors.white,
                                )
                              : "LOGIN".text.color(Colors.white).bold.make(),
                        ),
                      ),
                    ),
                    10.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account.",
                          style: _textTheme.headline6,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              _createRoute(),
                            );
                          },
                          child: "Sign up"
                              .text
                              .bold
                              .color(Colors.deepPurple)
                              .textStyle(const TextStyle(
                                fontSize: 15,
                              ))
                              .make(),
                        ),
                      ],
                    ),
                  ],
                ).wThreeForth(context).h56(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignupPage(),
      transitionDuration:const Duration(milliseconds: 600),
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

  void signIn() async {
    print("begin to work");
    if (_formKey.currentState!.validate()) {
      setState(() {
        changeButton = true;
      });
      await _auth
          .signInWithEmailAndPassword(email: emails, password: passwords)
          .then((uid) => {
                changeButton = true,
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: "Signed in successfully".text.make())),
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomePage())),
              })
          .catchError((Object error) {
        print("cath erro wordks");
        Fluttertoast.showToast(msg: "not getting anything");
      });
    }
  }
}
