import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mh_app/pages/test_form.dart';

class spl_screen extends StatefulWidget {
  const spl_screen({super.key});

  @override
  State<spl_screen> createState() => _spl_screenState();
}

class _spl_screenState extends State<spl_screen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Testform()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: Text(
            'MH-Style',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.lightBlueAccent),
          ),
        ),
      ),
    );
  }
}
