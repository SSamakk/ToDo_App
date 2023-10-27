import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../myTheme.dart';
import '../../providers/AppProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ThemeBottomSheet extends StatefulWidget {

  @override
  State<ThemeBottomSheet> createState() => _ThemeBottomSheetState();
}

class _ThemeBottomSheetState extends State<ThemeBottomSheet> {

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
          /// light
          Expanded(
            child: InkWell(
            onTap: () {
              provider.changeTheme(ThemeMode.light);
            },
            child: provider.isDark()
                ? getUnselectedWidget(AppLocalizations.of(context)!.light, provider)
                : getSelectedWidget(AppLocalizations.of(context)!.light),
          ),
          ),

          /// ar
          Expanded(
            child: InkWell(
                onTap: () {
                  provider.changeTheme(ThemeMode.dark);
                },
                child: provider.isDark()
                    ? getSelectedWidget(AppLocalizations.of(context)!.dark)
                    : getUnselectedWidget(AppLocalizations.of(context)!.dark, provider),
            ),
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
