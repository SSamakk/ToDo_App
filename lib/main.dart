import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/home/TaskList/EditTask.dart';
import 'package:todo/home/homescreen.dart';
import 'package:todo/myTheme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo/providers/AppProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // for offline usage
  await FirebaseFirestore.instance.disableNetwork();

  // The default value is 40 MB. The threshold must be set to at least 1 MB,
  // and can be set to Settings.CACHE_SIZE_UNLIMITED to disable garbage collection.
  FirebaseFirestore.instance.settings =
      const Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);

  // for provider
  runApp(
    ChangeNotifierProvider(
      child: MyApp(),
      create: (context) => AppConfigProvider(),
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
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName : (context) => HomeScreen(),
        EditTask.routeName : (context) => EditTask(),
      },
      debugShowCheckedModeBanner: false,

      /// theme
      theme: provider.isDark()
          ? MyTheme.darkMode
          : MyTheme.lightMode ,

      /// Language
      locale: Locale(provider.appLanguage),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
