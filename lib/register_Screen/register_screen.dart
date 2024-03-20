import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../dbHelper/dbhelper.dart';
import '../model/user.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _globel = GlobalKey<FormState>();
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController contactNumber = TextEditingController();
  TextEditingController designation = TextEditingController();
  TextEditingController password = TextEditingController();
  late final ImagePicker _imagePicker = ImagePicker();

  File? imageFile;
  final DBhelper _dbHelper = DBhelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Usar"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _globel,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Text("Pick The Profile Image")),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      print("Call");
                      pickImagefromgallery();
                      setState(() {

                      });
                    },
                    child: CircleAvatar(
                      radius: 50,
                      child: imageFile != null ? CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(imageFile!) as ImageProvider,
                      ) : Container(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Expanded(child: TextFormField(
                      controller: fName,
                      validator: (value) {
                        if(value == null || value.trim().isEmpty){
                          return "Enter the FirstName";
                        }else{
                          return null;
                        }
                      },
                      style: TextStyle(),
                      decoration: InputDecoration(
                        label: Text("First Name"),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )
                      ),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(child: TextFormField(
                      controller: lName,
                      validator: (value) {
                        if(value == null || value.trim().isEmpty){
                          return "Enter the LastName";
                        }else{
                          return null;
                        }
                      },
                      style: TextStyle(),
                      decoration: InputDecoration(
                        label: Text("Last Name"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                      ),
                    )),

                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: email,
                  validator: (value) {
                    if(value == null || value.trim().isEmpty){
                      return "Enter the Email";
                    }else{
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    label: Text("Enter Email"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: contactNumber,
                  validator: (value) {
                    if(value == null || value.trim().isEmpty){
                      return "Enter the Number";
                    }else{
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      label: const Text("Enter Mobile Number"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: true,
                  controller: password,
                  validator: (value) {
                    if(value == null || value.trim().isEmpty){
                      return "Enter the Password";
                    }else{
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      label: const Text("Enter Password"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: designation,
                  validator: (value) {
                    if(value == null || value.trim().isEmpty){
                      return "Enter the Description";
                    }else{
                      return null;
                    }
                  },
                  maxLines: 3,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                      label: const Text("Enter Designation"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  height:50,
                  color: Colors.amber,
                  minWidth: double.infinity,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.black
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text("Register",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                  onPressed: () async {
                    if(_globel.currentState!.validate()){
                      String fname = fName.text.trim().toString();
                      String lname = lName.text.trim().toString();
                      String email1 = email.text.toString().trim();
                      String password1 = password.text.toString().trim();
                      String designation1 = designation.text.toString().trim();
                      String mobileNumber = contactNumber.text.toString().trim();
                      String ImagePath = await saveImages(imageFile);
                      User userclass = User(password: password1,fName: fname, lName: lname, contactNumber: mobileNumber, email: email1, profileImages: ImagePath, designation: designation1);
                       addDataInSqliteDatabase(context,userclass);
                    }
                },)
              ],
            ),
          ),
        ),
      ),
    );
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

  saveImages(File? imageFile) async {
    String fileName = basename(imageFile!.path);
    var supportDir = await getApplicationSupportDirectory();
    var file = File('$supportDir/$fileName');
    if (await file!.exists() == false) {
      try {
        String root = supportDir.path; // root path
        String fileName = '${DateTime.now().millisecondsSinceEpoch}.svg';
        File mFile = await imageFile!.copy('${root}/${fileName}');
        if (mFile != null) {
          return mFile.path;
        }
      } catch (e) {
        print(e.toString());
      }
    } else {
      return imageFile.path;
    }
  }

  Future<void> addDataInSqliteDatabase(BuildContext context,User user) async {
    var GetId = await _dbHelper.insert(user);
    if(GetId != -1){
      user.id = GetId;
      Fluttertoast.showToast(
          msg: "Register SucsessFully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      print("Data Add Success");
      Navigator.pop(context);
    }else{
      print("Data Not Add");
    }
  }
}
