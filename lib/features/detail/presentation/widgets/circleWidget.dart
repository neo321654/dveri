import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:xc/components/circularProgressIndicatorWidget.dart';

class CircleWidget extends StatefulWidget {
  final void Function()? onTap;
  final imgSrc;
  final bool selected;

  const CircleWidget({
    this.onTap = _defaultTap,
    this.imgSrc,
    this.selected = false,
    super.key, 
  });

  static _defaultTap() {}

  @override
  State<CircleWidget> createState() => CcirclWidgeteState();
}

class CcirclWidgeteState extends State<CircleWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: widget.selected 
            ? const Border(
                top: BorderSide(color: Colors.black, width: 2),
                bottom: BorderSide(color: Colors.black, width: 2),
                right: BorderSide(color: Colors.black, width: 2),
                left: BorderSide(color: Colors.black, width: 2)
              )
            : null
        ),
        child: widget.imgSrc.isNotEmpty 
          ? ClipOval(
              child: 
              Image.memory(widget.imgSrc)
              // Image(
              //   image: CachedNetworkImageProvider(widget.imgSrc),
              //   errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
              // )
              // CachedNetworkImage(
              //   imageUrl: widget.imgSrc,
              //   progressIndicatorBuilder: (context, url, downloadProgress) {
              //     return Center(
              //       child: CircularProgressIndicatorWidget(
              //         value: downloadProgress.progress,
              //       )
              //     );
              //   },
              //   errorWidget: (context, url, error) => Icon(Icons.error),
              // ),
            )
          : const SizedBox()
      ),
    );
  }
}