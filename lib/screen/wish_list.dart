import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order_list.dart';
import '../components/app_drawer.dart';
import '../components/order_widget.dart';

class WishList extends StatelessWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _attOrders() => Provider.of<OrderList>(context, listen: false).loadOrders();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de desejos',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _attOrders(),
        child: FutureBuilder(
          future: _attOrders(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.error != null) {
              return const Center(
                child:  Text('Aconteceu um erro ao carregar os pedidos!'),
              );
            } else {
              return Consumer<OrderList>(
                builder: (ctx, orders, child) => ListView.builder(
                  itemCount: orders.itemsCount,
                  itemBuilder: (ctx, i) => OrderWidget(
                    order: orders.items[i],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
