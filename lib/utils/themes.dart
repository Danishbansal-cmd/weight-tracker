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
        primaryColor: Color(0xFF673AB7),
        appBarTheme: const AppBarTheme(
          color: Colors.deepPurple,
        ),
        canvasColor: Colors.white,
        colorScheme: ColorScheme.light(
          primary: Colors.deepPurple,
          background: Vx.gray200,
          primaryVariant: Colors.grey.shade300,
          secondary: Colors.black,
        ),
        textTheme: const TextTheme(
          headline1: const TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
          headline2: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 14,
          ),
          headline6: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 15,
          ),
          headline3: const TextStyle(
              color: Color(0xffA59E9E),
              fontSize: 33,
              fontFamily: 'Alatsi-Regular'),
          headline4: const TextStyle(
              color: Color(0xff676363),
              fontSize: 24,
              fontFamily: 'Alatsi-Regular'),
          headline5: const TextStyle(
              color: Colors.deepPurple,
              fontSize: 20,
              fontFamily: 'Alegreya_Sans_SC'),
          button: TextStyle(
            fontFamily: 'Jua',
            fontSize: 22,
            color: Colors.white,
            letterSpacing: 1.1,
          ),
          subtitle2: TextStyle(
            fontFamily: 'Alatsi-Regular',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF673AB7),
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

  static const splashColor1 = Colors.white54;
  static const errorStyle = TextStyle(
    color: Colors.red,
    fontSize: 12,
  );
  static const font16 = TextStyle(
    color: Colors.black,
    fontSize: 16,
  );
}
