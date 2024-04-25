import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xc/components/button.dart';
import 'package:xc/components/circularProgressIndicatorWidget.dart';
import 'package:xc/components/myAppBar.dart';
import 'package:xc/config/cache/customCacheManager.dart';
import 'package:xc/config/router/router.dart';
import 'package:xc/features/category/presentation/bloc/catalog_bloc.dart';
import 'package:xc/features/category/presentation/bloc/catalog_events.dart';
import 'package:xc/features/category/presentation/bloc/catalog_state.dart';
import 'package:xc/features/products/presentation/bloc/products_bloc.dart';
import 'package:xc/features/products/presentation/bloc/products_events.dart';
import 'package:xc/features/products/presentation/bloc/products_state.dart';
import 'package:xc/components/history.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  late final productsBloc = BlocProvider.of<ProductsBloc>(context);
  late final catalogBloc = BlocProvider.of<CatalogBloc>(context);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    productsBloc.add(InitProducts(catalogBloc.state.historyCategories[catalogBloc.state.historyCategories.length-1],));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    productsBloc.add(ClearProducts());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
      bloc: productsBloc,
      builder: (context, productsState) {
        return BlocBuilder<CatalogBloc, CatalogState>(
          bloc: catalogBloc,
          builder: (context, catalogState) {
            int historyLength = catalogState.historyCategories.length;

            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              appBar: const MyAppBar(),
              body: CustomScrollView(
                slivers: [
                  SliverList.list(
                    children: [
                      const SizedBox(height: 30,),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          historyLength != 0 ? catalogState.historyCategories[historyLength-1] : '',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      const History(),
                      const SizedBox(height: 8),
                      if(productsState.loadingProductsList)
                        const Column(
                          children: [
                            SizedBox(
                              height: 40,
                            ),
                            Center(
                              child: CircularProgressIndicatorWidget()
                            ),
                          ],
                        )
                    ]
                  ),            
                  const SliverPadding(padding: EdgeInsets.symmetric(vertical: 6),),
                  if(!productsState.loadingProductsList && productsState.productsList.isEmpty)
                    SliverList.list(
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        Text(
                          productsState.error,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black
                          ),
                        )
                      ]
                    ),
                   if(!productsState.loadingProductsList && productsState.productsList.isNotEmpty)
                    SliverGrid.extent(
                      maxCrossAxisExtent: 500,
                      children: <Widget> [    
                        ...productsState.productsList.map((product) =>
                          Container(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Image.memory(product['img'][0])
                                  // CachedNetworkImage(
                                  //   imageUrl: product['img'][0],
                                  //   fit: BoxFit.cover,
                                  //   cacheManager: customCacheManager,
                                  //   progressIndicatorBuilder: (context, url, downloadProgress) {
                                  //     return Center(
                                  //       child: CircularProgressIndicatorWidget(
                                  //         value: downloadProgress.progress,
                                  //       )
                                  //     );
                                  //   },
                                  //   errorWidget: (context, url, error) => Icon(Icons.error),
                                  // )
                                ),
                                const SizedBox(height: 20,),
                                Text(
                                  product['name'],
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20,),
                                InkWell(
                                  onTap: () {
                                    catalogBloc.add(AddHistory(product['name']));
                                    router.go('/detailProduct', extra: product);
                                  },
                                  child: const Button()
                                )
                              ],
                            ),
                          )
                        ),
                      ],
                    )
                ]
              )
            );
          }
        );
      }
    );
  }
}