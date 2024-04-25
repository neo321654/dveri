abstract class DetailEvents {}

class InitDetailProduct extends DetailEvents {
  Map product;

  InitDetailProduct(this.product);
}

class ChangeColorDoor extends DetailEvents {
  Map newColor;

  ChangeColorDoor(this.newColor);
}

class ChangeColorGlass extends DetailEvents {
  Map newColor;

  ChangeColorGlass(this.newColor);
}

class ClearDetail extends DetailEvents {

  ClearDetail();
}
