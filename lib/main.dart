import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:try1_something/functions/decision_tree.dart';
import 'package:try1_something/pages/analytics_page.dart';
import 'package:try1_something/pages/body_mass_index.dart';
import 'package:try1_something/pages/email_sent_successfully_page.dart';
import 'package:try1_something/pages/first_page.dart';
import 'package:try1_something/pages/forgot_password_page.dart';
import 'package:try1_something/pages/information_page.dart';
import 'package:try1_something/pages/login_page.dart';
import 'package:try1_something/pages/home_page.dart';
import 'package:try1_something/pages/onboardingPages/onboarding_pages.dart';
import 'package:try1_something/pages/profile_page.dart';
import 'package:try1_something/pages/settings.dart';
import 'package:try1_something/pages/signup_page.dart';
import 'package:try1_something/routes/routes.dart';
import 'package:try1_something/utils/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';
import 'package:device_preview/device_preview.dart';

// import 'package:flutter/services.dart';
int? initScreen;
// ignore: prefer_typing_uninitialized_variables
var data;
// ignore: prefer_typing_uninitialized_variables
var user;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  user = await FirebaseAuth.instance.currentUser;
  SharedPreferences preferences = await SharedPreferences.getInstance();
  data = await preferences.getInt('initOnboardScreen');

  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual);
  runApp(
    // DevicePreview(
    //   enabled: true,
    //   tools: [
    //     ...DevicePreview.defaultTools
    //   ],
      // builder: (context) => 
      MyApp(), // Wrap your app
    // ),
  );
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
            initialRoute: data == 0 || data == null
                ? '/onboardingPages'
                : user == null
                    ? '/firstPage'
                    : '/homePage',
            getPages: [
              GetPage(
                  name: '/onboardingPages',
                  page: () => const OnboardingPages(),transition: Transition.leftToRight,),
              GetPage(name: '/firstPage', page: () => const FirstPage(),transition: Transition.leftToRight,),
              GetPage(name: '/loginPage', page: () => LoginPage(),transition: Transition.leftToRight,),
              GetPage(name: '/signupPage', page: () => const SignupPage(),transition: Transition.leftToRight,),
              GetPage(name: '/homePage', page: () => const HomePage(),transition: Transition.leftToRight,),
              GetPage(name: '/settingsPage', page: () => SettingsPage(),transition: Transition.leftToRight,),
              GetPage(
                  name: '/bodyMassIndexPage',
                  page: () => const BodyMassIndexPage(),transition: Transition.leftToRight,),
              GetPage(name: '/profilePage', page: () => ProfilePage(),transition: Transition.leftToRight,),
              GetPage(
                  name: '/forgotPasswordPage',
                  page: () => ForgotPasswordPage(),transition: Transition.leftToRight,),
              GetPage(name: '/analyticsPage', page: () => AnalyticsPage(),transition: Transition.leftToRight,),
              GetPage(name: '/informationPage', page: () => InformationPage(),transition: Transition.leftToRight,),
              GetPage(name: '/emailSentSuccessfullyPage', page: () => EmailSentSuccessfullyPage(),transition: Transition.leftToRight,),
            ],
          );
        },
      ),
    );
  }
}
