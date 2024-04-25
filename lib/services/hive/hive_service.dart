import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive/hive.dart';
import 'package:xc/services/hive/models/catalog_model.dart';

class HiveService {
  static initHive() async {
    final applicationDocumentsDir = await path_provider.getApplicationDocumentsDirectory();

    Hive
      ..init(applicationDocumentsDir.path)
      ..registerAdapter(CatalogModelAdapter());
    
    await Hive.openBox('time');

    if (Hive.box('time').isEmpty) {
      DateTime now = DateTime.now();
      DateTime date = DateTime(now.year, now.month, now.day);

      Hive.box('time').put('wasAnApiRequestToday', false);
      Hive.box('time').put('dateLastApiRequest', date);
    } 
    else {
      DateTime dateLastApiRequest = Hive.box('time').get('dateLastApiRequest');
      DateTime now = DateTime.now();
      DateTime date = DateTime(now.year, now.month, now.day);

      if (dateLastApiRequest.isBefore(date)) {
        Hive.box('time').put('wasAnApiRequestToday', false);
      }
    }

    await Hive.openBox('category');
    await Hive.openBox('products');
  }

  static void changeBoxTime(wasAnApiRequestToday) {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    
    Hive.box('time').put('wasAnApiRequestToday', wasAnApiRequestToday);
    Hive.box('time').put('dateLastApiRequest', date);
  }

  static getBoxTime() {
    final result = Hive.box('time').values.toList();

    return result;
  }

  static void addCategories(categories) {
    Hive.box('category').add(categories);
  }

  static void addProducts(products) {
    Hive.box('products').add(products);
  }

  static List getAllCategories() {
    final result = Hive.box('category').values.toList();

    return result;
  }

  static List getAllProduct() {
    final result = Hive.box('products').values.toList();

    return result;
  }

  static void clearCategories() {
    Hive.box('category').clear();
  }

  static void clearProduct() {
    Hive.box('products').clear();
  }
}