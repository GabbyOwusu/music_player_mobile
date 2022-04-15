import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as c;
import 'package:flutter/services.dart';
import 'package:music_streaming/theme/ui_colors.dart';

const ContentPadding = EdgeInsets.all(24);

class AppTheme {
  const AppTheme._();

  static const fontFamily = "Circular";
  static final formBorderRadius = BorderRadius.circular(16);

  static ThemeData datePickerTheme(ThemeData theme) {
    return ThemeData(
      colorScheme: theme.colorScheme.copyWith(
        primary: Colors.orange.shade50,
        onSurface: theme.primaryColor,
      ),
      textTheme: theme.textTheme.copyWith(
        overline: theme.textTheme.overline?.copyWith(fontFamily: fontFamily),
        headline4: theme.textTheme.headline4?.copyWith(fontFamily: fontFamily),
        headline5: theme.textTheme.headline5?.copyWith(fontFamily: fontFamily),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(theme.primaryColor),
          textStyle: MaterialStateProperty.all(
            TextStyle(fontFamily: fontFamily),
          ),
        ),
      ),
    );
  }

  static ThemeData get light {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: fontFamily,
      primaryColor: UiColors.primaryColor,
      highlightColor: Colors.white,
      primaryColorLight: Colors.white,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: Colors.white,
      splashColor: Colors.transparent,
      backgroundColor: Colors.white,
      unselectedWidgetColor: Colors.black12,
      dividerColor: UiColors.divider,
      primaryTextTheme: TextTheme(
        bodyText1: TextStyle(fontFamily: fontFamily),
        bodyText2: TextStyle(fontFamily: fontFamily),
      ),
      cupertinoOverrideTheme: const c.CupertinoThemeData(
        primaryColor: UiColors.primaryColor,
        barBackgroundColor: Colors.white,
        textTheme: const c.CupertinoTextThemeData(
          textStyle: const TextStyle(
            color: Colors.black87,
            fontFamily: fontFamily,
          ),
          tabLabelTextStyle: const TextStyle(
            fontSize: 11.5,
            fontFamily: fontFamily,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        color: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: UiColors.primaryColor,
        selectionHandleColor: UiColors.primaryColor,
        selectionColor: Colors.grey.shade400,
      ),
      textTheme: TextTheme(
        headline4: TextStyle(
          color: UiColors.primaryColor,
          fontWeight: FontWeight.bold,
        ),
        bodyText1: TextStyle(
          fontWeight: FontWeight.normal,
        ),
        bodyText2: TextStyle(
          fontWeight: FontWeight.normal,
        ),
      ),
      buttonTheme: ButtonThemeData(
        minWidth: 50,
        buttonColor: UiColors.primaryColor,
        splashColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: UiColors.primaryColor,
          textStyle: TextStyle(
            fontSize: 16,
            fontFamily: fontFamily,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.all(14),
          side: BorderSide(color: UiColors.primaryColor.withOpacity(0.7)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: TextStyle(fontFamily: fontFamily),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: UiColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        border: OutlineInputBorder(
          borderRadius: AppTheme.formBorderRadius,
          borderSide: BorderSide(color: UiColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppTheme.formBorderRadius,
          borderSide: BorderSide(color: UiColors.border),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppTheme.formBorderRadius,
          borderSide: BorderSide(color: UiColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppTheme.formBorderRadius,
          borderSide: BorderSide(width: 2, color: UiColors.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppTheme.formBorderRadius,
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppTheme.formBorderRadius,
          borderSide: BorderSide(width: 2, color: Colors.red),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
          .copyWith(secondary: UiColors.primaryColor),
    );
  }

  static ThemeData get dark {
    return light.copyWith(
      brightness: Brightness.dark,
      primaryColor: Colors.white,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: Colors.black,
      highlightColor: Colors.grey.shade900,
      dialogBackgroundColor: Colors.grey.shade900,
      splashColor: Colors.transparent,
      backgroundColor: Colors.black,
      unselectedWidgetColor: Colors.black12,
      dividerColor: UiColors.dividerDark,
      disabledColor: Colors.grey.shade800,
      iconTheme: IconThemeData(color: Colors.white),
      bottomAppBarColor: Colors.grey.shade900,
      cupertinoOverrideTheme: c.CupertinoThemeData(
        primaryColor: Colors.white,
        barBackgroundColor: Colors.grey.shade900,
        textTheme: const c.CupertinoTextThemeData(
          textStyle: const TextStyle(
            color: Colors.white,
            fontFamily: fontFamily,
          ),
          tabLabelTextStyle: const TextStyle(
            fontSize: 13,
            fontFamily: fontFamily,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        color: Colors.black,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: UiColors.primaryColorDark,
        selectionHandleColor: UiColors.primaryColorDark,
        selectionColor: Colors.grey.shade400,
      ),
      textTheme: TextTheme(
        headline4: TextStyle(
          letterSpacing: -1,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        bodyText2: TextStyle(
          color: Colors.grey.shade200,
          fontWeight: FontWeight.normal,
        ),
        caption: TextStyle(
          color: Colors.grey.shade400,
          fontWeight: FontWeight.normal,
        ),
      ),
      buttonTheme: ButtonThemeData(
        minWidth: 50,
        buttonColor: UiColors.primaryColorDark,
        splashColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: UiColors.primaryColorDark,
          textStyle: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.all(14),
          side: BorderSide(color: UiColors.primaryColorDark.withOpacity(0.7)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: UiColors.primaryColorDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.grey.shade800,
        hintStyle: TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        border: OutlineInputBorder(
          borderRadius: AppTheme.formBorderRadius,
          borderSide: BorderSide(color: UiColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppTheme.formBorderRadius,
          borderSide: BorderSide(color: UiColors.borderDark),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppTheme.formBorderRadius,
          borderSide: BorderSide(color: UiColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppTheme.formBorderRadius,
          borderSide: BorderSide(width: 2, color: Colors.white),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppTheme.formBorderRadius,
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppTheme.formBorderRadius,
          borderSide: BorderSide(width: 2, color: Colors.red),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
    );
  }
}
