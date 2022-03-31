import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '/constants.dart';
import 'package:image_picker/image_picker.dart';

final _formKey = GlobalKey<FormState>();

class EditDialogue extends StatefulWidget {
  final String id;
  final String imgUrl;
  final String des;
  final String title;
  const EditDialogue({
    Key? key,
    required this.title,
    required this.des, required this.imgUrl, required this.id,
  }) : super(key: key);
  @override
  State<EditDialogue> createState() => _EditDialogueState();
}

class _EditDialogueState extends State<EditDialogue> {
  final snackBar = const SnackBar(
    content: Text(
      'Edited',
      style: TextStyle(color: kTextColor),
    ),
    backgroundColor: kBlue,
  );
  PickedFile? img;
  int pick = 0;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    titleController.text = widget.title;
    descriptionController.text =widget.des;
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 20.0,left: 20),
              child: Text('Edit Item',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 24),),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: pick == 0
                ? Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
              style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kBlue)),
              child: Image.network(
                  widget.imgUrl,
                  height: 150,
                  width: 150,
              ),
              onPressed: () async {
                  await imgPick();
              },
            ),
                )
                : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
              style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kBlue)),
              onPressed: () async {
                  await imgPick();
              },
              child: Image.file(
                  File(img!.path),
                  height: 150,
                  width: 150,
              ),
            ),
                ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
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
            padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
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
            padding: EdgeInsets.only(top: 15.0,right: 15,left: 15,bottom:MediaQuery.of(context).viewInsets.bottom),
            child: TextButton(
                style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(const Size(358, 40)),
                    backgroundColor: MaterialStateProperty.all(kBlue),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))
                ),
                onPressed: () {
                  if(_formKey.currentState!.validate()){
                    save();
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
  Future save() async {
    if (pick == 1) {
      Reference ref = FirebaseStorage.instance.ref();
      TaskSnapshot addImg = await ref.child(img!.path).putFile(File(img!.path));
      if (addImg.state == TaskState.success) {
        final String url = await addImg.ref.getDownloadURL();
        FirebaseFirestore.instance.collection('items').doc(widget.id).update({
          'title':titleController.text,
          'des' : descriptionController.text,
          'imgUrl': url,
        });
      }
    } else {
      FirebaseFirestore.instance.collection('items').doc(widget.id).update({
        'title':titleController.text,
        'des' : descriptionController.text,
      });
    }
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}