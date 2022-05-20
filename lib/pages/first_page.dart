import 'package:flutter/material.dart';
import 'package:try1_something/pages/login_page.dart';
import 'package:try1_something/routes/routes.dart';
import 'package:velocity_x/velocity_x.dart';

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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "WeightTracker",
                  style: _textScheme.headline1?.copyWith(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
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
            ).h48(context),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30,),
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
                        padding: const EdgeInsets.symmetric(vertical:13.0),
                        child: const Center(
                          child: Text(
                              "SIGN UP",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                  
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
                Container(
                  padding: EdgeInsets.zero,
                  margin:const EdgeInsets.symmetric(horizontal: 30,),
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
                        padding: const EdgeInsets.symmetric(vertical:13.0),
                        child: Center(
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
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
            ).h20(context),
          ],
        ),
      ),
    );
  }
}
