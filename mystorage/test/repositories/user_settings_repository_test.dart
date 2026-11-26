import 'package:flutter_test/flutter_test.dart';
import 'package:mystorage/data/repositories/user_settings_repository.dart';

void main() {
  test('UserSettingsRepository is importable', () {
    expect(UserSettingsRepository.new, isNotNull);
  });

  test('UserSettingsRepository.defaultSettings returns correct defaults', () {
    final defaults = UserSettingsRepository.defaultSettings;
    expect(defaults['show_trash'], true);
    expect(defaults['show_sale'], true);
  });
}
