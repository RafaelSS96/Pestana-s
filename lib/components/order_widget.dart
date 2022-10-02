import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:lojinha/models/auth.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../exceptions/http_exception.dart';
import '../utils/ulr_list.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({
    Key? key,
    required this.order,
  }) : super(key: key);

  final Order order;

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);

    final user = Provider.of<Auth>(context);

    Future<void> _deleteOrder(Order order) async {
      await http.delete(
        Uri.parse(
          '${UrlList.urlOrders}/${user.userID}/${order.id}.json?auth=${user.token}',
        ),
      );

     
    }

    return Dismissible(
      key: ValueKey(widget.order.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      confirmDismiss: (_) {
        return showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(
              'Tem certeza que deseja cancelar o pedido?',
              textAlign: TextAlign.center,
            ),
            content: const Text(
              'Depois de cancelado, seu pedido sera removido de nosso sistema.',
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: const Text('Não'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text(
                  'Sim',
                  style: TextStyle(color: Theme.of(context).errorColor),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        try {
          _deleteOrder(widget.order);
        } on HttpException catch (error) {
          msg.showSnackBar(SnackBar(
              content: Text('Erro http, erro ${error.toString()}'),
              duration: const Duration(seconds: 2)));
        } catch (error) {
          msg.showSnackBar(SnackBar(
              content: Text(
                  'Não foi possivel excluir o produto, erro ${error.toString()}'),
              duration: const Duration(seconds: 2)));
        }
      },
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text('R\$ ${widget.order.total.toStringAsFixed(2)}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            if (_expanded)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                height: (widget.order.products.length * 22.0) + 10,
                child: ListView(
                  children: widget.order.products.map((product) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${product.quantidy} x R\$ ${product.price}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
