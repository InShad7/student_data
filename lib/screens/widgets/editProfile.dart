import 'dart:io';

import 'package:db_hive/model/data.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:image_picker/image_picker.dart';

import '../../db/function/db_function.dart';
import '../HomeScreen.dart';

class EditProfile extends StatefulWidget {
  EditProfile(
      {Key? key,
      // required this.passValue01,
      required this.index,
      required this.passValueProfile})
      : super(key: key);

  Student passValueProfile;
  int index;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _nameController = TextEditingController();

  final _ageController = TextEditingController();

  final _numController = TextEditingController();

  String? imagePath;

  // final ImagePicker _picker = ImagePicker();

//function or widget==================================================

  Future<void> StudentAddBtn(int index) async {
    final _name = _nameController.text.trim();
    final _age = _ageController.text.trim();
    final _number = _numController.text.trim();
    // final _image = imagePath;

    if (_name.isEmpty || _age.isEmpty || _number.isEmpty) {
      return;
    }
    print('$_name $_age $_number');

    final _students = Student(
      name: _name,
      age: _age,
      number: _number,
      image: imagePath!,
    );
    final studentDB = await Hive.openBox<Student>('student_db');
    studentDB.putAt(index, _students);
    getStudents();
  }

  Future<void> takePhoto() async {
    final PickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (PickedFile != null) {
      setState(() {
        imagePath = PickedFile.path;
      });
    }
  }

  Widget elavatedbtn() {
    return ElevatedButton.icon(
      onPressed: () {
        StudentAddBtn(widget.index);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (ctx) => HomeScreen()),
            (route) => false);
      },
      icon: Icon(Icons.update_rounded),
      label: Text('Update'),
    );
  }

  Widget textFieldName(
      {required TextEditingController myController, required String hintName}) {
    return TextFormField(
      autofocus: false,
      controller: myController,
      cursorColor: Colors.black,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
          filled: true,
          fillColor: Color.fromRGBO(234, 236, 238, 2),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(50)),
          hintText: hintName,
          // counterText: myController.text
          ),
      // initialValue: 'hintName',
    );
  }

  Widget dpImage() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 75,
          backgroundImage: imagePath == null
              ? FileImage(File(widget.passValueProfile.image))
              : FileImage(File(imagePath!)),
        ),
        Positioned(
            bottom: 2,
            right: 10,
            child: InkWell(
                child: const Icon(
                  Icons.add_a_photo_outlined,
                  size: 30,
                ),
                onTap: () {
                  takePhoto();
                })),
      ],
    );
  }

  Widget szdBox = const SizedBox(height: 20);

  //build======================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              dpImage(),
              szdBox,
              textFieldName(
                  myController: _nameController,
                  hintName: widget.passValueProfile.name),
              szdBox,
              textFieldName(
                  myController: _ageController,
                  hintName: widget.passValueProfile.age),
              szdBox,
              textFieldName(
                  myController: _numController,
                  hintName: widget.passValueProfile.number),
              szdBox,
              elavatedbtn(),
            ]),
          ),
        ));
  }
}
