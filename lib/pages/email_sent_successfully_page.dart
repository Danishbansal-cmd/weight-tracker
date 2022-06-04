import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_mail_app/open_mail_app.dart';

class EmailSentSuccessfullyPage extends StatelessWidget {
  const EmailSentSuccessfullyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              //upper main column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //email icon box
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).colorScheme.background,
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Image.asset(
                              'assets/icons/email.png',
                            ),
                          ),
                        ),
                      ),
                    )
                    //check your email text
                    ,
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Check your mail",
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                            color: Colors.black,
                          ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    //
                    //text
                    const SizedBox(
                      width: 230,
                      child: Text(
                          '''We have sent a password recover instructions to your email.''',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center),
                    ),
                    const SizedBox(
                      height: 38,
                    ),
                    //open email button
                    Material(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(13),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(13),
                        onTap: () async {
                          // Android: Will open mail app or show native picker.
                          // iOS: Will open mail app if single mail app found.
                          var result = await OpenMailApp.openMailApp();

                          // If no mail apps found, show error
                          if (!result.didOpen && !result.canOpen) {
                            showNoMailAppsDialog(context);

                            // iOS: if multiple mail apps found, show dialog to select.
                            // There is no native intent/default app system in iOS so
                            // you have to do it yourself.
                          } else if (!result.didOpen && result.canOpen) {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return MailAppPickerDialog(
                                  mailApps: result.options,
                                );
                              },
                            );
                          }
                        },
                        child: Container(
                          height: 55,
                          alignment: Alignment.center,
                          width: 170,
                          child: Text(
                            "Open email app",
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    //skip button
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.grey,
                        borderRadius: BorderRadius.circular(13),
                        onTap: () {
                          Future.delayed(
                            const Duration(milliseconds: 200),
                            () {
                              Get.offNamed('/loginPage');
                            },
                          );
                        },
                        child: Container(
                          height: 55,
                          alignment: Alignment.center,
                          width: 170,
                          child: Text(
                            "Skip, I'll confirm later",
                            style:
                                Theme.of(context).textTheme.headline2!.copyWith(
                                      color: Colors.black,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //bottom container
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24.0,
                ),
                child: Column(
                  children: [
                    //text
                    const Text(
                        "Did not receive email? Check your spam folder."),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //or text
                        const Text("or"),
                        const SizedBox(
                          width: 4.0,
                        ),
                        //text
                        InkWell(
                          onTap: () {
                            Get.offNamed("/forgotPasswordPage");
                          },
                          child: Text(
                            "try another email address",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Open Mail App"),
          content: Text("No mail apps installed"),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
