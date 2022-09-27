import 'package:flutter/material.dart';
import '../utils/app_routes.dart';
import '../components/product_item.dart';
import 'package:provider/provider.dart';
import '../models/product_list.dart';

import '../components/app_drawer.dart';

class ProductForm extends StatelessWidget {
  const ProductForm({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<ProductsList>(
      context,
      listen: false,
    ).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final ProductsList product = Provider.of<ProductsList>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gerenciar Produtos',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.productFormNew);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: product.itemCount,
            itemBuilder: (ctx, i) => Column(
              children: [
                ProductItem(product: product.items[i]),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
