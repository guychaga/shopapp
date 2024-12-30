import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopapp/favourites_page.dart';
import 'product_detail_page.dart';
import 'product_model.dart';
//import 'favourites_page.dart'; // Add this line

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> products = [];
  List<Product> favouriteProducts = [];

  @override
  void initState() {
    super.initState();
    // Fetch products from Firestore
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    // Example: Fetch products from Firestore
    final snapshot =
        await FirebaseFirestore.instance.collection('products').get();
    setState(() {
      products = snapshot.docs
          .map((doc) => Product(
                id: doc.id,
                name: doc['name'],
                description: doc['description'],
                price: doc['price'],
                imageUrl: doc['imageUrl'],
              ))
          .toList();
    });
  }

  void toggleFavourite(Product product) {
    setState(() {
      if (favouriteProducts.contains(product)) {
        favouriteProducts.remove(product);
      } else {
        favouriteProducts.add(product);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ShopApp'),
        leading: Icon(Icons.shopping_cart),
      ),
      body: Column(
        children: [
          // Horizontal categories
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                CategoryItem(
                    name: 'Electronics', icon: Icons.electrical_services),
                CategoryItem(name: 'Clothing', icon: Icons.shopping_bag),
                // Add more categories
              ],
            ),
          ),
          // Product list
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  isFavourite: favouriteProducts.contains(product),
                  onFavouritePressed: () => toggleFavourite(product),
                  onProductPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailPage(product: product),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favourites'),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    FavouritesPage(favouriteProducts: favouriteProducts),
              ),
            );
          }
        },
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String name;
  final IconData icon;

  const CategoryItem({super.key, required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          Text(name),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isFavourite;
  final VoidCallback onFavouritePressed;
  final VoidCallback onProductPressed;

  const ProductCard({
    super.key,
    required this.product,
    required this.isFavourite,
    required this.onFavouritePressed,
    required this.onProductPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onProductPressed,
        child: Column(
          children: [
            Image.network(product.imageUrl, height: 100),
            Text(product.name),
            Text('\$${product.price.toStringAsFixed(2)}'),
            IconButton(
              icon: Icon(isFavourite ? Icons.favorite : Icons.favorite_border),
              onPressed: onFavouritePressed,
            ),
          ],
        ),
      ),
    );
  }
}
