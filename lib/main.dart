import 'package:flutter/material.dart';
import 'package:mazify/Screens/Visualizer.dart';
import 'package:mazify/utils/Meta.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  bool launch = true;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AlgoData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Mazify.",
        theme: ThemeData(
          fontFamily: "Poppins",
          primarySwatch: Colors.blueGrey,
        ),
        home: Visualizer(),
      ),
    );
  }
}
