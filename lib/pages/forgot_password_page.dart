import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:try1_something/utils/themes.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);

  //variables
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //appbar container
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //first container with back button
                    //and text
                    SizedBox(
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //back button
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const FaIcon(
                              FontAwesomeIcons.arrowLeftLong,
                              color: Colors.black,
                              size: 26,
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          //title text
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5.0,
                            ),
                            child: Text(
                              'Back to Login Page',
                              style:
                                  Theme.of(context).textTheme.button!.copyWith(
                                        fontSize: 18,
                                        color: Colors.black,
                                        letterSpacing: 0.2,
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //second container with simple button
                    InkWell(
                      onTap: () {},
                      child: const FaIcon(
                        FontAwesomeIcons.circleQuestion,
                        color: Colors.black,
                        // size: 26,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              //reset password text
              Text(
                "Reset password",
                style: Theme.of(context).textTheme.headline3!.copyWith(
                      color: Colors.black,
                    ),
              ),
              const SizedBox(
                height: 20,
              ),
              //
              //text
              const Text(
                '''Enter the email associated with your account and we'll send an email with instructions to reset your password.''',
                style: TextStyle(
                  color: Colors.grey,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 20,
              ),
              //
              //enter email field
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: "Enter Valid Email Address",
                    labelText: "EMAIL",
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
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //
              //Send email button
              Material(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(13),
                child: InkWell(
                  borderRadius: BorderRadius.circular(13),
                  onTap: () async {
                    try {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: emailController.text.trim(),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Reset email sent successfully'),
                          ),
                        );
                        //this will pop until it reach this '/forgotPasswordPage' route.
                        Navigator.of(context).popUntil(
                          ModalRoute.withName('/forgotPasswordPage'),
                        );
                        Get.offNamed('/emailSentSuccessfullyPage');
                      }
                    } on FirebaseAuthException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.message!),
                        ),
                      );
                      Get.back();
                    }
                  },
                  child: Container(
                    height: 55,
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Send Instructions",
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
