import 'package:flutter/material.dart';
import 'home.dart';
import 'dart:async';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent
  ));
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainScreen(),
  ));
}


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "images/background.jpg",
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Color(0xfff07d00)),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
