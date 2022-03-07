import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:try1_something/pages/login_page.dart';
import 'package:try1_something/routes/routes.dart';
import 'package:velocity_x/velocity_x.dart';

class MyDrawer extends StatelessWidget {
  String name;
  String? email;

  MyDrawer({Key? key, required this.name, required this.email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Container(
        color: Colors.deepPurple,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DrawerHeader(
              child: UserAccountsDrawerHeader(
                margin: EdgeInsets.zero,
                accountEmail: (name).text.make(),
                accountName: (email)!.text.make(),
                // currentAccountPicture: CircleAvatar(
                //   backgroundImage: NetworkImage(),
                // ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const ListTile(
                leading: Icon(CupertinoIcons.home, color: Colors.white),
                title: Text(
                  "Home",
                  textScaleFactor: 1.2,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const ListTile(
              leading:
                  Icon(CupertinoIcons.profile_circled, color: Colors.white),
              title: Text(
                "Profile",
                textScaleFactor: 1.2,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, MyRoutes.settingsPage);
              },
              child: const ListTile(
                leading:
                    Icon(CupertinoIcons.settings_solid, color: Colors.white),
                title: Text(
                  "Settings",
                  textScaleFactor: 1.2,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      logout(context);
                    },
                    child: const ListTile(
                      leading: Icon(CupertinoIcons.minus_circle,
                          color: Colors.white),
                      title: Text(
                        "Logout",
                        textScaleFactor: 1.2,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ).expand(),
          ],
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
