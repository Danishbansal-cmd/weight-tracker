import 'package:flutter/material.dart';
import 'package:try1_something/routes/routes.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _colorScheme = Theme.of(context).colorScheme;
    final _textScheme = Theme.of(context).textTheme;

    return Material(
      color: _colorScheme.primary,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //
            //weight tracker logo on the top
            SizedBox(
              height: (MediaQuery.of(context).size.height / 100) * 48,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "WeightTracker",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Text(
                    "weigh every moment",
                    style: _textScheme.headline6?.copyWith(
                      wordSpacing: 12,
                      letterSpacing: 2,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            //
            //buttons box on the bottom
            SizedBox(
              height: (MediaQuery.of(context).size.height / 100 ) * 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //signup button
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.white,
                        borderRadius: BorderRadius.circular(13),
                        onTap: () {
                          Navigator.pushNamed(context, MyRoutes.signupPage);
                        },
                        child: Container(
                          height: 55,
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              "SIGN UP",
                              style: Theme.of(context).textTheme.headline2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          // padding: EdgeInsets.symmetric(horizontal: 80,vertical: 15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  //login button
                  Container(
                    padding: EdgeInsets.zero,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                      child: InkWell(
                        splashColor: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(13),
                        onTap: () {
                          Navigator.pushNamed(context, MyRoutes.loginPage);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => LoginPage(),
                          //   ),
                          // );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 55,
                          child: Center(
                            child: Text(
                              "LOGIN",
                              style:
                                  Theme.of(context).textTheme.headline2!.copyWith(
                                        color: _colorScheme.primary,
                                      ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          decoration: BoxDecoration(
                            // color: Colors.white,
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
