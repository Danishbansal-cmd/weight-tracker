import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:try1_something/functions/decision_tree.dart';
import 'package:try1_something/pages/body_mass_index.dart';
import 'package:try1_something/pages/first_page.dart';
import 'package:try1_something/pages/login_page.dart';
import 'package:try1_something/pages/home_page.dart';
import 'package:try1_something/pages/onboardingPages/onboarding_pages.dart';
import 'package:try1_something/pages/profile_page.dart';
import 'package:try1_something/pages/settings.dart';
import 'package:try1_something/pages/signup_page.dart';
import 'package:try1_something/pages/splash_page.dart';
import 'package:try1_something/routes/routes.dart';
import 'package:try1_something/utils/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';
// import 'package:flutter/services.dart';
int? initScreen;
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
        ChangeNotifierProvider<ThemeManager>(
          create: (_) => ThemeManager(),
        ),
      ],
      child: Consumer<ThemeManager>(
        builder: (context, appsThemeManager, _) {
          return GetMaterialApp(
            title: 'Weight Tracker',
            debugShowCheckedModeBanner: false,
            theme: MyThemes.lightTheme,
            themeMode: appsThemeManager.themeMode,
            darkTheme: MyThemes.darkTheme,
            initialRoute: "/splashPage",
            getPages: [
              GetPage(name: '/splashPage', page: () => const SplashPage()),
              GetPage(name: '/onboardingPages', page: () => const OnboardingPages()),
              GetPage(name: '/firstPage', page: () => const FirstPage()),
              GetPage(name: '/loginPage', page: () =>LoginPage()),
              GetPage(name: '/signupPage', page: () =>const SignupPage()),
              GetPage(name: '/homePage', page: () =>const HomePage()),
              GetPage(name: '/settingsPage', page: () => SettingsPage()),
              GetPage(name: '/bodyMassIndexPage', page: () => const BodyMassIndexPage()),
              GetPage(name: '/profilePage', page: () => ProfilePage()),
            ],

            routes: {
              // "/": (context) => const DecisionTree(),
              // // "/": (context) => const FirstPage(),
              // MyRoutes.loginPage: (context) => LoginPage(),
              // MyRoutes.homePage: (context) => const HomePage(),
              // MyRoutes.signupPage: (context) => const SignupPage(),
              // MyRoutes.settingsPage: (context) => SettingsPage(),
            },
          );
        },
      ),
    );
  }
}
