import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:convert';

class Utility {

  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      width: 100,
      height: 100,
      fit: BoxFit.fitHeight,
    );
  }

  static Image imageFromBase64String2(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      // width: 100,
      // height: 100,
      // fit: BoxFit.fill,
      // fit: BoxFit.contain,
      // height: double.infinity,
      // width: double.infinity,
      // alignment: Alignment.center,
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }
}

class Foto {
  late int id;
  late String Foto_name;

  Foto(this.id, this.Foto_name);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'Foto_name': Foto_name,
    };
    return map;
  }

  Foto.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    Foto_name = map['Foto_name'];
  }
}