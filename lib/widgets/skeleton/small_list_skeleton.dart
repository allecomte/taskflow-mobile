import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SmallListSkeleton extends StatelessWidget{
  final int itemCount;
  const SmallListSkeleton({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(itemCount, (_) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 32,
            width: 70,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }),
    );
  }

}
