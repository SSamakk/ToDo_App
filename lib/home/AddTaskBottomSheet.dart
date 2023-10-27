import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/dialogUtils.dart';
import 'package:todo/firebaseUtils.dart';
import 'package:todo/model/task.dart';
import 'package:todo/myTheme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo/providers/authProvider.dart';
import '../providers/AppProvider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTaskBottomSheet extends StatefulWidget {
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  DateTime selectedDate = DateTime.now();
  String title = '';
  String description = '';
  final formKey = GlobalKey<FormState>();
  late AppConfigProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppConfigProvider>(context);
    String formattedDate =
        DateFormat.yMMMMd(provider.appLanguage).format(selectedDate);

    return Container(
      color: provider.isDark()
          ? MyTheme.primaryDark
          : MyTheme.whiteColor,
      padding: EdgeInsets.all(15),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// 'add new task' title
          Text(AppLocalizations.of(context)!.add_new_task,
            style: provider.isDark()
                ? MyTheme.darkMode.textTheme.titleMedium
                : MyTheme.lightMode.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),

          /// input form fields
          Form(
            key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// task title field
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.12,
                    child: TextFormField(
                      decoration: InputDecoration(
                        label: Text(AppLocalizations.of(context)!.task_title,
                            style: provider.isDark()
                                ? MyTheme.darkMode.textTheme.titleSmall
                                : MyTheme.lightMode.textTheme.titleSmall,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.enter_task_title;
                        }
                        return null;
                      },
                      onChanged: (value) {
                        title = value;
                      },
                    ),
                  ),

                  /// task description field
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.12,
                    child: TextFormField(
                      decoration: InputDecoration(
                        errorMaxLines: 1,
                        label: Text(AppLocalizations.of(context)!.task_description,
                          style: provider.isDark()
                              ? MyTheme.darkMode.textTheme.titleSmall
                              : MyTheme.lightMode.textTheme.titleSmall,),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.enter_task_description;
                        }
                        return null;
                      },
                      onChanged: (value) {
                        description = value;
                      },
                    ),
                  ),
                ],
              )
          ),

          /// 'select date' title
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height*0.04),
            child: Text(AppLocalizations.of(context)!.select_date,
              style: provider.isDark()
                  ? MyTheme.darkMode.textTheme.titleSmall
                  : MyTheme.lightMode.textTheme.titleSmall,
            ),
          ),

          /// date (clickable)
          InkWell(
            onTap: (){
              showCalendar(provider);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(formattedDate,
                style: provider.isDark()
                    ? MyTheme.darkMode.textTheme.titleSmall
                    : MyTheme.lightMode.textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
            ),
          ),

          /// add button
          Expanded(
              child: SizedBox(height: MediaQuery.of(context).size.height*0.01,)
          ),
          ElevatedButton(
            onPressed: (){
              addTask();
            },
            child: Text(AppLocalizations.of(context)!.add,
              style: provider.isDark()
                  ? MyTheme.darkMode.textTheme.titleMedium?.copyWith(
                          color: MyTheme.primaryDark)
                  : MyTheme.lightMode.textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }

  void showCalendar(provider) async {
    var chosenDate = await showDatePicker(
      locale: Locale(provider.appLanguage),
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if(chosenDate != null){
      selectedDate = chosenDate;
    }
    setState(() {});
  }

  void addTask(){
    if(formKey.currentState?.validate() == true){
      Task task = Task(
          title: title,
          description: description,
          date: selectedDate,
      );

      DialogUtils.showLoading(context, 'Loading...');
      var authProvider = Provider.of<AuthProvider>(context, listen: false);
      // add task to firebase
      FireBaseUtils.addTaskToFireStore(
          task, authProvider.currentUser!.id!).then((value) {
            DialogUtils.hideDialog(context);
            Fluttertoast.showToast(
              msg: "To Do added",
              timeInSecForIosWeb: 2,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Theme.of(context).primaryColor,
              textColor: Colors.white,
              fontSize: 16.0,
            );
      }).timeout(
          const Duration(milliseconds: 50),
          onTimeout: () {
            provider.getAllTasks(authProvider.currentUser!.id!);
            Navigator.pop(context);
          },
      );
    }
  }

}
