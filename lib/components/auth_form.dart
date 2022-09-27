import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/auth.dart';
import '../exceptions/auth_exception.dart';

enum AuthMode { sighup, login }

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  AuthMode _authMode = AuthMode.login;
  bool _isLoading = false;

  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final Map<String, String> _authData = {
    'email': '',
    'senha': '',
  };

  bool _isLogin() => _authMode == AuthMode.login;
  bool _isSighup() => _authMode == AuthMode.sighup;

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.sighup;
      } else {
        _authMode = AuthMode.login;
      }
    });
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreu um erro.'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Ok.'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);

    try {
      if (_isLogin()) {
        //login
        await auth.login(
          _authData['email']!,
          _authData['senha']!,
        );
      } else {
        //registrar aqui.
        await auth.sighup(
          _authData['email']!,
          _authData['senha']!,
        );
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado.');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: _isLogin() ? 310 : 400,
        width: deviceWidth.width * 0.75,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email ?? '',
                validator: (eMaill) {
                  final email = eMaill ?? '';
                  if (email.trim().isEmpty || !email.contains('@')) {
                    return 'Informe um email valido';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Senha',
                ),
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                controller: _passwordController,
                onSaved: (senha) => _authData['senha'] = senha ?? '',
                validator: _isLogin()
                    ? null
                    : (passWORD) {
                        final senha = passWORD ?? '';
                        if (senha.isEmpty || senha.length < 6) {
                          return 'Informe uma senha valida.';
                        }
                        return null;
                      },
              ),
              if (_isSighup())
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Confirmar Senha',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  validator: _isLogin()
                      ? null
                      : (pASSWORD) {
                          final senha = pASSWORD ?? '';
                          if (senha != _passwordController.text) {
                            return 'Senhas informadas não conferem';
                          }
                          return null;
                        },
                ),
              const SizedBox(
                height: 20,
              ),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 30,
                    ),
                  ),
                  child: Text(_authMode == AuthMode.sighup
                      ? 'Registrar usuario'
                      : 'ENTRAR'),
                ),
              const Spacer(),
              TextButton(
                onPressed: _switchAuthMode,
                child: Text(_isLogin()
                    ? 'Novo por aqui? Registre um usuario aqui.'
                    : 'Ja possui conta? '),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
