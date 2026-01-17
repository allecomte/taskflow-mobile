import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LineSkeleton extends StatelessWidget{
  final double height;
  final double width;
  final BorderRadius borderRadius;

  const LineSkeleton({super.key, this.height = 20, this.width = 200, this.borderRadius = const BorderRadius.all(Radius.circular(5))});
  
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: borderRadius,
        ),
      ),
    );
  }

}