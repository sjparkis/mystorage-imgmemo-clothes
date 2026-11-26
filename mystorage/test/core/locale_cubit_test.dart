import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mystorage/core/locale_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocaleCubit', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('초기 state는 ko', () {
      final cubit = LocaleCubit();
      expect(cubit.state, const Locale('ko'));
      cubit.close();
    });

    test('저장된 locale ko 로드', () async {
      SharedPreferences.setMockInitialValues({'locale': 'ko'});
      final cubit = LocaleCubit();
      await cubit.load();
      expect(cubit.state, const Locale('ko'));
      cubit.close();
    });

    test('저장된 locale en 로드', () async {
      SharedPreferences.setMockInitialValues({'locale': 'en'});
      final cubit = LocaleCubit();
      await cubit.load();
      expect(cubit.state, const Locale('en'));
      cubit.close();
    });

    test('setLocale은 SharedPreferences에 저장하고 state 변경', () async {
      final cubit = LocaleCubit();
      await cubit.setLocale(const Locale('en'));
      expect(cubit.state, const Locale('en'));
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('locale'), 'en');
      cubit.close();
    });

    test('setLocale ko로 되돌리기', () async {
      SharedPreferences.setMockInitialValues({'locale': 'en'});
      final cubit = LocaleCubit();
      await cubit.load();
      await cubit.setLocale(const Locale('ko'));
      expect(cubit.state, const Locale('ko'));
      cubit.close();
    });
  });
}
