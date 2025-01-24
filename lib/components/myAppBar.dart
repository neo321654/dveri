import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xc/components/button.dart';
import 'package:xc/features/category/presentation/bloc/catalog_bloc.dart';
import 'package:xc/features/category/presentation/bloc/catalog_events.dart';
import 'package:xc/features/category/presentation/bloc/catalog_state.dart';

import '../config/router/router.dart';
import '../services/hive/hive_service.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {

  @override
  Size get preferredSize => const Size.fromHeight(60);
  
  const MyAppBar({
    super.key
  });

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  late final catalogBloc = BlocProvider.of<CatalogBloc>(context);
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      shadowColor: Colors.black,
      surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      title: InkWell(
        onTap: () {
          catalogBloc.add(ClearHistory());
        },
        child: Image.asset(
          'assets/images/dvernoi_logo.jpg',
          width: 165,
        ),
      ),
      actions: [

        BlocBuilder<CatalogBloc, CatalogState>(
            bloc: catalogBloc,
            builder: (context, catalogState) {
              // return catalogState.historyCategories.isNotEmpty
              //     ?
             return InkWell(
                  onTap: () {
                    // String lastWord = catalogState.historyCategories.last;
                    // int lastIndex = catalogState.historyCategories.length - 1;
                    //
                    // catalogBloc.add(ChangeHistory(lastWord, lastIndex));
                    HiveService.changeBoxTime(false);

                    catalogBloc.add(ClearHistory());


                    catalogBloc.add(InitCatalog(context: context));
                    router.go('/');

                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  child: const Button(
                    text: '',
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                  )
              );
                  // : const SizedBox();
            }
        ),
        SizedBox(width: 15,),
        BlocBuilder<CatalogBloc, CatalogState>(
          bloc: catalogBloc,
          builder: (context, catalogState) {
            return catalogState.historyCategories.isNotEmpty 
              ? InkWell(
                  onTap: () {
                    String lastWord = catalogState.historyCategories.last;
                    int lastIndex = catalogState.historyCategories.length - 1;


                    catalogBloc.add(ChangeHistory(lastWord, lastIndex));
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  child: const Button(
                    text: 'Назад',
                    icon: Icon(
                      Icons.arrow_circle_left_outlined,
                      color: Colors.white,
                    ),
                  )
                )
              : const SizedBox();
          }
        ),

        const SizedBox(width: 15,)
      ],
    );
  }
}