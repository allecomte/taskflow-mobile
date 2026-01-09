import 'package:flutter/material.dart';

class AvatarSkeleton extends StatelessWidget {
  final int itemCount;

  const AvatarSkeleton({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, _) {
          return Column(
            children: [
              CircleAvatar(radius: 28, backgroundColor: Colors.grey.shade300),
              const SizedBox(height: 8),
              Container(width: 60, height: 12, color: Colors.grey.shade300),
            ],
          );
        },
      ),
    );
  }
}
