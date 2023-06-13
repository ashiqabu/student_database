import 'dart:io';
import 'package:database_1/screens/addstudent.dart';
import 'package:database_1/screens/profile.dart';
import 'package:database_1/widgets/search.dart';
import 'package:flutter/material.dart';
import '../db/functions/db_functions.dart';
import '../db/model/data_model.dart';
import 'edit.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    getstudent();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Details',
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: Search());
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => const AddStudent()));
        },
        child: const Icon(Icons.add),
      ),
      backgroundColor: const Color.fromARGB(255, 237, 234, 233),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: studentListNotifier,
              builder: (BuildContext ctx, List<StudentModel> studentList,
                  Widget? child) {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    final data = studentList[index];
                    return ListTile(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (ctx) {
                          return ProfileScreen(index: index);
                        }));
                      },
                      leading: CircleAvatar(
                        backgroundImage: FileImage(File(data.profile)),
                      ),
                      title: Text(data.name),
                      subtitle: Text(data.age),
                      trailing: FittedBox(
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return EditStudent(index: index);
                                }));
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                showAlert(context, index);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Color.fromARGB(255, 231, 132, 125),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (ctx, index) {
                    return const Divider();
                  },
                  itemCount: studentList.length,
                );
              },
            ),
          )
        ],
      )),
    );
  }

  void showAlert(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              'Do you want to delete ${studentListNotifier.value[index].name}',
              style: const TextStyle(color: Colors.red),
            ),
            content: const Text(
                'All the related datas will be cleared from the database'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text("No")),
              TextButton(
                  onPressed: () {
                    delete(index);
                    Navigator.of(ctx).pop();
                  },
                  child: const Text("Yes"))
            ],
          );
        });
  }
}
