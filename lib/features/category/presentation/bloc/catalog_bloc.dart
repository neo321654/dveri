
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xc/config/cache/customCacheManager.dart';

import 'package:xc/config/router/router.dart';
import 'package:xc/features/category/data/data_sources/remote/api.dart';
import 'package:xc/features/category/presentation/bloc/catalog_state.dart';
import 'package:xc/features/category/presentation/bloc/catalog_events.dart';
import 'package:xc/services/hive/hive_service.dart';

class CatalogBloc extends Bloc<CatalogEvents, CatalogState> {

  CatalogBloc() : super(CatalogState()) {
    on<InitCatalog>(_onInitCatalogEvent);
    on<ChangeCatalog>(_onChangeCatalogEvent);
    on<ChangeHistory>(_onChangeHistoryEvent);
    on<AddHistory>(_onAddHistoryEvent);
    on<ChangeProductsList>(_onChangeProductsListEvent);
    on<ClearHistory>(_onClearHistoryEvent);
  }

  _onInitCatalogEvent(InitCatalog event, Emitter<CatalogState> emit) async {
    emit(state.copyWith(
      loadingCategories: true
    ));

    Future setCatalog() async {
      var data = await getCatalog();

      String strUtf8 = utf8.decode(data.codeUnits);
      Map dataCatalog = json.decode(strUtf8);

      if(dataCatalog['successful']) {
        for (var i = 0; i < dataCatalog['Categories'].length; i++) {
          HiveService.addCategories(
            {
              'title': dataCatalog['Categories'][i]['title'],
              'description': dataCatalog['Categories'][i]['description'] ?? '',
              'children': dataCatalog['Categories'][i]['children'],
            }
          );
        }
      }
    }

    Future setProduct() async {
      print('setProduct start');
      var data = await getProduct();

      String strUtf8 = utf8.decode(data.codeUnits);
      Map dataProduct = json.decode(strUtf8);
      List receivedIDs = [];
      List receivedImg = [];
      List receivedClorsDoor = [];
      List receivedIdClorsDoor = [];

      if(dataProduct['successful']) {
        for (var i = 0; i < dataProduct['Products'].length; i++) {
          for (var e = 0; e < dataProduct['Products'][i]['list'].length; e++){
            print('new Product');

            for (var j = 0; j < dataProduct['Products'][i]['list'][e]['img'].length; j++) {
              try {
                var byte = await getImg(dataProduct['Products'][i]['list'][e]['img'][j]);
                dataProduct['Products'][i]['list'][e]['img'][j] = byte;
              } catch (e) {
                Exception('Exception (img): $e');
              }
            }

            for (var colorIndex = 0; colorIndex < dataProduct['Products'][i]['list'][e]['colorsDoor'].length; colorIndex++) {
              if (receivedIdClorsDoor.contains(dataProduct['Products'][i]['list'][e]['colorsDoor'][colorIndex]['id'])) {
                for (var y = 0; y < receivedClorsDoor.length; y++) {
                  if (receivedClorsDoor[y]['id'] == dataProduct['Products'][i]['list'][e]['colorsDoor'][colorIndex]['id']) {
                    dataProduct['Products'][i]['list'][e]['colorsDoor'][colorIndex]['imgSrc'] = receivedClorsDoor[y]['imgSrc'];
                    print('pass color door');
                  }
                }

              } else {
                try {
                  var byte = await getImg(dataProduct['Products'][i]['list'][e]['colorsDoor'][colorIndex]['imgSrc']);
                  dataProduct['Products'][i]['list'][e]['colorsDoor'][colorIndex]['imgSrc'] = byte;
                } catch (e) {
                  Exception('Exception (imgSrc): $e');
                }
                print('add color door');
                receivedClorsDoor.add(dataProduct['Products'][i]['list'][e]['colorsDoor'][colorIndex]);
                receivedIdClorsDoor.add(dataProduct['Products'][i]['list'][e]['colorsDoor'][colorIndex]['id']);
              }

              for (var glassIndex = 0; glassIndex < dataProduct['Products'][i]['list'][e]['colorsDoor'][colorIndex]['colorGlass'].length; glassIndex++) {
                var byte;

                if(receivedIDs.contains(dataProduct['Products'][i]['list'][e]['colorsDoor'][colorIndex]['colorGlass'][glassIndex]['id'])) {
                  for (var y = 0; y < receivedImg.length; y++) {
                    if (receivedImg[y]['id'] == dataProduct['Products'][i]['list'][e]['colorsDoor'][colorIndex]['colorGlass'][glassIndex]['id']) {
                      dataProduct['Products'][i]['list'][e]['colorsDoor'][colorIndex]['colorGlass'][glassIndex]['imgSrc'] = receivedImg[y]['imgSrc'];
                    }
                  }
                  print('pass');

                } else {
                  // print(dataProduct['Products'][i]['list'][e]['colorsDoor'][colorIndex]['colorGlass'][glassIndex]['imgSrc']);
                  try {
                    byte = await getImg(dataProduct['Products'][i]['list'][e]['colorsDoor'][colorIndex]['colorGlass'][glassIndex]['imgSrc']);
                    dataProduct['Products'][i]['list'][e]['colorsDoor'][colorIndex]['colorGlass'][glassIndex]['imgSrc'] = byte;
                  } catch (e) {
                    Exception('Exception (colorGlass imgSrc): $e');
                  }

                  receivedImg.add(dataProduct['Products'][i]['list'][e]['colorsDoor'][colorIndex]['colorGlass'][glassIndex]);
                  receivedIDs.add(dataProduct['Products'][i]['list'][e]['colorsDoor'][colorIndex]['colorGlass'][glassIndex]['id']);
                }
                
                try {
                  byte = await getImg(dataProduct['Products'][i]['list'][e]['colorsDoor'][colorIndex]['colorGlass'][glassIndex]['imgFullDoor']);
                  dataProduct['Products'][i]['list'][e]['colorsDoor'][colorIndex]['colorGlass'][glassIndex]['imgFullDoor'] = byte;     
                } catch (e) {
                  Exception('Exception (imgFullDoor): $e');
                }

                print('end colorGlass');
              }
              print('end colorsDoor');
            }
            print('end Product');
          }
//
          print(receivedIdClorsDoor.length);
          print(receivedIDs.length);

          HiveService.addProducts(
            {
              'forCategory': dataProduct['Products'][i]['forCategory'],
              'list': dataProduct['Products'][i]['list'],
            }
          );
        }
      }

      print('setProduct end');
      return;
    }
    
    var allCategories = HiveService.getAllCategories();

    // если всё пусто
    if(allCategories.isEmpty) {
      try {
        final result = await InternetAddress.lookup('google.com');
        
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          await setCatalog();
          await setProduct();

          // обновились
          HiveService.changeBoxTime(true);

          return emit(state.copyWith(
            allCategories: HiveService.getAllCategories(),
            activeCategories: HiveService.getAllCategories(),
            loadingCategories: false
          ));
        }
      } catch (error) {
        print(error);

        return emit(state.copyWith(
          error: 'Для первичной загрузки каталога проверьте подключение к интернету.',
          loadingCategories: false
        ));
      }
      //если категория не пустая
    } else {
      List timeBox = HiveService.getBoxTime();
      TimeOfDay now = TimeOfDay.now();
      int nowInMinutes = now.hour * 60 + now.minute;

      print(timeBox);

      //если сегдня не обновлялись и если после 6 утра
      // if(!timeBox[1] && nowInMinutes >= 600) {
      if(!timeBox[1]) {
        print('get new data');

        HiveService.clearCategories();
        HiveService.clearProduct();

        emit(state.copyWith(
          allCategories: [],
          activeCategories: []
        ));

        await setCatalog();
        await setProduct();

        HiveService.changeBoxTime(true);

        return emit(state.copyWith(
          allCategories: allCategories,
          activeCategories: allCategories,
          loadingCategories: false
        ));
      }

      return emit(state.copyWith(
        allCategories: allCategories,
        activeCategories: allCategories,
        loadingCategories: false,
        error: ''
      )); 
    }
  }
  
  _onChangeCatalogEvent(ChangeCatalog event, Emitter<CatalogState> emit) async {
    List history = [...state.historyCategories];
    history.add(event.title);

    emit(state.copyWith(
      historyCategories: history
    ));

    for (var i = 0; i < state.activeCategories.length; i++) {
      if (state.activeCategories[i]['title'] == event.title) {
        if (state.activeCategories[i]['children'].isNotEmpty) {
          return emit(state.copyWith(
            activeCategories: state.activeCategories[i]['children']
          ));
        } else {
          return router.go('/products');
        }
      }
    }
  }

  _onChangeHistoryEvent(ChangeHistory event, Emitter<CatalogState> emit) async {
    bool titleFormProduct = false;

    for (var i = 0; i < state.productsList.length; i++) {
      if (state.productsList[i]['name'] == event.title) {
        titleFormProduct = true;
      }
    }

    if(titleFormProduct) {
      router.go('/products');
    } else {
      router.go('/');
    }

    List history = [...state.historyCategories];
    List activeCategories = state.allCategories;

    history.removeRange(event.index, history.length);

    emit(state.copyWith(
      historyCategories: history
    ));

    for (var i = 0; i < history.length; i++) {
      for (var y = 0; y < activeCategories.length; y++) {
        if (history[i] == activeCategories[y]['title']) {
          activeCategories = activeCategories[y]['children'];
          break;
        }
      }
    }

    return emit(state.copyWith(
      activeCategories: activeCategories
    ));
  }

  _onClearHistoryEvent(ClearHistory event, Emitter<CatalogState> emit) async {
    emit(state.copyWith(
      historyCategories: [],
      activeCategories: HiveService.getAllCategories(),
    ));

    router.go('/');
  }

  _onAddHistoryEvent(AddHistory event, Emitter<CatalogState> emit) async {
    List history = [...state.historyCategories];
    history.add(event.title);

    emit(state.copyWith(
      historyCategories: history
    ));
  }

  _onChangeProductsListEvent(ChangeProductsList event, Emitter<CatalogState> emit) async {
    emit(state.copyWith(
      productsList: event.value
    ));
  }

}