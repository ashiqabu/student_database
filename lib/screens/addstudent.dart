import 'dart:io';

import 'package:database_1/screens/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../db/functions/db_functions.dart';
import '../db/model/data_model.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final namecntrl = TextEditingController();
  final agecntrl = TextEditingController();
  final addresscntrl = TextEditingController();
  final numbercntrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  File? photo;
  @override
  Widget build(BuildContext context) {
    Future getImage(ImageSource source) async {
      try {
        final image = await ImagePicker().pickImage(source: source);
        if (image == null) return;
        //final imageTemporary = File(image.path);

        setState(() {
          photo = File(image.path);
        });
      } on PlatformException catch (e) {
        stdout.write('faild to pick image $e');
      }
    }

    const appTilte = 'Student Form';
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTilte),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 100,
                backgroundImage: photo != null
                    ? FileImage(photo!)
                    : const AssetImage('assets/man.jpg') as ImageProvider,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(65, 5, 65, 5),
                child: CustomButton(
                  title: 'pick from gallary',
                  icon: Icons.image_outlined,
                  onClick: () => getImage(ImageSource.gallery),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(65, 5, 65, 5),
                child: CustomButton(
                  title: 'pick from cemara',
                  icon: Icons.camera,
                  onClick: () => getImage(ImageSource.camera),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: namecntrl,
                keyboardType: TextInputType.name,
                decoration: Custom('Name', Icons.person),
                validator: (value) {
                  if (namecntrl.text.isEmpty) {
                    return 'Name Field is Empty';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: agecntrl,
                keyboardType: TextInputType.number,
                decoration: Custom('Age', Icons.calendar_month),
                maxLength: 3,
                validator: (value) {
                  if (agecntrl.text.isEmpty) {
                    return 'Age Field is Empty';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: addresscntrl,
                keyboardType: TextInputType.streetAddress,
                decoration: Custom('Address', Icons.details),
                validator: (value) {
                  if (addresscntrl.text.isEmpty) {
                    return 'Address Field is Empty';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: numbercntrl,
                keyboardType: TextInputType.phone,
                decoration: Custom('phone', Icons.phone_android),
                maxLength: 10,
                validator: (value) {
                  if (numbercntrl.text.isEmpty) {
                    return 'Phone Field is Empty';
                  } else if (numbercntrl.text.length < 10) {
                    return 'Enter a valid Phone number';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(75, 5, 75, 5),
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (photo?.path == null) {
                        addingFailed();
                      } else {
                        addingSuccess();
                      }
                    }
                  },
                  child: const Text('Add'),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  void addingFailed() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Please add the pofile picture!"),
      backgroundColor: Colors.red,
      margin: EdgeInsets.all(10),
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      closeIconColor: Colors.white,
      duration: Duration(seconds: 2),
    ));
  }

  void addingSuccess() async {
    StudentModel st = StudentModel(
      profile: photo!.path,
      name: namecntrl.text.trim(),
      age: agecntrl.text.trim(),
      address: addresscntrl.text.trim(),
      number: numbercntrl.text.trim(),
    );
    await addstudent(st);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${namecntrl.text} is added to database successfully!'),
      backgroundColor: Colors.green,
      margin: const EdgeInsets.all(10),
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      closeIconColor: Colors.white,
      duration: const Duration(seconds: 2),
    ));
    photo = null;
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }
}

// ignore: non_constant_identifier_names
Widget CustomButton({
  required String title,
  required IconData icon,
  required VoidCallback onClick,
}) {
  return SizedBox(
    width: 280,
    child: ElevatedButton(
      onPressed: onClick,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(
            width: 20,
          ),
          Text(title),
        ],
      ),
    ),
  );
}
