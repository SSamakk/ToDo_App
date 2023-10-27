import 'package:flutter/material.dart';

class MyTheme {

  static const Color primaryApp = Color(0xff5D9CEC);
  static const Color bgGreen = Color(0xffDFECDB);
  static const Color blackColor = Color(0xff303030);
  static const Color greenColor = Color(0xff61E757);
  static const Color redColor = Color(0xffEC4B4B);
  static const Color whiteColor = Color(0xffffffff);
  static const Color greyColor = Color(0xffC8C9CB);

  // dark colors
  static const Color bgDark = Color(0xff060E1E);
  static const Color primaryDark = Color(0xff141922);


  /// LIGHT
  static ThemeData lightMode = ThemeData(
    primaryColor: primaryApp,
    scaffoldBackgroundColor: bgGreen,

    appBarTheme: const AppBarTheme(
      color: primaryApp,
      elevation: 0,
      iconTheme: IconThemeData(color: whiteColor)
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: primaryApp,
      unselectedItemColor: greyColor,
      unselectedIconTheme: IconThemeData(size: 33),
      selectedIconTheme: IconThemeData(size: 33),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryApp,
      iconSize: 30,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: const BorderSide(
            color: whiteColor,
            width: 3
        )
      )
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: const MaterialStatePropertyAll(primaryApp),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
        ),
    ),

    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: whiteColor,
        fontWeight: FontWeight.w700,
        fontSize: 22,
      ),
      titleMedium: TextStyle(
        color: blackColor,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      titleSmall: TextStyle(
        color: blackColor,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(
        color: primaryApp,
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
    ),
  );

  /// DARK
  static ThemeData darkMode = ThemeData(
    primaryColor: primaryDark,
    scaffoldBackgroundColor: bgDark,

    appBarTheme: const AppBarTheme(
      color: primaryApp,
      elevation: 0,
      iconTheme: IconThemeData(color: bgDark)
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: primaryApp,
      unselectedItemColor: greyColor,
      unselectedIconTheme: IconThemeData(size: 33),
      selectedIconTheme: IconThemeData(size: 33),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryApp,
        iconSize: 30,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(
                color: primaryDark,
                width: 3
            )
        )
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: const MaterialStatePropertyAll(primaryApp),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30))),
      ),
    ),

    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: bgDark,
        fontWeight: FontWeight.w700,
        fontSize: 22,
      ),
      titleMedium: TextStyle(
        color: whiteColor,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      titleSmall: TextStyle(
        color: whiteColor,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(
        color: primaryApp,
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}