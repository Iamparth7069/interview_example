import 'package:eample/homeScreen/homescreen.dart';
import 'package:eample/login/loginScreen.dart';
import 'package:eample/preferences/pref_manager.dart';
import 'package:eample/register_Screen/register_screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefManagser.init();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool check = PrefManagser.getLoginStatus();
    return MaterialApp(
      title: 'ExampleApp',
      home: check ? HomeScreen() : LoginScreen(),
    );
  }
}
