import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_routes.dart';
import '../models/order_list.dart';
import '../models/cart.dart';
import '../components/cart_item_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of(context);
    final items = cart.items.values.toList();

    _carrinhoVazio() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Carrinho vazio"),
            content: const Text('O carrinho não pode prosseguir vazio.'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(), child: const Text('Ok'))
            ],
          );
        },
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Carrinho",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        body: Column(
          children: [
            Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 20,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Chip(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      label: Text(
                        'R\$ ${cart.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              ?.color,
                        ),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () async  {
                        if (cart.itensCount >= 1) {
                          Navigator.of(context).pushNamed(AppRoutes.wishList);
                           await Provider.of<OrderList>(
                            context,
                            listen: false,
                          ).addOrder(cart);
                          cart.clear();
                          
                        } else {
                           return _carrinhoVazio();
                        }
                      },
                      style: TextButton.styleFrom(
                          textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      )),
                      child: const Text("COMPRAR!"),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (ctx, i) => CartItemWidget(cartItem: items[i]),
              ),
            ),
          ],
        ));
  }
}
