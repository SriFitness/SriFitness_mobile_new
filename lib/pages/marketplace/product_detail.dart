import 'package:flutter/material.dart';

class ProductDetail extends StatelessWidget {
  final String productName;

  const ProductDetail({required this.productName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Details of $productName'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add to cart logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$productName added to cart')),
                );
              },
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}