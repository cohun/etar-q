import 'package:etar_q/src/common_widgets/custom_image.dart';
import 'package:etar_q/src/constants/app_sizes.dart';
import 'package:etar_q/src/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Used to show a single product inside a card.
class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, this.onPressed});

  final VoidCallback? onPressed;

  // * Keys for testing using find.byKey()
  static const productCardKey = Key('product-card');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: InkWell(
        key: productCardKey,
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CustomImage(imageUrl: 'assets/images/manlifteq.jpeg'),
              gapH8,
              const Divider(),
              gapH8,
              Text('Emelőszerkezetek',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
