import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LocaleProvider() {
    _loadSavedLocale();
  }

  void setLocale(Locale locale) {
    if (!L10n.supportedLocales.contains(locale)) return;
    _locale = locale;
    _saveLocale(locale.languageCode);
    notifyListeners();
  }

  void _saveLocale(String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', code);
  }

  void _loadSavedLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? code = prefs.getString('language_code') ?? 'en';
    _locale = Locale(code);
    notifyListeners();
  }

  void clearLocale() {
    _locale = const Locale('en');
    notifyListeners();
  }
}

class L10n {
  static const supportedLocales = [
    Locale('en'),
    Locale('hi'),
    Locale('mr'),
  ];
}
