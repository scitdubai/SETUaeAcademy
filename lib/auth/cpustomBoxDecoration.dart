import 'package:flutter/material.dart';
import 'package:set_academy/Utils/Color.dart';
import 'package:set_academy/Utils/general_URL.dart';

getCostomBox(){
  return 
  BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 233, 215, 241),
              Colors.blue,
            ],
          ));
}