
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
),
body: cart.items.isEmpty
? Center(
child: Text('Your cart is empty'),
)
    : ListView.builder(
itemCount: cart.itemCount,
itemBuilder: (context, index) {
final product = cart.items[index];
return ListTile(
leading: Image.network(product.thumbnail),
title: Text(product.name),
subtitle: Text('\$${product.discountedPrice.toStringAsFixed(2)}'),
trailing: IconButton(
icon: Icon(Icons.remove_circle_outline),
onPressed: () {
cart.removeProduct(product);
},
),
);
},
),
);
}
}