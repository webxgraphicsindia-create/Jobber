import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:QuickHire/provider/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Keep this one
import 'PrivacyPolicyScreen.dart';
import 'package:QuickHire/Screens/fragment/Menu/ChangePasswordScreen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';

  final Map<String, String> languageCodeMap = {
    'English': 'en',
    'Hindi': 'hi',
    'Marathi': 'mr',
  };

  final Map<String, String> codeToLanguageMap = {
    'en': 'English',
    'hi': 'Hindi',
    'mr': 'Marathi',
  };

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLangCode = prefs.getString('language_code') ?? 'en';
    setState(() {
      _isDarkMode = prefs.getBool('dark_mode') ?? false;
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _selectedLanguage = codeToLanguageMap[savedLangCode] ?? 'English';
    });

    final provider = Provider.of<LocaleProvider>(context, listen: false);
    provider.setLocale(Locale(savedLangCode));
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      prefs.setBool(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    // Guard against null in case localization isn't ready
    if (s == null) {
      return Scaffold(
        body: Center(child: Text("Loading...")),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(s.settings)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.dark_mode),
                  title: Text(s.darkMode),
                  trailing: Switch(
                    value: _isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        _isDarkMode = value;
                      });
                      _saveSetting('dark_mode', value);
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: Text(s.enableNotifications),
                  trailing: Switch(
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                      _saveSetting('notifications', value);
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(s.language),
                  trailing: DropdownButton<String>(
                    value: _selectedLanguage,
                    items: languageCodeMap.keys.map((lang) {
                      return DropdownMenuItem(
                        value: lang,
                        child: Text(lang),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedLanguage = value!;
                      });
                      final selectedCode = languageCodeMap[value]!;
                      _saveSetting('language_code', selectedCode);
                      final provider = Provider.of<LocaleProvider>(context, listen: false);
                      provider.setLocale(Locale(selectedCode));
                    },
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: Text(s.privacySecurity),
                  subtitle: const Text("Manage your privacy settings"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PrivacyPolicyScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.vpn_key),
                  title: Text(s.changePassword),
                  subtitle: const Text("Update your account password"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ChangePasswordScreen()),
                    );
                  },
                ),
                const Divider(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(s.madeInIndia, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text("${s.version} 1.0.0", style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                const SizedBox(height: 5),
                Text(s.createdBy, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
