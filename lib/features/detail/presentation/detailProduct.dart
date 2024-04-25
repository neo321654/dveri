import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xc/features/detail/presentation/bloc/detail_bloc.dart';
import 'package:xc/features/detail/presentation/bloc/detail_events.dart';
import 'package:xc/features/detail/presentation/widgets/desktopView.dart';
import 'package:xc/features/detail/presentation/widgets/mobileView.dart';

class DetailProduct extends StatefulWidget {
  Map product;

  DetailProduct({
    required this.product,
    super.key,
  });

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  late final detailBloc = BlocProvider.of<DetailBloc>(context);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    detailBloc.add(InitDetailProduct(widget.product));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    detailBloc.add(ClearDetail());
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width <= 730 
      ? const MobileView() 
      : const DesktopView();
  }
}