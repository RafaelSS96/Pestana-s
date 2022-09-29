import 'package:flutter/material.dart';
import '../models/auth.dart';
import '../utils/app_routes.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);

    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text(
              'Bem vindo usuario !!!',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text("Loja"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.authenticationOrHome);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text("Pedidos"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.wishList);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app_sharp),
            title: const Text("Sair"),
            onTap: () {
              Provider.of<Auth>(
                context,
                listen: false,
              ).logout();

              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.authenticationOrHome);
            },
          ),
          const Divider(),
          if (auth.email == 'adm@adm.com')
            ListTile(
              leading: const Icon(Icons.format_align_left),
              title: const Text("Gerenciar Produtos"),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(AppRoutes.products);
              },
            ),
        ],
      ),
    );
  }
}
