import 'package:database_1/db/model/data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class ProviderForStudent extends ChangeNotifier {
  List<StudentModel> students = [];

  Future<void> addStudent(StudentModel student) async {
    final studentDB = await Hive.openBox<StudentModel>('studentDb');
    students.add(student);
    await studentDB.add(student);
    notifyListeners();
  }

  Future<void> getStudent() async {
    final studentDB = await Hive.openBox<StudentModel>('studentDb');
    students.clear();
    students.addAll(studentDB.values);
    notifyListeners();
  }

  Future<void> deleteStudent(int index) async {
    final studentDB = await Hive.openBox<StudentModel>('studentDb');
    await studentDB.deleteAt(index);
    getStudent();
  }

  Future<void> editStudent(int index, StudentModel student) async {
    final studentDB = await Hive.openBox<StudentModel>('studentDb');
    await studentDB.putAt(index, student);
    getStudent();
    notifyListeners();
  }
}
