import 'dart:io';
import 'package:database_1/db/providers/student_provider.dart';
import 'package:database_1/screens/addstudent.dart';
import 'package:database_1/screens/profile.dart';
import 'package:database_1/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/functions/db_functions.dart';
import 'edit.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<ProviderForStudent>(context);
    studentProvider.getStudent();
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
              .push(MaterialPageRoute(builder: (ctx) => AddStudent()));
        },
        child: const Icon(Icons.add),
      ),
      backgroundColor: const Color.fromARGB(255, 237, 234, 233),
      body: SafeArea(
          child: Column(
        children: [
          Consumer<ProviderForStudent>(
              builder: (context, value, child) => value.students.isNotEmpty
                  ? Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return Flex(direction: Axis.vertical, children: [
                            ListTile(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (ctx) {
                                  return ProfileScreen(index: index);
                                }));
                              },
                              leading: CircleAvatar(
                                backgroundImage: FileImage(
                                    File(value.students[index].profile)),
                              ),
                              title: Text(value.students[index].name),
                              subtitle: Text(value.students[index].age),
                              trailing: FittedBox(
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return EditStudent(index: index);
                                        }));
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showAlert(context, index, value);
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color:
                                            Color.fromARGB(255, 231, 132, 125),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]);
                        },
                        separatorBuilder: (ctx, index) {
                          return const Divider();
                        },
                        itemCount: value.students.length,
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Center(
                          child: Text(
                        'No items to Display',
                        style: TextStyle(fontSize: 15),
                      )),
                    ))
        ],
      )),
    );
  }

  void showAlert(BuildContext context, int index, dynamic value) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              'Do you want to delete ${value.students[index].name}',
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
