import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:xc/components/circularProgressIndicatorWidget.dart';
import 'package:xc/components/myAppBar.dart';
import 'package:xc/components/history.dart';
import 'package:xc/features/detail/presentation/bloc/detail_bloc.dart';
import 'package:xc/features/detail/presentation/bloc/detail_state.dart';
import 'package:xc/features/detail/presentation/widgets/dynamic%D0%A1olors.dart';

class DesktopView extends StatefulWidget {

  const DesktopView({
    super.key,
  });

  @override
  State<DesktopView> createState() => DdesktopViewState();
}

class DdesktopViewState extends State<DesktopView> {
  late final detailBloc = BlocProvider.of<DetailBloc>(context);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailBloc, DetailState>(
      bloc: detailBloc,
      builder: (context, detailState) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          appBar: const MyAppBar(),
          body: detailState.product.isNotEmpty && !detailState.screenError
            ? ListView(
                children: [
                  const SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      detailState.product['name'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  const History(),
                  const SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 400,
                        child: PageView.builder(
                          itemCount: detailState.viewDetailImg.length,
                          pageSnapping: true,
                          itemBuilder: (context, pagePosition) {
                          return Container(
                            margin: const EdgeInsets.all(10),
                            child: 
                            Image.memory(detailState.viewDetailImg[pagePosition])
                            // Image(
                            //   image: CachedNetworkImageProvider(detailState.viewDetailImg[pagePosition]),
                            //   errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                            // )
                            // CachedNetworkImage(
                            //   imageUrl: detailState.viewDetailImg[pagePosition],
                            //   progressIndicatorBuilder: (context, url, downloadProgress) {
                            //     return Center(
                            //       child: CircularProgressIndicatorWidget(
                            //         value: downloadProgress.progress,
                            //       )
                            //     );
                            //   },
                            //   errorWidget: (context, url, error) => Icon(Icons.error),
                            // ),
                          );
                        }),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              detailState.product['name'],
                              style: const TextStyle(
                                color: Color.fromARGB(255, 85, 85, 85),
                                fontSize: 25,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            const SizedBox(height: 20),
                            if(detailState.product['colorsDoor'].isNotEmpty)
                              const DynamicColors(),
                            if(detailState.product['colorsDoor'].isNotEmpty)
                              const SizedBox(height: 20),
                            if(detailState.product['description'].isNotEmpty)
                              Html(
                                data: detailState.product['description'],
                                style: {
                                  "*": Style(
                                    margin: Margins.all(0),
                                    fontSize: FontSize(14),
                                  ),
                                  "a": Style(
                                    color: Colors.black,
                                    textDecoration: TextDecoration.underline
                                  ),
                                  "p": Style(
                                    margin: Margins.symmetric(vertical: 2)
                                  ),
                                  "h1": Style(
                                    fontSize: FontSize(32),
                                  ),
                                  "h2": Style(
                                    fontSize: FontSize(24),
                                  ),
                                  "h3": Style(
                                    fontSize: FontSize(19),
                                  ),
                                  "h4": Style(
                                    fontSize: FontSize(16),
                                  ),
                                  "h5": Style(
                                    fontSize: FontSize(14),
                                  ),
                                  "h6": Style(
                                    fontSize: FontSize(13),
                                  ),
                                  "img": Style(
                                    height: Height(200),
                                    width: Width(MediaQuery.of(context).size.width - 24)
                                  )
                                },
                              ),
                            const SizedBox(height: 15,),
                          ],
                        ),
                      ),
                    ],
                  )
                ]
              )
            : detailState.screenError 
              ? const Center(
                  child: Text('Что то пошло не так. Проверьте каточку товара'),
                )
              : const SizedBox()
        );
      }
    );
  }
}