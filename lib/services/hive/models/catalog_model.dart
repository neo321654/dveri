import 'package:hive/hive.dart';

part 'catalog_model.g.dart';

@HiveType(typeId: 0)
class CatalogModel {
  CatalogModel({
    required this.title,
    required this.description,
    required this.children
  });
  
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;
  
  @HiveField(2)
  List children;
}