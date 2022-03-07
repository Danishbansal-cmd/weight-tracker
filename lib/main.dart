import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:try1_something/all_notifiers.dart/welcom_notifier.dart';
import 'package:try1_something/functions/decistion_tree.dart';
import 'package:try1_something/pages/first_page.dart';
import 'package:try1_something/pages/login_page.dart';
import 'package:try1_something/pages/home_page.dart';
import 'package:try1_something/pages/settings.dart';
import 'package:try1_something/pages/signup_page.dart';
import 'package:try1_something/routes/routes.dart';
import 'package:try1_something/utils/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:velocity_x/velocity_x.dart';
// import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WelcomeNotifier>(
          create: (_) => WelcomeNotifier(),
        ),
        ChangeNotifierProvider<ThemeManager>(
          create: (_) => ThemeManager(),
        ),
      ],
      child: Consumer<ThemeManager>(
        builder: (context, appsThemeManager, _) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: MyThemes.lightTheme,
            themeMode: appsThemeManager.themeMode,
            darkTheme: MyThemes.darkTheme,
            initialRoute: "/",
            routes: {
              "/": (context) => const DecisionTree(),
              // "/": (context) => const FirstPage(),
              MyRoutes.loginPage: (context) => LoginPage(),
              MyRoutes.homePage: (context) => const HomePage(),
              MyRoutes.signupPage: (context) => const SignupPage(),
              MyRoutes.settingsPage: (context) => SettingsPage(),
            },
          );
        },
      ),
    );
  }
}
