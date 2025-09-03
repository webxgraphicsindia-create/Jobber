import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'JsonModels/BookmarkNotifier.dart';
import 'Screens/Auth/SplashScreen.dart';
import 'generated/app_localizations.dart';
import 'provider/locale_provider.dart'; // 🔥 Language provider
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BookmarkNotifier()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()), // 👈 Add language provider
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    return MaterialApp(
      locale: provider.locale,
      supportedLocales: L10n.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate, // Generated localization delegate
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const MySplashscreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}