import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../db/functions/db_functions.dart';
import '../db/model/data_model.dart';

File? photo;

// ignore: must_be_immutable
class EditStudent extends StatefulWidget {
  int index;
  EditStudent({super.key, required this.index});

  @override
  State<EditStudent> createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  TextEditingController namecntrl = TextEditingController();

  TextEditingController agecntrl = TextEditingController();

  TextEditingController addresscntrl = TextEditingController();

  TextEditingController numbercntrl = TextEditingController();

  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    String name = studentListNotifier.value[widget.index].name;
    namecntrl = TextEditingController(text: name);

    String age = studentListNotifier.value[widget.index].age;
    agecntrl = TextEditingController(text: age);

    String address = studentListNotifier.value[widget.index].address;
    addresscntrl = TextEditingController(text: address);

    String number = studentListNotifier.value[widget.index].number;
    numbercntrl = TextEditingController(text: number);

    String profile = studentListNotifier.value[widget.index].profile;
    photo = File(profile);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${studentListNotifier.value[widget.index].name}'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: formkey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                      alignment: Alignment.topCenter,
                      child: photo?.path == null
                          ? const CircleAvatar(
                              backgroundImage: AssetImage('assets/man.jpg'),
                              radius: 65,
                            )
                          : CircleAvatar(
                              radius: 65,
                              backgroundImage: FileImage(
                                File(photo!.path),
                              ),
                            )),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                      onPressed: () {
                        getImage();
                      },
                      icon: const Icon(Icons.photo),
                      label: const Text('Add Photo')),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: namecntrl,
                    keyboardType: TextInputType.name,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                        label: Text('Name'),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        prefixIcon: Icon(Icons.person)),
                    validator: (value) {
                      if (namecntrl.text.isEmpty) {
                        return 'name field is Empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: agecntrl,
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                        label: Text('Age'),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        prefixIcon: Icon(Icons.calendar_month)),
                    validator: (value) {
                      if (agecntrl.text.isEmpty) {
                        return 'Age field is Empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: addresscntrl,
                    keyboardType: TextInputType.streetAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                        label: Text('Address'),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        prefixIcon: Icon(Icons.details)),
                    validator: (value) {
                      if (addresscntrl.text.isEmpty) {
                        return 'Address field is Empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: numbercntrl,
                    keyboardType: TextInputType.phone,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                        label: Text('Number'),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        prefixIcon: Icon(Icons.phone)),
                    maxLength: 10,
                    validator: (value) {
                      if (numbercntrl.text.isEmpty) {
                        return 'Phone field is Empty';
                      } else if (numbercntrl.text.length < 10) {
                        return 'Enter a valid Phone Number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(130, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.cancel),
                          label: const Text('Cancel')),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(130, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              backgroundColor: Colors.green[600]),
                          onPressed: () {
                            if (formkey.currentState!.validate()) {
                              if (photo?.path == null) {
                                addingFailed();
                              } else {
                                updateSuccess(studentListNotifier
                                    .value[widget.index].id!);
                                Navigator.of(context).pop();
                              }
                            }
                          },
                          icon: const Icon(Icons.send),
                          label: const Text("Submit")),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    final imageTemporary = File(image.path);

    setState(() {
      photo = imageTemporary;
    });
  }

  void addingFailed() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Please Add The Profile Picture!'),
      backgroundColor: Colors.red,
      margin: EdgeInsets.all(10),
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      closeIconColor: Colors.white,
      duration: Duration(seconds: 2),
    ));
  }

  void updateSuccess(int id) {
    StudentModel st = StudentModel(
        profile: photo!.path,
        name: namecntrl.text.trim(),
        age: agecntrl.text.trim(),
        address: addresscntrl.text.trim(),
        number: numbercntrl.text.trim(),
        id: studentListNotifier.value[widget.index].id!);
    editStudent(id, st);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("${namecntrl.text}'s details edittted successfully!"),
      backgroundColor: Colors.green,
      margin: const EdgeInsets.all(10),
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      closeIconColor: Colors.white,
      duration: const Duration(seconds: 2),
    ));
  }
}
