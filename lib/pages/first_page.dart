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
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    Navigator.pushNamed(context, MyRoutes.signupPage);
                  },
                  child: Container(
                    child: "SIGN UP"
                        .text
                        .center
                        .bold
                        .color(Colors.white)
                        .make()
                        .py(13),
                    // padding: EdgeInsets.symmetric(horizontal: 80,vertical: 15),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ).wThreeForth(context),
                ),
                const SizedBox(
                  height: 20,
                ),
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
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
                      child: "LOGIN"
                          .text
                          .center
                          .bold
                          .color(_colorScheme.primary)
                          .make()
                          .py(13),
                      // padding: EdgeInsets.symmetric(horizontal: 80,vertical: 15),
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        border: Border.all(
                          width: 1,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ).wThreeForth(context),
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
