
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xc/features/category/presentation/bloc/catalog_events.dart';
import 'package:xc/features/products/presentation/bloc/products_events.dart';
import 'package:xc/features/products/presentation/bloc/products_state.dart';
import 'package:xc/services/hive/hive_service.dart';

class ProductsBloc extends Bloc<ProductsEvents,  ProductsState> {
  final catalogBloc;

  ProductsBloc({
    this.catalogBloc
  }) : super( ProductsState()) {
    on<InitProducts>(_onInitProductsEvent);
    on<ClearProducts>(_onClearProductsEvent);
  }

  _onInitProductsEvent(InitProducts event, Emitter<ProductsState> emit) async {
    emit(state.copyWith(
      loadingProductsList: true,
      productsList: [],
      error: ''
    ));

    List allProducts = HiveService.getAllProduct();

    for (var i = 0; i < allProducts.length; i++) {
      if (allProducts[i]['forCategory'] == event.title) {
        catalogBloc.add(ChangeProductsList(allProducts[i]['list']));

        emit(state.copyWith(
          productsList: allProducts[i]['list'],
          loadingProductsList: false,
          error: ''
        ));
      }
    }

    if (state.productsList.isEmpty) {
      emit(state.copyWith(
        error: 'В категории нет товаров',
        productsList: [],
        loadingProductsList: false
      ));
    }
  }

  _onClearProductsEvent(ClearProducts event, Emitter<ProductsState> emit) async {
    emit(state.copyWith(
      productsList: [],
      loadingProductsList: false,
      error: ''
    ));
  }
}