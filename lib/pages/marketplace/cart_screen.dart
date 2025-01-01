import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srifitness_app/models/cart_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline),
            iconSize: 32,
            tooltip: 'Remove selected items',
            onPressed: () {
              cart.removeSelectedItems();
            },
          ),
        ],
      ),

      body: ListView.builder(
        itemCount: cart.items.length,
        itemBuilder: (context, index) {
          final cartItem = cart.items[index];
          return Card(
            color: cartItem.selected ? Colors.black12: Colors.black26,
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: cartItem.selected,
                        onChanged: (bool? value) {
                          cart.selectItem(cartItem.product, value ?? false);
                        },
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          cartItem.product.thumbnail,
                          height: 140,
                          width: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cartItem.product.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '\$${cartItem.product.discountedPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.green,
                              ),
                            ),
                            if (cartItem.product.discount > 0)
                              Text(
                                '\$${cartItem.product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white70 ,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline),
                                  iconSize: 25,
                                  onPressed: () {
                                    cart.decreaseQuantity(cartItem.product);
                                  },
                                ),
                                Text(
                                  '${cartItem.quantity}',
                                  style: TextStyle(fontSize: 18),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add_circle_outline),
                                  iconSize: 25,
                                  onPressed: () {
                                    cart.increaseQuantity(cartItem.product);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox.fromSize(size: Size.fromHeight(16)),
                  // Divider(),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       'Total: \$${(cartItem.product.discountedPrice * cartItem.quantity).toStringAsFixed(2)}',
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //     IconButton(
                  //       icon: Icon(Icons.delete_outline),
                  //       onPressed: () {
                  //         cart.removeProduct(cartItem.product);
                  //       },
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            // Implement checkout logic here
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Checkout (\$${cart.totalPrice.toStringAsFixed(2)})',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}