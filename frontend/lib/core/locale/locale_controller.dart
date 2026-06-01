import 'package:flutter/material.dart';

class LocaleController extends ValueNotifier<Locale> {
  LocaleController._() : super(const Locale('en'));
  static final instance = LocaleController._();

  void setLocale(Locale locale) => value = locale;
}
