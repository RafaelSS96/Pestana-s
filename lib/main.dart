import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/auth.dart';
import 'models/cart.dart';
import 'models/order_list.dart';
import 'models/product_list.dart';
import '/screen/auth_or_home_screen.dart';
import 'screen/cart_screen.dart';
import 'screen/wish_list.dart';
import 'screen/product_detail_screen.dart';
import 'screen/product_form_screen.dart';
import 'screen/product_form_new_screen.dart';
import 'utils/app_routes.dart';
import '/utils/custom_route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsList>(
          create: (_) => ProductsList(),
          update: (ctx, auth, previus) {
            return ProductsList(
              auth.token ?? '',
              auth.userID ?? '',
              previus?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList(),
          update: (ctx, auth, previus) {
            return OrderList(
              auth.token ?? '',
              auth.userID ?? '',
              previus?.items ?? []

            );
          }
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(

          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.purple,
            secondary: Colors.deepOrangeAccent,
          ),
          fontFamily: 'Lato',
          textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge: const TextStyle(
                fontSize: 25,
                fontFamily: 'Anton',
              ),
              titleMedium: const TextStyle(
                fontSize: 20,
                fontFamily: "Lato",
              ),
              titleSmall: const TextStyle(
                fontSize: 15,
                fontFamily: "Lato",
              )),
              pageTransitionsTheme: PageTransitionsTheme(
builders: {
  TargetPlatform.android: CustomPageTransitionsBuilder(),
  TargetPlatform.iOS: CustomPageTransitionsBuilder(),
}
              ),
        ),
        
        // home: const ProductsOverviewScreen(),
        routes: {
          AppRoutes.authenticationOrHome: (ctx) => const AuthOrHomePage(),
          AppRoutes.productDetail: (ctx) => const ProductDetailScreen(),
          AppRoutes.cart: (ctx) => const CartScreen(),
          AppRoutes.wishList: (ctx) => const WishList(),
          AppRoutes.products: (ctx) => const ProductForm(),
          AppRoutes.productFormNew: (ctx) => const ProductFormNew(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
