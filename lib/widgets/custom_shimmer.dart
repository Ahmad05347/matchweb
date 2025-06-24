import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final double height;
  final double width;
  final int lines;

  const CustomShimmer({
    super.key,
    this.height = 200,
    this.width = double.infinity,
    this.lines = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      direction: ShimmerDirection.ltr,
      period: const Duration(milliseconds: 1200),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            lines,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                height: 16,
                width: index == 0
                    ? width * 0.6
                    : index == lines - 1
                    ? width * 0.4
                    : width,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
