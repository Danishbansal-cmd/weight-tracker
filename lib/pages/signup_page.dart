import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:try1_something/pages/home_page.dart';
import 'package:try1_something/pages/login_page.dart';
import 'package:try1_something/models/user_model.dart';
import 'package:try1_something/utils/themes.dart';
// import 'package:velocity_x/velocity_x.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String firstname = '';
  String secondname = '';
  String emails = '';
  String passwords = '';
  String confirmPasswords = '';
  bool signupCheckbox = false;
  //
  //bool for password visibility
  bool _passwordVisible = false;
  bool _passwordVisible2 = false;

  bool changeButton = false;
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  FocusNode node1 = new FocusNode();
  FocusNode node2 = new FocusNode();
  FocusNode node3 = new FocusNode();
  FocusNode node4 = new FocusNode();
  FocusNode node5 = new FocusNode();

  @override
  void dispose() {
    super.dispose();
    node1.dispose();
    node2.dispose();
    node3.dispose();
    node4.dispose();
    node5.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _colorScheme = Theme.of(context).colorScheme;
    final _textTheme = Theme.of(context).textTheme;
    // print("height");
    // print("height");
    // print("height");
    // print("height");
    // print(MediaQuery.of(context).viewPadding.top);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 150,
          backgroundColor: _colorScheme.background,
          automaticallyImplyLeading: false,
          title: SizedBox(
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
          elevation: 0,
        ),
        backgroundColor: _colorScheme.background,
        body: SingleChildScrollView(
          physics: const ScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Form(
            key: _formKey,
            child: Container(
              // color: Colors.yellow,
              height: MediaQuery.of(context).size.height -
                  135 -
                  (MediaQuery.of(context).viewPadding.top),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.zero,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     "WeightTracker"
                  //         .text
                  //         .xl4
                  //         .bold
                  //         .color(Colors.deepPurple)
                  //         .center
                  //         .makeCentered(),
                  //     Text(
                  //       "weigh every moment",
                  //       style: _textTheme.headline6?.copyWith(
                  //           wordSpacing: 12,
                  //           letterSpacing: 2,
                  //           fontWeight: FontWeight.bold),
                  //     ),
                  //   ],
                  // ).h15(context),
                  // 30.heightBox,
                  // Text("wrsfs"),
                  // Text("wrsfs"),
                  Container(
                    // color: Colors.red,
                    width: (MediaQuery.of(context).size.width / 4) * 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          focusNode: node1,
                          autofocus: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          cursorColor: Colors.deepPurple,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Enter First name",
                            labelText: "FIRST NAME",
                            labelStyle: TextStyle(
                              color: node1.hasFocus
                                  ? Colors.deepPurple
                                  : const Color(0xFF909090),
                            ),
                            // labelStyle: TextStyle(
                            //   color: myFocusNode.hasFocus ? Colors.deepPurple : Colors.grey,
                            // ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.deepPurple,
                                width: 2,
                              ),
                            ),
                          ),
                          validator: (value) {
                            RegExp regex = RegExp(r'^.{3,}$');
                            if (value!.isEmpty) {
                              return "First Name cannot be empty";
                            }
                            if (!regex.hasMatch(value)) {
                              return "Enter Valid name(Min. 3 Characters)";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            firstname = value;
                            setState(() {});
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          focusNode: node2,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            hintText: "Enter Last name",
                            labelText: "LAST NAME",
                            labelStyle: TextStyle(
                              color: node2.hasFocus
                                  ? Colors.deepPurple
                                  : const Color(0xFF909090),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("Second Name cannot be Empty");
                            }
                            return null;
                          },
                          onChanged: (value) {
                            secondname = value;
                            setState(() {});
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          focusNode: node3,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            hintText: "Enter Email",
                            labelText: "EMAIL",
                            labelStyle: TextStyle(
                              color: node3.hasFocus
                                  ? Colors.deepPurple
                                  : const Color(0xFF909090),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Email cannot be empty";
                            }
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return "Please enter valid email";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            emails = value;
                            setState(() {});
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          focusNode: node4,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                              color: node4.hasFocus
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
                            passwords = value;
                            setState(() {});
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          focusNode: node5,
                          obscureText: !_passwordVisible2,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _passwordVisible2 = !_passwordVisible2;
                                });
                              },
                              icon: Icon(
                                _passwordVisible2
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            hintText: "Enter Password",
                            labelText: "CONFIRM PASSWORD",
                            labelStyle: TextStyle(
                              color: node5.hasFocus
                                  ? Colors.deepPurple
                                  : const Color(0xFF909090),
                            ),
                          ),
                          validator: (value) {
                            if (confirmPasswords != passwords) {
                              return "Password don't match";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            confirmPasswords = value;
                            setState(() {});
                          },
                        ),
                        // Row(
                        //   children: [
                        //     "By signin up you accept the ".text.make(),
                        //     "Term of service"
                        //         .text
                        //         .color(context.theme.accentColor)
                        //         .make()
                        //         .expand(),
                        //     "and ".text.make(),
                        //     "Privacy Policy"
                        //         .text
                        //         .color(context.theme.accentColor)
                        //         .make()
                        //         .expand(),
                        //   ],
                        // ),
                        Row(
                          children: [
                            Checkbox(
                              value: signupCheckbox,
                              onChanged: (value) {
                                this.signupCheckbox = !this.signupCheckbox;
                                setState(() {});
                                print(signupCheckbox);
                              },
                            ),
                            SizedBox(
                              width:
                                  (MediaQuery.of(context).size.width / 10) * 6,
                              child: RichText(
                                text: TextSpan(
                                  text: "By signing up you accept the ",
                                  style: _textTheme.headline6,
                                  children: [
                                    TextSpan(
                                      text: "Term of service",
                                      style:
                                          TextStyle(color: Colors.deepPurple),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          print("Term of sertvive");
                                        },
                                    ),
                                    TextSpan(
                                      text: " and ",
                                      style: _textTheme.headline6,
                                    ),
                                    TextSpan(
                                      text: "Privacy Policy",
                                      style:
                                          TextStyle(color: Colors.deepPurple),
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () {
                                          print("Privacy policy.");
                                        },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Material(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(13),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(13),
                            splashColor: MyThemes.splashColor1,
                            onTap: () {
                              Signup(emails, passwords);
                            },
                            child: AnimatedContainer(
                              height: 55,
                              alignment: Alignment.center,
                              duration: const Duration(seconds: 1),
                              width: changeButton
                                  ? 55
                                  : MediaQuery.of(context).size.width,
                              child: changeButton
                                  ? const Icon(Icons.done)
                                  : Text(
                                      "SIGN UP",
                                      style:
                                          Theme.of(context).textTheme.headline2,
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account.",
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
                                "Sign in",
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
      ),
    );
  }

  void Signup(String email, String password) async {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: "String is not allowed".text.make(),
    //     onVisible: () {
    //       print("it si visiboe");
    //     },
    //   ),
    // );
    if (_formKey.currentState!.validate()) {
      setState(() {
        changeButton = true;
      });
      if (signupCheckbox == true) {
        print("can i wrofs");
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {
                  changeButton = true,
                  postDetailsToFirestore(),
                })
            .catchError(
          (e) {
            Fluttertoast.showToast(msg: e!.message);
            setState(() {
              changeButton = false;
            });
          },
        );
      } else {
        print("does i work");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "String is not allowed",
            ),
            // onVisible: () {
            //   print("it si visiboe");
            // },
          ),
        );
        Fluttertoast.showToast(msg: "Accept our policies");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Please fill the fields.",
          ),
          onVisible: () {
            print("it si visiboe");
          },
        ),
      );
    }
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
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

  postDetailsToFirestore() async {
    //calling our firestore
    //calling our usermodel
    //sending these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstname;
    userModel.secondName = secondname;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());

    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.pushAndRemoveUntil((context),
        MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
  }
}
