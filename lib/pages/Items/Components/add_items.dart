import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '/constants.dart';
import 'package:image_picker/image_picker.dart';

final _formKey = GlobalKey<FormState>();

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  PickedFile? img;
  int pick = 0;
  final snackBar = const SnackBar(
    content: Text(
      'Item Added',
      style: TextStyle(color: kTextColor),
    ),
    backgroundColor: kBlue,
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 20.0, left: 20),
                child: Text(
                  'Add Item',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: pick == 0
                    ? IconButton(
                        iconSize: 50,
                        onPressed: () async {
                          await imgPick();
                        },
                        icon: const Icon(
                          Icons.add_a_photo,
                          color: Colors.grey,
                        ),
                      )
                    : Image.file(
                        File(img!.path),
                        height: 150,
                        width: 150,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Title',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      width: 1.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      width: 1.0,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      width: 1.0,
                    ),
                  ),
                ),
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Please Fill';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Description',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      width: 1.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      width: 1.0,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      width: 1.0,
                    ),
                  ),
                ),
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Please Fill';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 15.0,
                  left: 15,
                  right: 15,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: TextButton(
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(358, 40)),
                      backgroundColor: MaterialStateProperty.all(kBlue),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)))),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      upload();
                    }
                  },
                  child: const Text(
                    'SAVE',
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Future imgPick() async {
    // ignore: invalid_use_of_visible_for_testing_member
    img = await ImagePicker.platform.pickImage(
      source: ImageSource.gallery,
    );
    if (img!.path != null) {
      setState(() {
        pick = 1;
      });
    }
  }

  Future upload() async {
    if (pick == 1) {
      Reference ref = FirebaseStorage.instance.ref();
      TaskSnapshot addImg = await ref.child(img!.path).putFile(File(img!.path));
      if (addImg.state == TaskState.success) {
        final String url = await addImg.ref.getDownloadURL();
        FirebaseFirestore.instance.collection('items').add({
          'title': titleController.text,
          'des': descriptionController.text,
          'imgUrl': url,
          'createdAt': DateTime.now(),
        });
      }
    } else {
      FirebaseFirestore.instance.collection('items').add({
        'title': titleController.text,
        'des': descriptionController.text,
        'imgUrl': 'no',
        'createdAt': DateTime.now(),
      });
    }
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
