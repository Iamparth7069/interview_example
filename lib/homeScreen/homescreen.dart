import 'dart:io';

import 'package:eample/dbHelper/dbhelper.dart';
import 'package:eample/login/loginScreen.dart';
import 'package:eample/model/user.dart';
import 'package:eample/preferences/pref_manager.dart';
import 'package:eample/profileData/profiledata.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../model/userContact.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Contact> contactList = [];
  DBhelper dBhelper = DBhelper();
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  File? imagefile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadContact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {
            PrefManagser.updateLoginStatus(false);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen(),), (route) => false);
          }, icon: Icon(Icons.logout))
        ],
        title: Text("Home Screen"),),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery
                        .of(context)
                        .viewInsets
                        .bottom + 4,
                    // Adjust padding to include space for keyboard
                    left: 12,
                    right: 12,
                  ),
                  child: Container(
                    height: 320,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text("Add Contact Details",
                            style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: name,
                            decoration: InputDecoration(
                                label: Text("Enter  Name"),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: email,
                            decoration: InputDecoration(
                                label: Text("Enter  Email"),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: password,
                            decoration: InputDecoration(
                                label: Text("Enter  Password"),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
                            ),
                          ),
                          ElevatedButton(onPressed: () async {
                            int uid = PrefManagser.getuid();
                            Contact contact = Contact(
                              uid: uid, name: name.text.toString(),
                                email: email.text.toString(),
                                password: password.text.toString());
                             var ids = await addData(contact,context);
                             setState(() {
                               contactList.add(ids!);
                             });
                          }, child: Text("Add Contact")),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      body: ListView.builder(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: contactList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () async {
              // print(contactList[index].id);
              Contact? user = await Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ProfileData(contactList[index])));
              if (user != null) {
                setState(() {
                  var index = contactList.indexWhere((element) =>
                  element.id == user.id);
                  contactList[index] = user;
                });
              }

            },
            trailing: IconButton(onPressed: () {
              Deletedatas(contactList[index].id!,contactList[index].uid!);
              setState(() {
                contactList.removeWhere((element) => element.id == contactList[index].id);
              });
            },
            icon: Icon(Icons.delete),
            ),
            title: Text("${contactList[index].email}"),
            subtitle: Text("${contactList[index].password}"),
          );
        },),
    );
  }

  Future<void> loadContact() async {
    contactList.clear();
    int getId = PrefManagser.getuid();
    var list = await dBhelper.readSubCategory(getId);
    contactList.addAll(list);
    setState(() {

    });
  }

  Future<Contact?> addData(Contact contact, BuildContext context) async {
    int add = await dBhelper.insertSubData(contact);
    if (add != -1) {
      contact.id = add;
      print("Add Data");
      Navigator.pop(context);
      return contact;
    } else {
      print("Error");
      return null;
    }
  }

  Future<void> Deletedatas(int ids,int uid) async {
    var id = await dBhelper.delete(uid,ids!);
    if(id != -1){
      print("Deleted Succsess Fully");
    }else{
      print("Deleted Uncess Fully");
    }
  }

}
