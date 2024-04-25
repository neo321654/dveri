
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xc/features/detail/presentation/bloc/detail_events.dart';
import 'package:xc/features/detail/presentation/bloc/detail_state.dart';

class DetailBloc extends Bloc<DetailEvents,  DetailState> {
  DetailBloc() : super(DetailState()) {
    on<InitDetailProduct>(_onInitDetailProductEvent);
    on<ChangeColorDoor>(_onChangeColorDoorEvent);
    on<ChangeColorGlass>(_onChangeColorGlassEvent);
    on<ClearDetail>(_onClearDetailEvent);
    
  }

  _onInitDetailProductEvent(InitDetailProduct event, Emitter<DetailState> emit) async {
    Map newProd = event.product;

    if (newProd.containsKey('colorsDoor') && newProd['colorsDoor'].isNotEmpty) {
      if (newProd['colorsDoor'][0]['colorGlass'].isEmpty) {
        return emit(state.copyWith(
          screenError: true
        ));
      }

      return emit(state.copyWith(
        viewDetailImg: [newProd['colorsDoor'][0]['colorGlass'][0]['imgFullDoor']],
        product: newProd,
        selectedColorDoor: newProd['colorsDoor'][0],
        selectedColorGlass: newProd['colorsDoor'][0]['colorGlass'][0]
      ));
    }

    emit(state.copyWith(
      product: newProd,
      viewDetailImg: newProd['img']
    ));
  }

  _onChangeColorDoorEvent(ChangeColorDoor event, Emitter<DetailState> emit) async {
    Map colorGlass = {};
    bool haveColorGlass = false;
    
    for (var i = 0; i < event.newColor['colorGlass'].length; i++) {
      if (event.newColor['colorGlass'][i]['name'] == state.selectedColorGlass['name']) {
        haveColorGlass = true;
        colorGlass = event.newColor['colorGlass'][i];
        break;
      }
    }

    if (!haveColorGlass) {
      colorGlass = event.newColor['colorGlass'][0];
    }

    emit(state.copyWith(
      selectedColorDoor: event.newColor,
      selectedColorGlass: colorGlass,
      viewDetailImg: [colorGlass['imgFullDoor']]
    ));
  }

  _onChangeColorGlassEvent(ChangeColorGlass event, Emitter<DetailState> emit) async {

    emit(state.copyWith(
      viewDetailImg: [event.newColor['imgFullDoor']],
      selectedColorGlass: event.newColor
    ));
  }

  _onClearDetailEvent(ClearDetail event, Emitter<DetailState> emit) async {
    emit(state.copyWith(
      product: const {},
      selectedColorDoor: const {},
      selectedColorGlass: const {},
      viewDetailImg: const [],
      screenError: false
    ));
  }

}