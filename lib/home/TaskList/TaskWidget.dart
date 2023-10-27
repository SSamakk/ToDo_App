import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo/firebaseUtils.dart';
import 'package:todo/myTheme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../dialogUtils.dart';
import '../../model/task.dart';
import '../../providers/AppProvider.dart';
import '../../providers/authProvider.dart';
import 'EditTask.dart';

class TaskWidget extends StatefulWidget {
  Task task;
  TaskWidget({required this.task});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {

  // Task task;
  // _TaskWidgetState({required this.task});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.all(15),
      child: Slidable(
        // The start action pane is the one at the left or the top side.
        startActionPane: ActionPane(
          extentRatio: 0.2,
          // A motion is a widget used to control how the pane animates.
          motion: const ScrollMotion(),

          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            // todo: delete task
            SlidableAction(
              onPressed: (context){
                // delete task
                FireBaseUtils.deleteTaskFromFireStore(widget.task,
                    authProvider.currentUser!.id!).then((value) {
                  Fluttertoast.showToast(
                    msg: "To Do deleted",
                    timeInSecForIosWeb: 2,
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }).timeout(
                    const Duration(milliseconds: 50),
                    onTimeout: (){
                        provider.getAllTasks(authProvider.currentUser!.id!);
                    }
                );
              },
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15)
              ),
              backgroundColor: MyTheme.redColor,
              foregroundColor: MyTheme.whiteColor,
              icon: Icons.delete,
              label: AppLocalizations.of(context)!.delete,
            ),
          ],
        ),

        // The child of the Slidable is what the user sees when the
        // component is not dragged.
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: provider.isDark()
                ? MyTheme.primaryDark
                : MyTheme.whiteColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              /// vertical line
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: widget.task.taskDone()
                      ? MyTheme.greenColor
                      : MyTheme.primaryApp,
                ),
                height: 62,
                width: 4,
              ),

              /// text column
              Expanded(
                  child: InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, EditTask.routeName,
                          arguments: widget.task);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// task title
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(widget.task.title ?? '',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: widget.task.taskDone()
                                  ? MyTheme.greenColor
                                  : MyTheme.primaryApp,
                            ),
                          ),
                        ),

                        /// task description
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(widget.task.description ?? '',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: widget.task.taskDone()
                                    ? MyTheme.greenColor
                                    : MyTheme.primaryApp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ),

              /// Icon
              InkWell(
                onTap: (){
                  if(widget.task.isDone == false){
                    widget.task.isDone = true;
                    FireBaseUtils.editTaskFireStore(widget.task,
                        authProvider.currentUser!.id!);
                    setState(() {});
                  }
                },
                child: widget.task.taskDone()
                    ? Text(
                        'DONE',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: MyTheme.greenColor),
                        )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: MyTheme.primaryApp,
                        ),
                        child: const Icon(Icons.check,
                          color: MyTheme.whiteColor,
                          size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
