import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const ShimmerLoading.rectangular({
    super.key,
    this.width = double.infinity,
    required this.height,
    Color? color,
  }) : shapeBorder = const RoundedRectangleBorder();

  const ShimmerLoading.circular({
    super.key,
    required this.width,
    required this.height,
    this.shapeBorder = const CircleBorder(),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[800]!,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Colors.grey[900]!,
          shape: shapeBorder,
        ),
      ),
    );
  }
}

class ShimmerFeedLoading extends StatelessWidget {
  const ShimmerFeedLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          const ShimmerStoryTray(),
          ...List.generate(3, (index) => const ShimmerPostCard()),
        ],
      ),
    );
  }
}

class ShimmerStoryTray extends StatelessWidget {
  const ShimmerStoryTray({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                ShimmerLoading.circular(width: 64, height: 64),
                SizedBox(height: 8),
                ShimmerLoading.rectangular(width: 50, height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ShimmerPostCard extends StatelessWidget {
  const ShimmerPostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              ShimmerLoading.circular(width: 32, height: 32),
              SizedBox(width: 8),
              ShimmerLoading.rectangular(width: 100, height: 12),
            ],
          ),
        ),
        const ShimmerLoading.rectangular(height: 300),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerLoading.rectangular(width: 150, height: 12),
              const SizedBox(height: 8),
              const ShimmerLoading.rectangular(width: 250, height: 12),
              const SizedBox(height: 8),
              ShimmerLoading.rectangular(width: 100, height: 10),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
