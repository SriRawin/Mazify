import 'package:flutter/material.dart';
import 'package:mazify/animated_button_popup.dart';
import 'package:mazify/visualizer_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  bool launch = true;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: PopUpModel(),
      child: Selector<PopUpModel, Brightness>(
        selector: (context, model) => model.brightness,
        builder: (context, brightness, __) {
          var model = Provider.of<PopUpModel>(context, listen: false);
          _getTheme().then((bri) => model.brightness = bri);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Mazify.",
            theme: ThemeData(
              buttonColor: Color(0xffcf66795),
              fontFamily: "Poppins",
              primarySwatch: Colors.blueGrey,
              brightness: Brightness.dark,
            ),
            home: Visualizer(),
          );
        },
      ),
    );
  }
}

Future<Brightness> _getTheme() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getBool('darkMode') ?? false)
      ? Brightness.dark
      : Brightness.light;
}
