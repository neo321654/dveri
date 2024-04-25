import 'package:flutter/material.dart';

abstract class CatalogEvents {}

class InitCatalog extends CatalogEvents {
  BuildContext context;
  
  InitCatalog({required this.context});
}

class ChangeCatalog extends CatalogEvents {
  String title;
  
  ChangeCatalog(this.title);
}

class ChangeProductsList extends CatalogEvents {
  List value;
  
  ChangeProductsList(this.value);
}

class ChangeHistory extends CatalogEvents {
  String title;
  int index;
  
  ChangeHistory(this.title, this.index);
}

class ClearHistory extends CatalogEvents {
  
  ClearHistory();
}

class AddHistory extends CatalogEvents {
  String title;
  
  AddHistory(this.title);
}
