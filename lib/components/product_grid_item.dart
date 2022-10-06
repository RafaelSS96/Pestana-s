import 'package:flutter/material.dart';
import '../models/auth.dart';
import '../models/cart.dart';
import '../utils/app_routes.dart';
import '../models/product.dart';
import 'package:provider/provider.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(
      context,
      listen: false,
    );
    final cart = Provider.of<Cart>(
      context,
      listen: false,
    );
    final auth = Provider.of<Auth>(
      context,
      listen: false,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          title: Text(
            product.name,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.black54,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
                onPressed: () {
                  product.toggleFavorite(
                    context,
                    auth.token ?? '',
                    auth.userID ?? '',
                  );
                },
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Theme.of(context).colorScheme.secondary),
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addItem(product);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Produto adicionado ao seu carrinho!'),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'DESFAZER',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart),
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        child: GestureDetector(
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: const AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          onTap: () {
            Navigator.of(context)
                .pushNamed(AppRoutes.productDetail, arguments: product);
          },
        ),
      ),
    );
  }
}
