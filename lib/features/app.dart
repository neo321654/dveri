import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xc/config/appScrollBehavior/appScrollBehavior.dart';

import 'package:xc/config/router/router.dart';
import 'package:xc/features/category/presentation/bloc/catalog_bloc.dart';
import 'package:xc/features/detail/presentation/bloc/detail_bloc.dart';
import 'package:xc/features/products/presentation/bloc/products_bloc.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final catalogBloc = CatalogBloc();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => catalogBloc,
          lazy: false,
        ),
        BlocProvider(
          create: (context) => ProductsBloc(
            catalogBloc: catalogBloc
          ),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => DetailBloc(),
          lazy: false,
        ),
      ],
      child: MaterialApp.router(
        scrollBehavior: AppScrollBehavior(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          fontFamily: 'Inter'
        ),
        routerConfig: router,
      ),
    );
  }
}