// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:random_color_scheme/random_color_scheme.dart';
import 'package:school_project_ibdb/core/theme/app_theme.dart';
import 'package:school_project_ibdb/core/theme/theme_blue.dart';
import 'package:school_project_ibdb/feature/search_view/search_view.dart';
import 'package:school_project_ibdb/feature/sign_up/sign_up_view.dart';

import 'feature/help_view/help_view.dart';
import 'feature/login_screen/view/sign_in_view.dart';
import 'feature/menu_view/menu_veiw.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: randomColorSchemeLight(seed: 12345123)),
      title: 'Ibdb',
      home: HelpView(),
    );
  }
}
