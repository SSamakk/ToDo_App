import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/auth/register/RegisterScreen.dart';
import 'package:todo/home/TaskList/EditTask.dart';
import 'package:todo/home/homescreen.dart';
import 'package:todo/myTheme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo/providers/AppProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/providers/authProvider.dart';

import 'auth/login/LoginScreen.dart';


void main() async {
  // firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // for offline usage
  // await FirebaseFirestore.instance.disableNetwork();
  // The default value is 40 MB. The threshold must be set to at least 1 MB,
  // and can be set to Settings.CACHE_SIZE_UNLIMITED to disable garbage collection.
  // FirebaseFirestore.instance.settings =
  //     const Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);

  // preferences
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // for provider
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AppConfigProvider(
              dark: prefs.getBool('darkMode') ?? false,
              english: prefs.getBool('english') ?? true,
            ),
          ),
          ChangeNotifierProvider(
              create: (context) => AuthProvider(),
          ),
        ],
            child: MyApp(),
    )


  );
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);

    return MaterialApp(
      title: 'To DO App',
      initialRoute: LoginScreen.routeName,
      routes: {
        HomeScreen.routeName : (context) => HomeScreen(),
        EditTask.routeName : (context) => EditTask(),
        RegisterScreen.routeName : (context) => RegisterScreen(),
        LoginScreen.routeName : (context) => LoginScreen(),
      },
      debugShowCheckedModeBanner: false,

      /// theme
      themeMode: provider.appTheme,
      theme: MyTheme.lightMode,
      darkTheme: MyTheme.darkMode,

      /// Language
      locale: Locale(provider.appLanguage),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
