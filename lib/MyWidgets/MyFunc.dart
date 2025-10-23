import 'dart:math';
// import 'package:flutter/material.dart';
// import 'dart:js';

round(var val, int dec) {
  dynamic r = ((val*pow(10, dec)).round())/(pow(10, dec));
  return r;
}

MaxVal (List lista) {
  double max = lista[0];
  lista.forEach((e) {
    if (e> max) {
      max = e;
    }
  });
  return max;
}

MinVal (List lista) {
  double min = lista[0];
  lista.forEach((e) {
    if (e < min) {
      min = e;
    }
  });
  return min;
}

Abs (var valor) {
  if (valor > 0) {valor = valor;}
  else {valor = valor*-1;};
  return valor;
}
