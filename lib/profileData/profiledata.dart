import 'dart:io';
import 'package:eample/dbHelper/dbhelper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:eample/model/user.dart';
import 'package:eample/model/userContact.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfileData extends StatefulWidget {
  Contact user;

  ProfileData(this.user);

  @override
  State<ProfileData> createState() => _ProfileDataState();
}

class _ProfileDataState extends State<ProfileData> {
  DBhelper dBhelper = DBhelper();

  final _globel = GlobalKey<FormState>();

  TextEditingController Name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  File? imageFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Name.text = widget.user.name;
    email.text = widget.user.email;
    password.text = widget.user.password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.email),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _globel,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                TextFormField(
                  controller: Name,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter the Name";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      label: Text("Enter Name"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: email,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter the Email";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      label: Text("Enter Email"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: true,
                  controller: password,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter the Password";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      label: const Text("Enter Password"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  height: 50,
                  color: Colors.amber,
                  minWidth: double.infinity,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Update",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  onPressed: () async {
                    if (_globel.currentState!.validate()) {
                      Contact user = Contact(
                          id: widget.user.id,
                          uid: widget.user.uid,
                          name: Name.text.toString(),
                          email: email.text.toString().trim(),
                          password: password.text.toString());

                      updateData(context, user);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateData(BuildContext context, Contact user) async {
    int check = await dBhelper.updateUserData(user);
    if (check != -1) {
      Navigator.pop(context, user);
    }
  }

  Future<void> pickImagefromgallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    String path = '${result?.files.first.path}';
    if (result != null) {
      setState(() {
        imageFile = File(path);
        print("The Image File $imageFile");
      });
    }
  }
}
