import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LineSkeleton extends StatelessWidget{
  final BuildContext context;
  final double height;
  final double? width;
  final BorderRadius borderRadius;

  const LineSkeleton({super.key, required this.context, this.height = 20, this.width, this.borderRadius = const BorderRadius.all(Radius.circular(5))});
  
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width ?? mediaQuery.size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: borderRadius,
        ),
      ),
    );
  }

}