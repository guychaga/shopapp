import 'package:flutter/material.dart';
import 'product_model.dart';

class FavouritesPage extends StatelessWidget {
  final List<Product> favouriteProducts;

  const FavouritesPage({super.key, required this.favouriteProducts});

  double get totalCost {
    double sum = 0;
    for (var product in favouriteProducts) {
      sum += product.price;
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourites'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: favouriteProducts.length,
              itemBuilder: (context, index) {
                final product = favouriteProducts[index];
                return ListTile(
                  leading: Image.network(product.imageUrl, width: 50),
                  title: Text(product.name),
                  subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Total Cost: \$${totalCost.toStringAsFixed(2)}'),
          ),
        ],
      ),
    );
  }
}
