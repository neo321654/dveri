class DetailState {
  final Map product;
  final Map selectedColorDoor;
  final Map selectedColorGlass;
  final List viewDetailImg;
  final bool screenError;

  DetailState({
    this.product = const {},
    this.selectedColorDoor = const {},
    this.selectedColorGlass = const {},
    this.viewDetailImg = const [],
    this.screenError = false
  });

  DetailState copyWith({
    Map? product,
    Map? selectedColorDoor,
    Map? selectedColorGlass,
    List? viewDetailImg,
    bool? screenError
  }) {
    return DetailState(
      product: product ?? this.product,
      selectedColorDoor: selectedColorDoor ?? this.selectedColorDoor,
      selectedColorGlass: selectedColorGlass ?? this.selectedColorGlass,
      viewDetailImg: viewDetailImg ?? this.viewDetailImg,
      screenError: screenError ?? this.screenError
    );
  }
}