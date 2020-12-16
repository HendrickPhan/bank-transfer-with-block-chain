import 'package:flutter/material.dart';
import 'dart:async';
import 'bloc.dart';
import 'dart:math';

class ColorBloc implements Bloc {
  Color _color;
  Color get selectedcolor => _color;

  // 1
  final _colorController = StreamController<Color>();

  // 2
  Stream<Color> get color => _colorController.stream;

  // 3
  void selectcolor(Color color) {
    _color = color;
    _colorController.sink.add(color);
  }

  void changeColor() {
    _colorController.sink.add(getRandomColor());
  }

  // 4
  @override
  void dispose() {
    _colorController.close();
  }
}

Color getRandomColor() {
  Random _random = Random();
  return Color.fromARGB(
    _random.nextInt(256),
    _random.nextInt(256),
    _random.nextInt(256),
    _random.nextInt(256),
  );
}
