import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:lojinha/models/auth.dart';
import 'package:lojinha/models/order_list.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);
    final user = Provider.of<Auth>(context);

    final itemsHeight = (widget.order.products.length * 22.0) + 10;

    Future<void> _deleteOrder(Order order) async {
      await http.delete(
        Uri.parse(
          '${UrlList.urlOrders}/${user.userID}/${order.id}.json?auth=${user.token}',
        ),
      );
    }

    return Dismissible(
      key: UniqueKey(),
      background: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
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
          _deleteOrder(widget.order).whenComplete(() =>
              Provider.of<OrderList>(context, listen: false).loadOrders());
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
      child: SizedBox(
        //Atualização para mim futuro: Eu não consegui hoje integrar as animações com dismissed, 
        //dava overflow de pixels. Eu sei que você vai ser bom o bastante para mudar isso, então se vc puder,
        //mude isso pra gente ... sei que você pode, com amor o seu antigo eu. 
        // duration: const Duration(milliseconds: 300),
        height: _expanded ? itemsHeight + 90 : 90,
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
              Container(
                // duration: const Duration(milliseconds: 300),
                height: _expanded ? itemsHeight : 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                child: ListView(
                  children: widget.order.products.map(
                    (product) {
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
                    },
                  ).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
