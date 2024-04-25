class CatalogState {
  final List allCategories;
  final List activeCategories;
  final List historyCategories;
  final List productsList;
  final bool loadingCategories;
  final String error;

  CatalogState({
    this.allCategories = const [],
    this.activeCategories = const [],
    this.historyCategories = const [],
    this.productsList = const [],
    this.loadingCategories = false,
    this.error = '',
  });

  CatalogState copyWith({
    List? allCategories,
    List? activeCategories,
    List? historyCategories,
    List? productsList,
    bool? loadingCategories,
    String? error,
  }) {
    return CatalogState(
      allCategories: allCategories ?? this.allCategories,
      activeCategories: activeCategories ?? this.activeCategories,
      historyCategories: historyCategories ?? this.historyCategories,
      productsList: productsList ?? this.productsList,
      loadingCategories: loadingCategories ?? this.loadingCategories,
      error: error ?? this.error,
    );
  }
}