import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final settingsControllerProvider = StateNotifierProvider<SettingsController, SettingsState>((ref) {
  return SettingsController();
});

class SettingsState {
  const SettingsState({required this.themeMode, required this.fontScale, required this.autoLoadImages});

  final String themeMode;
  final double fontScale;
  final bool autoLoadImages;
}

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController()
      : super(const SettingsState(themeMode: 'system', fontScale: 1.0, autoLoadImages: true)) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = SettingsState(
      themeMode: prefs.getString('themeMode') ?? 'system',
      fontScale: prefs.getDouble('fontScale') ?? 1.0,
      autoLoadImages: prefs.getBool('autoLoadImages') ?? true,
    );
  }

  Future<void> updateThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode);
    state = SettingsState(themeMode: mode, fontScale: state.fontScale, autoLoadImages: state.autoLoadImages);
  }

  Future<void> updateFontScale(double scale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontScale', scale);
    state = SettingsState(themeMode: state.themeMode, fontScale: scale, autoLoadImages: state.autoLoadImages);
  }

  Future<void> updateAutoLoadImages(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('autoLoadImages', value);
    state = SettingsState(themeMode: state.themeMode, fontScale: state.fontScale, autoLoadImages: value);
  }
}
