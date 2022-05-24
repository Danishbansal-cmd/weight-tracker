import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);

  //variables
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //
            //text
            const Text(
              'Recieve an email to reset your password.',
              textAlign: TextAlign.center,
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
                  hintText: "Enter Valid Email",
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
                      Navigator.of(context)
                          .popUntil(ModalRoute.withName('/forgotPasswordPage'));
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
                    "Send Email",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
