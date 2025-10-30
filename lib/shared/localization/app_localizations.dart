import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [
    Locale('en'),
    Locale('vi'),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'voz.vn',
      'login': 'Login',
      'username': 'Username',
      'password': 'Password',
      'home': 'Home',
      'new': 'New',
      'hot': 'Hot',
      'watched': 'Watched',
      'settings': 'Settings',
      'forums': 'Forums',
      'search': 'Search',
      'retry': 'Retry',
      'notifications': 'Notifications',
    },
    'vi': {
      'appTitle': 'voz.vn',
      'login': 'Đăng nhập',
      'username': 'Tên đăng nhập',
      'password': 'Mật khẩu',
      'home': 'Trang chủ',
      'new': 'Mới',
      'hot': 'Nổi bật',
      'watched': 'Theo dõi',
      'settings': 'Cài đặt',
      'forums': 'Diễn đàn',
      'search': 'Tìm kiếm',
      'retry': 'Thử lại',
      'notifications': 'Thông báo',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? _localizedValues['en']![key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.contains(Locale(locale.languageCode));

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
