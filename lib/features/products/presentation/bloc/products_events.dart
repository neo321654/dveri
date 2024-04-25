abstract class ProductsEvents {}

class InitProducts extends ProductsEvents {
  String title;

  InitProducts(this.title);
}

class ClearProducts extends ProductsEvents {

  ClearProducts();
}
