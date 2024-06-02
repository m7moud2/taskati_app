import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:taskati_app/core/theme/themr.dart';
import 'package:taskati_app/features/add-task/data/task_model.dart';
import 'package:taskati_app/features/splash_view.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('user');
  Hive.registerAdapter(TaskModelAdapter());
  await Hive.openBox<TaskModel>('task');
  runApp(const TaskatiApp());
}

class TaskatiApp extends StatelessWidget {
  const TaskatiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('user').listenable(),
      builder: (BuildContext context, box, Widget? child) {
        bool darkMode = box.get('darkMode',defaultValue: false);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: darkMode==true?ThemeMode.dark:ThemeMode.light,
          theme: AppThemes.AppLightTheme,
          darkTheme: AppThemes.AppDarkTheme,
          home: const SplashView(),
        );
      },
    );
  }
}
