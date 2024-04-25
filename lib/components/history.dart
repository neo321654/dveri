import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xc/features/category/presentation/bloc/catalog_bloc.dart';
import 'package:xc/features/category/presentation/bloc/catalog_events.dart';
import 'package:xc/features/category/presentation/bloc/catalog_state.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late final catalogBloc = BlocProvider.of<CatalogBloc>(context);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogBloc, CatalogState>(
      bloc: catalogBloc,
      builder: (context, catalogState) {
        return catalogState.historyCategories.isNotEmpty ?
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Wrap(
              children: [
                for (var i = 0; i < catalogState.historyCategories.length; i++) 
                  InkWell(
                    onTap: () {                      
                      catalogBloc.add(ChangeHistory(catalogState.historyCategories[i], i));
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '/ ',
                          style: TextStyle(
                            color: Color.fromARGB(255, 117, 117, 117)
                          ),),
                        Text(
                          '${catalogState.historyCategories[i]} ',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 117, 117, 117)
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ) : const SizedBox();
      }
    );
  }
}