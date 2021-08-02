import 'package:flutter/material.dart';
import 'package:flutter_api_rest/application/commons/helpers/dendency_injection.dart';

import 'application/application_widget.dart';

void main() {
  DependencyInjection.initialize();
  runApp(MyApp());
}
