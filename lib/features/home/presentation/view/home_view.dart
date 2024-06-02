import 'dart:io';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:taskati_app/core/function/routing.dart';
import 'package:taskati_app/core/services/local_storage.dart';
import 'package:taskati_app/core/utils/colors.dart';
import 'package:taskati_app/core/utils/text_style.dart';
import 'package:taskati_app/core/widgets/customButton.dart';
import 'package:taskati_app/features/add-task/data/task_model.dart';
import 'package:taskati_app/features/add-task/presentation/view/add_view.dart';
import 'package:taskati_app/features/edit-task/presentation/view/edit.dart';
import 'package:taskati_app/features/profile/presentation/view/profile.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var _selectedValue = DateFormat('dd/MM/yyyy').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Gap(55),
            ValueListenableBuilder(
              valueListenable: Hive.box('user').listenable(),
              builder: (BuildContext context, value, Widget? child) {
                return Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          'Hello,${AppLocalStorage.getCachData(key: 'name').toString().split(' ').first}',
                          style:
                              getTextStyle(context, color: AppColoes.primary),
                        ),
                        Text('Have A Nice Day.',
                            style: getBodyStyle(context, fontSize: 12)),
                      ],
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        navigatorTo(context, const ProfileView());
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: FileImage(
                            File(AppLocalStorage.getCachData(key: 'image'))),
                      ),
                    ),
                  ],
                );
              },
            ),
            const Gap(10),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMMd().format(DateTime.now()),
                      style: getBodyStyle(context, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Today',
                      style: getBodyStyle(context, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Spacer(),
                CustomButton(
                  onPressed: () {
                    navigatorTo(context, const AddTask());
                  },
                  text: '+ Add Task',
                  width: 120,
                )
              ],
            ),
            const Gap(20),
            DatePicker(
              height: 100,
              DateTime.now(),
              initialSelectedDate: DateTime.now(),
              selectionColor: AppColoes.primary,
              selectedTextColor: Colors.white,
              dayTextStyle: getBodyStyle(context),
              dateTextStyle: getBodyStyle(context),
              monthTextStyle: getSmallStyle(context),
              onDateChange: (date) {
                // New date selected
                setState(() {
                  _selectedValue = DateFormat('dd/MM/yyyy').format(date);
                });
              },
            ),
            Expanded(
                child: ValueListenableBuilder<Box<TaskModel>>(
              valueListenable: Hive.box<TaskModel>('task').listenable(),
              builder: (context, value, child) {
                List<TaskModel> tasks = [];

                for (var element in value.values) {
                  if (_selectedValue == element.date) {
                    tasks.add(element);
                  }
                }

                return tasks.isNotEmpty
                    ? ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: UniqueKey(),
                            background: Container(
                              margin: const EdgeInsets.only(top: 10),
                              color: AppColoes.green,
                              child: Row(
                                children: [
                                  Icon(Icons.check_rounded,
                                      color: AppColoes.white),
                                  Text(
                                    'complete',
                                    style: getBodyStyle(context,
                                        color: AppColoes.white),
                                  )
                                ],
                              ),
                            ),
                            secondaryBackground: Container(
                              margin: const EdgeInsets.only(top: 10),
                              color: AppColoes.red,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.delete, color: AppColoes.white),
                                  Text(
                                    'delete',
                                    style: getBodyStyle(context,
                                        color: AppColoes.white),
                                  )
                                ],
                              ),
                            ),
                            onDismissed: (direction) {
                              if (direction == DismissDirection.startToEnd) {
                                AppLocalStorage.cachTask(
                                    key: tasks[index].id,
                                    value: TaskModel(true,
                                        id: tasks[index].id,
                                        title: tasks[index].title,
                                        note: tasks[index].note,
                                        date: tasks[index].date,
                                        startTime: tasks[index].startTime,
                                        endTime: tasks[index].endTime,
                                        color: tasks[index].color));
                              } else {
                                AppLocalStorage.deleteTask(
                                    key: tasks[index].id);
                              }
                            },
                            child: TaskItem(
                              model: tasks[index],
                            ),
                          );
                        },
                      )
                    : Lottie.asset('assets/images/empty.json');
              },
            )),
          ],
        ),
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key,
    required this.model,
  });
  final TaskModel model;
  @override
  Widget build(BuildContext context) {
    return model.isComplete
        ? Stack(children: [
            GestureDetector(
              onTap: () {
                navigatorTo(context, EditTask(taskModel: model));
              },
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: model.color == 0
                        ? AppColoes.primary
                        : model.color == 1
                            ? AppColoes.red
                            : AppColoes.orange),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            model.title,
                            style: getBodyStyle(context,
                                color: AppColoes.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const Gap(8),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 20,
                                color: AppColoes.white,
                              ),
                              const Gap(10),
                              Text(
                                '${model.startTime} : ${model.endTime}',
                                style: getSmallStyle(context,
                                    color: AppColoes.white),
                              ),
                            ],
                          ),
                          const Gap(8),
                          SizedBox(
                            width: 250,
                            child: Text(
                              model.note,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  getBodyStyle(context, color: AppColoes.white),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 0.5,
                      height: 70,
                      color: AppColoes.white,
                    ),
                    const Gap(5),
                    RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        model.isComplete ? 'COMPLETED' : 'TODO',
                        style: getBodyStyle(context,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: model.isComplete
                                ? AppColoes.green
                                : AppColoes.white),
                      ),
                    ),
                    const Gap(5),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                navigatorTo(context, EditTask(taskModel: model));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15)),
                ),
                margin: const EdgeInsets.only(top: 10),
                width: 332,
                height: 100,
              ),
            ),
          ])
        : GestureDetector(
            onTap: () {
              navigatorTo(context, EditTask(taskModel: model));
            },
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: model.color == 0
                      ? AppColoes.primary
                      : model.color == 1
                          ? AppColoes.red
                          : AppColoes.orange),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          model.title,
                          style: getBodyStyle(context,
                              color: AppColoes.white,
                              fontWeight: FontWeight.bold),
                        ),
                        const Gap(8),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 20,
                              color: AppColoes.white,
                            ),
                            const Gap(10),
                            Text(
                              '${model.startTime} : ${model.endTime}',
                              style: getSmallStyle(context,
                                  color: AppColoes.white),
                            ),
                          ],
                        ),
                        const Gap(8),
                        SizedBox(
                          width: 250,
                          child: Text(
                            model.note,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                getBodyStyle(context, color: AppColoes.white),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 0.5,
                    height: 70,
                    color: AppColoes.white,
                  ),
                  const Gap(5),
                  RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      model.isComplete ? 'COMPLETED' : 'TODO',
                      style: getBodyStyle(context,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: model.isComplete
                              ? AppColoes.green
                              : AppColoes.white),
                    ),
                  ),
                  const Gap(5),
                ],
              ),
            ),
          );
  }
}
