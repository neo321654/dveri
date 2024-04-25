import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xc/components/circularProgressIndicatorWidget.dart';
import 'package:xc/components/myAppBar.dart';
import 'package:xc/features/category/presentation/bloc/catalog_bloc.dart';
import 'package:xc/features/category/presentation/bloc/catalog_events.dart';
import 'package:xc/features/category/presentation/bloc/catalog_state.dart';
import 'package:xc/services/hive/hive_service.dart';
import 'package:xc/components/history.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  late final catalogBloc = BlocProvider.of<CatalogBloc>(context);

  @override
  void initState() {
    super.initState();
    
    // HiveService.clearCategories();
    // HiveService.clearProduct();
    if (catalogBloc.state.allCategories.isEmpty) {
      catalogBloc.add(InitCatalog(
        context: context
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogBloc, CatalogState>(
      bloc: catalogBloc,
      builder: (context, catalogState) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          appBar: const MyAppBar(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height 
                  - (catalogState.historyCategories.isNotEmpty ? 168 : 129),
                child: ListView(
                  children: [
                    const SizedBox(height: 30,),
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        'Категории',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const History(),
                    if(catalogState.loadingCategories)
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          CircularProgressIndicatorWidget()
                        ],
                      ),
                    if(catalogState.error.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            Text(
                              catalogState.error,
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black
                              ),
                            )
                          ]
                        ),
                      ),
                    if(!catalogState.loadingCategories && catalogState.activeCategories.isNotEmpty)
                      for (var i = 0; i < catalogState.activeCategories.length; i++)
                        InkWell(
                          onTap: () {
                            catalogBloc.add(ChangeCatalog(catalogState.activeCategories[i]['title']));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromARGB(50, 0, 0, 0), 
                                  width: 1
                                )
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width - 54,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        catalogState.activeCategories[i]['title'],
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                      if(catalogState.activeCategories[i]['description'].isNotEmpty)
                                        const SizedBox(height: 10,),
                                      if(catalogState.activeCategories[i]['description'].isNotEmpty)
                                        Text(
                                          catalogState.activeCategories[i]['description'],
                                          softWrap: true,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400
                                          ),
                                        ),
                                    ],
                                  )
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.red,
                                )
                              ],
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            ],
          )
        );
      }
    );
  }
}