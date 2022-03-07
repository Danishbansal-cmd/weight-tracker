import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class ThemeManager extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  get themeMode {
    return _themeMode;
  }

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static ThemeData get lightTheme => ThemeData(
        primaryColor: Colors.deepPurple,
        appBarTheme: const AppBarTheme(
          color: Colors.deepPurple,
        ),
        canvasColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Colors.deepPurple,
          background: Vx.gray200,
          primaryVariant: Vx.gray200,
          secondary: Colors.black,
        ),
        textTheme: const TextTheme(
          headline1: TextStyle(
            color: Colors.white,
          ),
          headline2: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
          headline6: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 15,
          ),
        ),
        fontFamily: GoogleFonts.lato().fontFamily,
      );

  static ThemeData get darkTheme => ThemeData(
        // primaryColor: Colors.deepPurple,
        // primarySwatch: Colors.deepPurple,
        appBarTheme: const AppBarTheme(
          color: Colors.deepPurple,
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF303030),
          background: Color(0xFF303030),
          primaryVariant: Color(0xFF606060),
          secondary: Colors.white,
        ),
        textTheme: const TextTheme(
          headline1: TextStyle(
            color: Colors.deepPurple,
          ),
          headline2: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
          headline6: TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
        ),
        fontFamily: GoogleFonts.lato().fontFamily,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.deepPurple,
          selectionHandleColor: Colors.deepPurple,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.deepPurple,
              width: 2,
            ),
          ),
        ),
      );
}
