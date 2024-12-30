import 'package:flutter/material.dart';
import 'product_model.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.imageUrl, height: 200),
            SizedBox(height: 16),
            Text('\$${product.price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),
            Text(product.description),
          ],
        ),
      ),
    );
  }
}
