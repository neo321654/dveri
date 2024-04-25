class ProductsState {
  final List productsList;
  final String error;
  final bool loadingProductsList;

  ProductsState({
    this.productsList = const [],
    this.error = '',
    this.loadingProductsList = false
  });

  ProductsState copyWith({
    List? productsList,
    String? error,
    bool? loadingProductsList,
  }) {
    return ProductsState(
      productsList: productsList ?? this.productsList,
      error: error ?? this.error,
      loadingProductsList: loadingProductsList ?? this.loadingProductsList,
    );
  }
}