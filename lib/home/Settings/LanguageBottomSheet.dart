import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../myTheme.dart';
import '../../providers/AppProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class LanguageBottomSheet extends StatefulWidget {

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);

    return Container(
      padding: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.2,
      color: provider.isDark()
          ? MyTheme.primaryDark
          : MyTheme.whiteColor,
      child: Column(
        children: [
          /// en
          InkWell(
            onTap: () {
              provider.changeLanguage('en');
            },
            child: provider.isEnglish()
                ? getSelectedWidget(AppLocalizations.of(context)!.en)
                : getUnselectedWidget(AppLocalizations.of(context)!.en, provider)
          ),

          /// ar
          InkWell(
              onTap: () {
                provider.changeLanguage('ar');
              },
              child: provider.isEnglish()
                  ? getUnselectedWidget(AppLocalizations.of(context)!.ar, provider)
                  : getSelectedWidget(AppLocalizations.of(context)!.ar)
          ),
        ],
      ),
    );
  }

  Widget getSelectedWidget(String text) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Icon(
            Icons.check_box,
            color: MyTheme.primaryApp,
          ),
        ],
      ),
    );
  }

  Widget getUnselectedWidget(String text, provider) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: provider.isDark()
                  ? MyTheme.whiteColor
                  : MyTheme.blackColor,
            ),
          ),
          Icon(
            Icons.check_box_outline_blank,
            color: provider.isDark()
                ? MyTheme.whiteColor
                : MyTheme.blackColor,
          ),
        ],
      ),
    );
  }
}
