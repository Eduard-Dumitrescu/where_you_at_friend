import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whereyouatfriend/provider_setup.dart';
import 'package:whereyouatfriend/ui/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Where you at friend',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}
