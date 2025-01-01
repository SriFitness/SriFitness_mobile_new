
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:srifitness_app/pages/marketplace/product_model.dart';
import 'package:srifitness_app/pages/marketplace/product_card.dart';
import 'package:srifitness_app/constants.dart';
import 'package:srifitness_app/pages/marketplace/cart_screen.dart';
import 'package:srifitness_app/widget/custom_appbar.dart';

class Marketplace extends StatefulWidget {
  @override
  _MarketplaceState createState() => _MarketplaceState();
}

class _MarketplaceState extends State<Marketplace> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('products').get();
    List<Product> products = snapshot.docs.map((doc) {
      return Product.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();

    setState(() {
      _products = products;
      _filteredProducts = products;
    });
  }

  void _filterProducts(String query) {
    setState(() {
      _filteredProducts = _products
          .where((product) =>
      product.name.toLowerCase().contains(query.toLowerCase()) ||
          product.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Marketplace',
        height: 60,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            iconSize: 30,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: () async {
            _fetchProducts(); // Call the function without using its return value
          },
          child: SingleChildScrollView(
            child: CustomScrollView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        hintStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.search, color: Colors.black,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      style: TextStyle(color: Colors.black),
                      onChanged: _filterProducts,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // BannerSStyle1(
                      //   title: "Summer Sale",
                      //   subtitle: "Get fit for summer",
                      //   discountParcent: 30,
                      //   press: () {
                      //     // Navigate to summer sale page
                      //   },
                      // ),
                      SizedBox(height: defaultPadding),
                      // BannerSStyle5(
                      //   title: "New Arrivals",
                      //   subtitle: "Check out the latest gear",
                      //   discountPercent: 20,
                      //   bottomText: "Collection".toUpperCase(),
                      //   press: () {
                      //     // Navigate to new arrivals page
                      //   },
                      // ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.all(defaultPadding),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 1.1, // Adjusted aspect ratio for increased height
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8
                    ),
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        return ProductCard(
                          product: _filteredProducts[index],
                          onAddToCart: () {
                            // Implement add to cart functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${_filteredProducts[index].name} added to cart'),
                              ),
                            );
                          },
                        );
                      },
                      childCount: _filteredProducts.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}