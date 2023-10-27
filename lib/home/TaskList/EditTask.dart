import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../firebaseUtils.dart';
import '../../model/task.dart';
import '../../myTheme.dart';
import '../../providers/AppProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../providers/authProvider.dart';

class EditTask extends StatefulWidget {
  static const String routeName = 'editTask';

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  late DateTime selectedDate;
  late String title;
  late String description;
  final formKey = GlobalKey<FormState>();
  late AppConfigProvider provider;


  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    final args = ModalRoute.of(context)!.settings.arguments as Task;

    selectedDate = args.date!;
    title = args.title!;
    description = args.description!;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.to_do_list,
            style: provider.isDark()
                ? MyTheme.darkMode.textTheme.titleLarge
                : MyTheme.lightMode.textTheme.titleLarge,
          ),
      ),
      body: Stack(
        children: [
          Container(
            color: MyTheme.primaryApp,
            height: 100,
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: provider.isDark()
                      ? MyTheme.primaryDark
                      : Colors.white,
                ),
                padding: const EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.8,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// 'edit task' title
                    Text(AppLocalizations.of(context)!.edit,
                      style: Theme.of(context).textTheme.titleMedium,
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
                                initialValue: args.title,
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
                                initialValue: args.description,
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

                    /// select date title
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.04),
                      child: Text(AppLocalizations.of(context)!.select_date,
                        style: provider.isDark()
                            ? MyTheme.darkMode.textTheme.titleSmall
                            : MyTheme.lightMode.textTheme.titleSmall,
                      ),
                    ),

                    /// date (clickable)
                    InkWell(
                      onTap: (){
                        showCalendar(provider, args);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text('${DateFormat.yMMMMd(provider.appLanguage).format(args.date!)}',
                          style: provider.isDark()
                              ? MyTheme.darkMode.textTheme.titleSmall
                              : MyTheme.lightMode.textTheme.titleSmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    /// save changes button
                    SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                    ElevatedButton(
                      onPressed: (){
                        editTask(args, authProvider);
                      },
                      child: Text(AppLocalizations.of(context)!.save,
                        style: provider.isDark()
                            ? MyTheme.darkMode.textTheme.titleMedium?.copyWith(
                            color: MyTheme.primaryDark)
                            : MyTheme.lightMode.textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      )
    );
  }

  void showCalendar(provider, Task task) async {
    var chosenDate = await showDatePicker(
      locale: Locale(provider.appLanguage),
      context: context,
      initialDate: task.date!,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if(chosenDate != null){
      selectedDate = chosenDate;
    }
    setState(() {});
  }


  void editTask(Task task, authProvider){
    if(formKey.currentState?.validate() == true){

      task.title = title;
      task.description = description;
      task.date = selectedDate;

      // edit task
      FireBaseUtils.editTaskFireStore(task, authProvider.currentUser!.id!).timeout(
        const Duration(milliseconds: 500),
        onTimeout: () {
          provider.getAllTasks(authProvider.currentUser!.id!);

        }

      );
      Navigator.pop(context);
      // flutter toast
      Fluttertoast.showToast(
        msg: "To Do edited",
        timeInSecForIosWeb: 2,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Theme.of(context).primaryColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

}


