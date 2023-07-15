import 'dart:io';

import 'package:database_1/db/functions/db_functions.dart';
import 'package:database_1/db/model/data_model.dart';
import 'package:database_1/screens/profile.dart';
import 'package:flutter/material.dart';

class Search extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: ValueListenableBuilder(
        valueListenable: studentListNotifier,
        builder: (BuildContext context, List<StudentModel> studentlist,
            Widget? child) {
          return ListView.builder(
              itemBuilder: (context, index) {
                final data = studentlist[index];
                if (data.name
                    .toLowerCase()
                    .contains(query.toLowerCase().trim())) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (ctx) {
                            return ProfileScreen(
                              index: index,
                            );
                          }));
                        },
                        leading: CircleAvatar(
                          radius: 40,
                          backgroundImage: FileImage(
                            File(data.profile),
                          ),
                        ),
                        
                        title: Text(data.name,
                            style: const TextStyle(fontSize: 20)),
                      ),
                      const Divider()
                    ],
                  );
                } else {
                  return const Text('');
                }
              },
              itemCount: studentlist.length);
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: ValueListenableBuilder(
        valueListenable: studentListNotifier,
        builder: (BuildContext context, List<StudentModel> studentlist,
            Widget? child) {
          return ListView.builder(
              itemBuilder: (context, index) {
                final data = studentlist[index];
                if (data.name
                    .toLowerCase()
                    .contains(query.toLowerCase().trim())) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (ctx) {
                            return ProfileScreen(
                              index: index,
                            );
                          }));
                        },
                        leading: CircleAvatar(
                          radius: 40,
                          backgroundImage: FileImage(
                            File(data.profile),
                          ),
                        ),
                        title: Text(data.name,
                            style: const TextStyle(fontSize: 20)),
                      ),
                      const Divider()
                    ],
                  );
                } else {
                  return const Text('');
                }
              },
              itemCount: studentlist.length);
        },
      ),
    );
  }
}
