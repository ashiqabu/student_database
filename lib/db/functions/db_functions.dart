import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import '../model/data_model.dart';

ValueNotifier<List<StudentModel>> studentListNotifier = ValueNotifier([]);

Future<void> addstudent(StudentModel value) async {
  final studentDB = await Hive.openBox<StudentModel>('studentDb');
  value.id = await studentDB.add(value);
  studentDB.put(value.id, value);
  studentListNotifier.value.add(value);
  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  studentListNotifier.notifyListeners();
}

Future<void> getstudent() async {
  final studentDB = await Hive.openBox<StudentModel>('studentDb');
  studentListNotifier.value.clear();
  studentListNotifier.value.addAll(studentDB.values);
  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  studentListNotifier.notifyListeners();
}

Future<void> delete(int id) async {
  final studentDB = await Hive.openBox<StudentModel>('studentDb');
  await studentDB.deleteAt(id);
  // await studentDB.delete(id);
  getstudent();
}

Future<void> editStudent(int id, StudentModel st) async {
  final studentDb = await Hive.openBox<StudentModel>('studentDb');
  await studentDb.put(id, st);
  getstudent();
}

