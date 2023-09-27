import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../myTheme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../providers/AppProvider.dart';
import 'LanguageBottomSheet.dart';
import 'ThemeBottomSheet.dart';


class SettingsTab extends StatefulWidget {

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: MyTheme.primaryApp,
          height: 100,
        ),

        /// Language
        Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.07),
          child: Text(AppLocalizations.of(context)!.language,
            style: provider.isDark()
                ? MyTheme.darkMode.textTheme.titleMedium
                : MyTheme.lightMode.textTheme.titleMedium,),
        ),
        InkWell(
          onTap: (){
            showLanguageBottomSheet();
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: MyTheme.primaryApp, width: 1),
              color: provider.isDark()
                  ? MyTheme.primaryDark
                  : MyTheme.whiteColor,
            ),
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width*0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(provider.isEnglish()
                    ? AppLocalizations.of(context)!.en
                    : AppLocalizations.of(context)!.ar,
                  style: MyTheme.lightMode.textTheme.bodyLarge,),
                Icon(Icons.keyboard_arrow_down,
                  color: MyTheme.primaryApp,),
              ],
            ),
          ),
        ),

        /// Theme
        Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.07),
          child: Text(AppLocalizations.of(context)!.theme,
            style: provider.isDark()
                ? MyTheme.darkMode.textTheme.titleMedium
                : MyTheme.lightMode.textTheme.titleMedium,),
        ),
        InkWell(
          onTap: (){
            showThemeBottomSheet();
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: MyTheme.primaryApp, width: 1),
              color: provider.isDark()
                  ? MyTheme.primaryDark
                  : MyTheme.whiteColor,
            ),
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(provider.isDark()
                    ? AppLocalizations.of(context)!.dark
                    : AppLocalizations.of(context)!.light ,
                  style: MyTheme.lightMode.textTheme.bodyLarge,),
                Icon(Icons.keyboard_arrow_down,
                  color: MyTheme.primaryApp,),
              ],
            ),
          ),
        ),

      ],
    );
  }

  void showLanguageBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) => LanguageBottomSheet()
    );
  }

  void showThemeBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) => ThemeBottomSheet()
    );
  }
}
