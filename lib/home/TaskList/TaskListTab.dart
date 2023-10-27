// import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/firebaseUtils.dart';
import 'package:todo/home/TaskList/TaskWidget.dart';
import 'package:todo/myTheme.dart';
import '../../model/task.dart';
import '../../providers/AppProvider.dart';
import '../../providers/authProvider.dart';

class TaskListTab extends StatefulWidget {
  @override
  State<TaskListTab> createState() => _TaskListTabState();
}

class _TaskListTabState extends State<TaskListTab> {

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    if(provider.tasksList.isEmpty){
      provider.getAllTasks(authProvider.currentUser!.id!);
    }

    return Stack(
      children: [
        Container(
          color: MyTheme.primaryApp,
          height: 100,
        ),
        Column(
          children: [
            /// Calendar at the top
            EasyDateTimeLine(
              initialDate: DateTime.now(), /// 30:30 session 10 ??
              onDateChange: (selectedDate) {
                //`selectedDate` the new date selected.
                provider.changeDate(
                    selectedDate,
                    authProvider.currentUser!.id!
                );
              },

              /// header
              headerProps: EasyHeaderProps(
                monthPickerType: MonthPickerType.switcher,
                selectedDateFormat: SelectedDateFormat.fullDateDayAsStrMY,
                monthStyle: TextStyle(
                    color: Colors.black,
                  fontWeight: FontWeight.w600,
                    fontSize: 20,
                  locale: Locale(provider.appLanguage),
                ),
              ),

              /// days
              dayProps: EasyDayProps(
                dayStructure: DayStructure.dayStrDayNum,
                height: 79,
                /// styling non-chosen date
                inactiveDayStyle: DayStyle(
                  dayNumStyle: TextStyle(
                      color: provider.isDark()
                          ? MyTheme.whiteColor
                          : MyTheme.blackColor,
                      fontSize: 18
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    color: provider.isDark()
                        ? Theme.of(context).primaryColor
                        : MyTheme.whiteColor,
                  ),
                ),

                /// styling chosen date
                activeDayStyle: DayStyle(
                  dayNumStyle: const TextStyle(
                      color: MyTheme.primaryApp,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                  dayStrStyle: const TextStyle(
                      color: MyTheme.primaryApp,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    color: provider.isDark()
                        ? Theme.of(context).primaryColor
                        : MyTheme.whiteColor,
                  ),
                ),

                /// styling today's date
                todayStyle: DayStyle(
                  dayNumStyle: TextStyle(
                    color: provider.isDark()
                      ? MyTheme.whiteColor
                      : MyTheme.blackColor,
                    fontSize: 18
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    color: provider.isDark()
                        ? Theme.of(context).primaryColor
                        : MyTheme.whiteColor,
                    border: Border.all(color: MyTheme.primaryApp, width: 2),
                  ),
                ),
              ),

              /// calendar language
              locale: provider.appLanguage,
            ),
            const SizedBox(height: 10,),
            // another calendar Style
            // CalendarTimeline(
            //   initialDate: DateTime.now(),
            //   firstDate: DateTime.now().subtract(Duration(days: 365)),
            //   lastDate: DateTime.now().add(Duration(days: 365)),
            //   onDateSelected: (date) {},
            //   leftMargin: 20,
            //   monthColor: Colors.blueGrey,
            //   dayColor: MyTheme.blackColor,
            //   activeDayColor: MyTheme.primaryApp,
            //   activeBackgroundDayColor: MyTheme.whiteColor,
            //   dotsColor: MyTheme.whiteColor,
            //   selectableDayPredicate: (date) => true,
            //   locale: provider.appLanguage,
            // ),

            /// tasks list
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return TaskWidget(task: provider.tasksList[index],);
                },
                itemCount: provider.tasksList.length,
              ),
            ),
          ],
        ),
      ],
    );
  }


}
