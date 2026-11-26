import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  static const _key = 'locale';
  static const _supported = ['ko', 'en'];

  LocaleCubit() : super(const Locale('ko'));

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved != null && _supported.contains(saved)) {
      emit(Locale(saved));
      return;
    }
    final device =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    emit(Locale(_supported.contains(device) ? device : 'ko'));
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);
    emit(locale);
  }
}
