// lib/components/banner_s_style_1.dart
import 'package:flutter/material.dart';
import 'package:srifitness_app/constants.dart';

class BannerSStyle1 extends StatelessWidget {
  final String title, subtitle;
  final int discountParcent;
  final VoidCallback press;

  const BannerSStyle1({
    super.key,
    required this.title,
    required this.subtitle,
    required this.discountParcent,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(defaultBorderRadious),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: defaultPadding / 2),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: defaultPadding / 2),
            Text(
              "$discountParcent% OFF",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}