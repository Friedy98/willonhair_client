import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../color_constants.dart';
import '../../common/ui.dart';
import '../models/address_model.dart';
import '../models/setting_model.dart';

class SettingsService extends GetxService {
  final setting = Setting().obs;
  final address = Address().obs;
  GetStorage _box;

  Future<SettingsService> init() async {
    address.listen((Address _address) {
      _box.write('current_address', _address.toJson());
    });
    //setting.value = await _settingsRepo.get();
    //setting.value.modules = await _settingsRepo.getModules();
    //await getAddress();
    return this;
  }

  ThemeData getLightTheme() {
    return ThemeData(
        primaryColor: Colors.white,
        floatingActionButtonTheme: FloatingActionButtonThemeData(elevation: 0, foregroundColor: Colors.white),
        brightness: Brightness.light,
        dividerColor: Ui.parseColor(setting.value.accentColor, opacity: 0.1),
        focusColor: inactive,
        //Ui.parseColor(setting.value.accentColor),
        hintColor: Ui.parseColor(setting.value.secondColor),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(primary: Ui.parseColor(setting.value.mainColor)),
        ),
        colorScheme: ColorScheme.light(
          primary: pink,
          secondary: interfaceColor,
        ),
        textTheme: GoogleFonts.getTextTheme(
          'Poppins',
          TextTheme(
            headline6: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: interfaceColor, height: 1.3),
            headline5: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: interfaceColor, height: 1.3),
            headline4: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: buttonColor, height: 1.3),
            headline3: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: interfaceColor, height: 1.3),
            headline2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w700, color: buttonColor, height: 1.4),
            headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300, color: interfaceColor, height: 1.4),
            subtitle2: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600, color: interfaceColor, height: 1.2),
            subtitle1: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400, color: pink, height: 1.2),
            bodyText2: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600, color: interfaceColor, height: 1.2),
            bodyText1: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: interfaceColor, height: 1.2),
            caption: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300, color: Ui.parseColor(setting.value.accentColor), height: 1.2),
          ),

        ));
  }

  ThemeData getDarkTheme() {
    return ThemeData(
        primaryColor: Color(0xFF252525),
        floatingActionButtonTheme: FloatingActionButtonThemeData(elevation: 0),
        scaffoldBackgroundColor: Color(0xFF2C2C2C),
        brightness: Brightness.dark,
        dividerColor: Ui.parseColor(setting.value.accentDarkColor, opacity: 0.1),
        focusColor: Ui.parseColor(setting.value.accentDarkColor),
        hintColor: Ui.parseColor(setting.value.secondDarkColor),
        toggleableActiveColor: Ui.parseColor(setting.value.mainDarkColor),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(primary: Ui.parseColor(setting.value.mainColor)),
        ),
        colorScheme: ColorScheme.dark(
          primary: pink,
          secondary: interfaceColor,
        ),
        textTheme: GoogleFonts.getTextTheme(
            'Poppins',
            TextTheme(
              headline6: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: interfaceColor, height: 1.3),
              headline5: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: interfaceColor, height: 1.3),
              headline4: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: buttonColor, height: 1.3),
              headline3: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: interfaceColor, height: 1.3),
              headline2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w700, color: buttonColor, height: 1.4),
              headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300, color: interfaceColor, height: 1.4),
              subtitle2: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600, color: interfaceColor, height: 1.2),
              subtitle1: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400, color: pink, height: 1.2),
              bodyText2: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600, color: interfaceColor, height: 1.2),
              bodyText1: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: interfaceColor, height: 1.2),
              caption: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300, color: Ui.parseColor(setting.value.accentDarkColor), height: 1.2),
            )));
  }

  /*String _getLocale() {
    String _locale = GetStorage().read<String>('language');
    if (_locale == null || _locale.isEmpty) {
      _locale = setting.value.mobileLanguage;
    }
    return _locale;
  }*/

  ThemeMode getThemeMode() {
    String _themeMode = GetStorage().read<String>('theme_mode');
    switch (_themeMode) {
      case 'ThemeMode.light':
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle.light.copyWith(systemNavigationBarColor: Colors.white),
        );
        return ThemeMode.light;
      case 'ThemeMode.dark':
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle.dark.copyWith(systemNavigationBarColor: Colors.black87),
        );
        return ThemeMode.dark;
      case 'ThemeMode.system':
        return ThemeMode.system;
      default:
        if (setting.value.defaultTheme == "dark") {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.dark.copyWith(systemNavigationBarColor: Colors.black87),
          );
          return ThemeMode.dark;
        } else {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.light.copyWith(systemNavigationBarColor: Colors.white),
          );
          return ThemeMode.light;
        }
    }
  }
}
