import 'dart:io';

import 'package:flutter/material.dart';
import 'package:xc/features/app.dart';
import 'package:xc/services/hive/hive_service.dart';

void main() async {

  final DateTime today = DateTime.now();
  // Задаем дату 30 января 2025 года
  final DateTime targetDate = DateTime(2025, 1, 30);

  if (today.isAfter(targetDate)) {
    exit(0);
  }


  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.initHive();
  
  runApp(const MyApp());
}