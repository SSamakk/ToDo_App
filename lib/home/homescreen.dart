import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/home/AddTaskBottomSheet.dart';
import 'package:todo/home/Settings/SettingsTab.dart';
import 'package:todo/myTheme.dart';
import 'package:todo/providers/authProvider.dart';
import '../auth/login/LoginScreen.dart';
import '../providers/AppProvider.dart';
import 'TaskList/TaskListTab.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'homeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  List<Widget> tabs = [TaskListTab(), SettingsTab()];

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: selectedIndex == 0
            ? Text(
                '${AppLocalizations.of(context)!.to_do_list} - '
                    '${authProvider.currentUser?.name ?? ''}',
                style: provider.isDark()
                    ? MyTheme.darkMode.textTheme.titleLarge
                    : MyTheme.lightMode.textTheme.titleLarge,
              )
            : Text(
                AppLocalizations.of(context)!.settings,
                style: provider.isDark()
                    ? MyTheme.darkMode.textTheme.titleLarge
                    : MyTheme.lightMode.textTheme.titleLarge,
              ),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(
                    LoginScreen.routeName);
                provider.tasksList = [];
                authProvider.currentUser = null;
              },
              icon: const Icon(Icons.logout)),
        ],
      ),

      /// App Bar (for notch) + navigationBar
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8,
        shape: const CircularNotchedRectangle(),
        color: provider.isDark() ? MyTheme.primaryDark : MyTheme.whiteColor,

        /// Bottom Navigation Bar
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            selectedIndex = index;
            setState(() {});
          },
          items: const [
            // list
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'List',
            ),
            // settings
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddBottomSheet();
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      body: tabs[selectedIndex],
    );
  }

  /// Methods
  showAddBottomSheet() {
    showModalBottomSheet(
        context: context, builder: (context) => AddTaskBottomSheet());
  }
}
