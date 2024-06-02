import 'package:hive/hive.dart';
import 'package:taskati_app/features/add-task/data/task_model.dart';

class AppLocalStorage {
  static final box = Hive.box('user');
  static final taskBox = Hive.box<TaskModel>('task');

  static void cachData({required key, required value}) {
    box.put(key, value);
  }

  static getCachData({required String key}) {
    return box.get(key);
  }

  static void cachTask({required key, required TaskModel value}) {
    taskBox.put(key, value);
  }

  static TaskModel? getCachTask(key) {
    return taskBox.get(key);
  }

  static void deleteTask({required key}) {
    taskBox.delete(key);
  }
}
