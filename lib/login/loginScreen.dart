

import 'package:eample/dbHelper/dbhelper.dart';
import 'package:eample/homeScreen/homescreen.dart';
import 'package:eample/register_Screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../preferences/pref_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  DBhelper dbhelper = DBhelper();
  final email = TextEditingController();
  final password = TextEditingController();
  final _global = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Screen"),
      ),
      body: Center(
        child: Form(
          key: _global,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    label: Text("Login"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: password,
                  decoration: InputDecoration(
                      label: Text("password"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(child: Text("Register"),onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen(),));
                  },),
                ),
                SizedBox(
                  height: 5,
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
                  child: Text("Login",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                  onPressed: () async {
                    if(_global.currentState!.validate()){
                      String email1 =  email.text.toString().trim();
                      String password1 = password.text.toString().trim();
                      await LoginStatusCheck(email1,password1,context);

                    }
                  },)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> LoginStatusCheck(String email1, String password1, BuildContext context) async {
     var check = await  dbhelper.isLoginUser(email1, password1);
     int? uid = await dbhelper.getUserId(email1, password1);
     PrefManagser.updateLoginStatus(true);
     PrefManagser.updateuid(uid!);
     if(check) {
       Fluttertoast.showToast(
           msg: "Login SecsessFully",
           toastLength: Toast.LENGTH_SHORT,
           gravity: ToastGravity.CENTER,
           timeInSecForIosWeb: 1,
           backgroundColor: Colors.red,
           textColor: Colors.white,
           fontSize: 16.0
       );
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
     }
  }
}
