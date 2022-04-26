import 'package:college_minor_project_frontend/AuthHandler.dart';
import 'package:college_minor_project_frontend/providers/EmailProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => EmailProvider()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'College Minor Project Frontend',
      home: AuthHandler().handleAuth(),
    ),
  );
}
