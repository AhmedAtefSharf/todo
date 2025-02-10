import 'package:flutter/material.dart';
import 'package:todo/home.dart';

void main(){
  runApp(MyApp as Widget);
  
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        HomeScreen.routeName :(context)=>HomeScreen(),
      },
      initialRoute:HomeScreen.routeName  ,
      debugShowCheckedModeBanner: false,
    );
  }
}
