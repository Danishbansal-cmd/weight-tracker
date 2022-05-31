import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:try1_something/pages/login_page.dart';
import 'package:try1_something/routes/routes.dart';
import 'package:velocity_x/velocity_x.dart';

class MyDrawer extends StatelessWidget {
  String name;
  String? email;
  String? phoneNum;

  MyDrawer({
    Key? key,
    required this.name,
    required this.email,
    required this.phoneNum,
  }) : super(key: key);

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
            InkWell(
              onTap: () {
                Get.back();
                Get.toNamed('/profilePage', arguments: {
                  'email': email,
                  'name': name,
                  'phoneNumber': phoneNum
                });
              },
              child: const ListTile(
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
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/analyticsPage');
              },
              child: const ListTile(
                leading:
                    Icon(CupertinoIcons.graph_circle_fill, color: Colors.white),
                title: Text(
                  "Analytics",
                  textScaleFactor: 1.2,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/settingsPage', arguments: {'email': email});
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
            // InkWell(
            //   onTap: () {
            //     Get.back();
            //     Get.toNamed('/bodyMassIndexPage');
            //   },
            //   child: const ListTile(
            //     leading:
            //         Icon(CupertinoIcons.settings_solid, color: Colors.white),
            //     title: Text(
            //       "Bosdfasdf as sad ",
            //       textScaleFactor: 1.2,
            //       style: TextStyle(
            //         color: Colors.white,
            //       ),
            //     ),
            //   ),
            // ),
            Expanded(
              child: Container(
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed('/loginPage');
  }
}
