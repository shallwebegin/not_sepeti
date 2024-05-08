import 'package:flutter/material.dart';
import 'package:not_sepeti/pages/not_listesi.dart';
import 'package:not_sepeti/utils/database_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    var dd = DatabaseHelper();
    dd.notlariGetir();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: NotListesi(),
    );
  }
}
