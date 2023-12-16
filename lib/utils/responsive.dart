import 'package:flutter/material.dart';

class Responsive {

  final BuildContext context;

  Responsive({required this.context});

  get responsiveWidth => MediaQuery.of(context).size.width;
  get responsiveHeight => MediaQuery.of(context).size.height;

}
