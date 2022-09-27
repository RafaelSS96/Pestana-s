import 'dart:math';
import 'package:flutter/material.dart';
import '../components/auth_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromRGBO(215, 117, 255, 0.5),
              Color.fromRGBO(215, 117, 255, 0.9),
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 30,
                ),
                transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
                //cascade operator: é um operador composto de dois pontos (..) que
                //faz que operações void como a translate abaixo retornem de volta o
                //item depois de editado. Por exemplo, a função de lista add n retorna
                //nada, mas com o cascade, ele sempre vai retornar a lista att.
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.deepOrange.shade900,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.black26,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  "João Pestana's Store",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 45, fontFamily: 'Anton', color: Colors.white),
                ),
              ),
              const AuthForm()
            ],
          ),
        ),
      ],
    ));
  }
}
