import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:xc/features/category/presentation/category.dart';
import 'package:xc/features/detail/presentation/detailProduct.dart';
import 'package:xc/features/products/presentation/products.dart';

final router = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const Category(),
          transitionDuration: const Duration(milliseconds: 0),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          }
        );
      },
    ),
    GoRoute(
      path: '/products',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const Products(),
          transitionDuration: const Duration(milliseconds: 0),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          }
        );
      },
    ),
    GoRoute(
      path: '/detailProduct',
      pageBuilder: (context, state) {
        final product = state.extra! as Map;

        return CustomTransitionPage(
          key: state.pageKey,
          child: DetailProduct(
            product: product
          ),
          transitionDuration: const Duration(milliseconds: 0),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          }
        );
      },
    ),
  ]
);