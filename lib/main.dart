import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maybank_todo/ui/home/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Maybank ToDo App',
      theme: ThemeData(fontFamily: "Poppins"),
      home: HomePage(),
    );
  }
}
