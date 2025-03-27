import 'package:flutter/material.dart';
import 'package:jokes_app/core/di/di_container.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDi();
  runApp(const MyApp());
}
