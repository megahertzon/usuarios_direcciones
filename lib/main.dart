import 'package:flutter/material.dart';
import 'package:usuarios_direcciones/features/core/di/sl.dart';
import 'package:usuarios_direcciones/features/main_screen/presentation/screens/user_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await serviceLocatorInit();
  runApp(const MaterialApp(home: UsersPage()));
}
