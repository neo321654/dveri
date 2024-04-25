import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xc/features/detail/presentation/bloc/detail_bloc.dart';
import 'package:xc/features/detail/presentation/bloc/detail_events.dart';
import 'package:xc/features/detail/presentation/bloc/detail_state.dart';
import 'package:xc/features/detail/presentation/widgets/circleWidget.dart';

class DynamicColors extends StatefulWidget {

  const DynamicColors({
    super.key
  });

  @override
  State<DynamicColors> createState() => DynamicColorsState();
}

class DynamicColorsState extends State<DynamicColors> {
  late final detailBloc = BlocProvider.of<DetailBloc>(context);
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailBloc, DetailState>(
      bloc: detailBloc,
      builder: (context, detailState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                const Text(
                  'Цвет полотна: ',
                  style: TextStyle(
                    color :Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 20
                  ),
                ),
                Text(
                  detailState.selectedColorDoor['name'],
                  style: const TextStyle(
                    color :Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20
                  ),
                ),
              ]
            ),
            const SizedBox(height: 10,),
            if(detailState.product['colorsDoor'].isNotEmpty)
              Wrap(
                spacing: 4,
                children: [
                  ...detailState.product['colorsDoor'].map((color) =>
                    CircleWidget(
                      onTap: () {
                        detailBloc.add(ChangeColorDoor(color));
                      },
                      selected: detailState.selectedColorDoor['name'] == color['name'],
                      imgSrc: color['imgSrc'],
                    )
                  )
                ],
              ),
            const SizedBox(height: 20,),
            Wrap(
              children: [
                const Text(
                  'Цвет стекла: ',
                  style: TextStyle(
                    color :Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 20
                  ),
                ),
                Text(
                  detailState.selectedColorGlass['name'],
                  style: const TextStyle(
                    color :Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20
                  ),
                ),
              ]
            ),
            const SizedBox(height: 10,),
            Wrap(
              spacing: 4,
              children: [
                ...detailState.selectedColorDoor['colorGlass'].map((color) =>
                  CircleWidget(
                    onTap: () {
                      detailBloc.add(ChangeColorGlass(color));
                    },
                    selected: detailState.selectedColorGlass['name'] == color['name'],
                    imgSrc: color['imgSrc'],
                  )
                )
              ],
            ),
          ],
        );
      }
    );
  }
}