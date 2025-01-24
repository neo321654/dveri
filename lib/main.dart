import 'dart:io';

import 'package:flutter/material.dart';
import 'package:xc/features/app.dart';
import 'package:xc/services/hive/hive_service.dart';

void main() async {



  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.initHive();
  
  runApp(const MyApp());
}