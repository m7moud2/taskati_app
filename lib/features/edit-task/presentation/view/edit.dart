import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:taskati_app/core/services/local_storage.dart';
import 'package:taskati_app/core/utils/colors.dart';
import 'package:taskati_app/core/utils/text_style.dart';
import 'package:taskati_app/core/widgets/customButton.dart';
import 'package:taskati_app/core/widgets/custom_text_from_field.dart';
import 'package:taskati_app/features/add-task/data/task_model.dart';

// ignore: must_be_immutable
class EditTask extends StatefulWidget {
  EditTask({super.key, required this.taskModel});
  TaskModel taskModel;
  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  var date;
  var startTime;
  var endTime;
  int color = 0;
  @override
  void initState() {
    super.initState();
    titleController.text = widget.taskModel.title;
    noteController.text = widget.taskModel.note;
    date = widget.taskModel.date;
    startTime = widget.taskModel.startTime;
    endTime = widget.taskModel.endTime;
    color = widget.taskModel.color;
  }

  var key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //var modeTheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppColoes.primary,
        centerTitle: true,
        title: Text(
          'Edit Task',
          style: getTextStyle(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
            key: key,
            child: Column(
              children: [
                CustomTextFromField(
                  validator: (deta) {
                    return deta!.isEmpty
                        ? 'Enter your title'
                        : deta.length > 25
                            ? 'The title field cannot exceed 25 characters in length'
                            : null;
                  },
                  text: 'Title',
                  controller: titleController,
                ),
                const Gap(20),
                CustomTextFromField(
                  validator: (deta) {
                    if (deta!.isEmpty) {
                      return 'Enter your not';
                    }
                    return null;
                  },
                  text: 'Note',
                  maxLines: 4,
                  controller: noteController,
                  hint: noteController.text,
                ),
                CustomTextFromField(
                  text: 'Date',
                  hint: date,
                  widget: const Icon(Icons.calendar_month_outlined),
                  readOnly: true,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          date = DateFormat('dd/MM/yyyy').format(value);
                        });
                      }
                    });
                  },
                ),
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomTextFromField(
                      readOnly: true,
                      widget: const Icon(Icons.access_time),
                      text: 'Start Time',
                      hint: startTime,
                      width: 170,
                      onTap: () {
                        showTimePicker(
                                context: context, initialTime: TimeOfDay.now())
                            .then((value) {
                          if (value != null) {
                            setState(() {
                              startTime = value.format(context);
                            });
                          }
                        });
                      },
                    ),
                    CustomTextFromField(
                      readOnly: true,
                      widget: const Icon(Icons.access_time),
                      text: 'End Time',
                      width: 170,
                      onTap: () {
                        showTimePicker(
                                context: context, initialTime: TimeOfDay.now())
                            .then((value) {
                          if (value != null) {
                            setState(() {
                              endTime = value.format(context);
                            });
                          }
                        });
                      },
                    ),
                  ],
                ),
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Coloe',
                          style: getBodyStyle(context,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: List<Widget>.generate(3, (index) {
                            return Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    color = index;
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: index == 0
                                      ? AppColoes.primary
                                      : index == 1
                                          ? AppColoes.red
                                          : AppColoes.orange,
                                  child: color == index
                                      ? Icon(
                                          Icons.check_rounded,
                                          color: AppColoes.white,
                                        )
                                      : const SizedBox(),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                    CustomButton(
                        onPressed: () {
                          if (key.currentState!.validate()) {
                            AppLocalStorage.cachTask(
                                key: widget.taskModel.id,
                                value: TaskModel(widget.taskModel.isComplete,
                                    id: widget.taskModel.id,
                                    title: titleController.text,
                                    note: noteController.text,
                                    date: date,
                                    startTime: startTime,
                                    endTime: endTime,
                                    color: color));
                            Navigator.pop(context);
                          }
                        },
                        width: 130,
                        text: 'Update Task'),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
