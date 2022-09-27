import '../models/product.dart';
import '../models/product_list.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ProductFormNew extends StatefulWidget {
  const ProductFormNew({Key? key}) : super(key: key);

  @override
  State<ProductFormNew> createState() => _ProductFormNewState();
}

class _ProductFormNewState extends State<ProductFormNew> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _urlFocus = FocusNode();

  final _imageUrlControle = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _urlFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlControle.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();

    _urlFocus.removeListener(updateImage);
    _urlFocus.dispose();
  }

  void updateImage() {
    setState(() {});
  }

  bool isValidUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');

    return isValidUrl && endsWithFile;
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<ProductsList>(
        context,
        listen: false,
      ).saveProduct(_formData);
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ocorreu um erro!      :('),
          content: const Text(
              'Infelizmente ocorreu um erro na sua solicitação de produto. Estaremos resolvendo ela no futuro! :( '),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ok'),
            ),
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Formulario do Produto',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _formData['name']?.toString(),
                      decoration: const InputDecoration(labelText: 'Nome'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocus);
                      },
                      onSaved: (name) => _formData['name'] = name ?? '',
                      validator: (nome) {
                        final name = nome ?? '';

                        if (name.trim().isEmpty) {
                          return 'Nome é obrigatorio';
                        }
                        if (name.trim().length < 3) {
                          return 'Nome muito curto, minimo 3 letras';
                        }
                        if (name.trim().length > 16) {
                          return 'Nome muito longo, maximo 15 letras';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['price']?.toString(),
                      decoration: const InputDecoration(labelText: 'Preço'),
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocus,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionFocus);
                      },
                      onSaved: (price) =>
                          _formData['price'] = double.parse(price ?? '0'),
                      validator: (preco) {
                        final priceString = preco ?? '';
                        final price = double.tryParse(priceString) ?? -1;

                        if (price <= 0) {
                          return 'Informe um preço valido';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['description']?.toString(),
                      decoration: const InputDecoration(labelText: 'Descrição'),
                      focusNode: _descriptionFocus,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      onSaved: (description) =>
                          _formData['description'] = description ?? '',
                      validator: (descricao) {
                        final description = descricao ?? '';

                        if (description.trim().isEmpty) {
                          return 'Descrição é obrigatoria';
                        }
                        if (description.trim().length < 10) {
                          return 'Descrição muito curta, minimo 10 letras';
                        }

                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'URL da imagem do produto'),
                              textInputAction: TextInputAction.done,
                              focusNode: _urlFocus,
                              onFieldSubmitted: (_) {
                                // _submitForm();
                              },
                              keyboardType: TextInputType.url,
                              controller: _imageUrlControle,
                              validator: (imagem) {
                                final image = imagem ?? '';
                                if (!isValidUrl(image)) {
                                  return 'Informe uma Url valida';
                                }

                                return null;
                              },
                              onSaved: (imageUrl) =>
                                  _formData['imageUrl'] = imageUrl ?? ''),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(top: 10, left: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1)),
                          alignment: Alignment.center,
                          child: _imageUrlControle.text.isEmpty
                              ? const Text('Informe a url')
                              : FittedBox(
                                  fit: BoxFit.cover,
                                  child: Image.network(
                                    _imageUrlControle.text,
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                        ),
                      ],
                    )
                  ],
                ),
                onChanged: () {},
              ),
            ),
    );
  }
}
