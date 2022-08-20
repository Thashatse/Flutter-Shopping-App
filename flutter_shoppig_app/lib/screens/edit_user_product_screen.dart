//package
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
//models
import '../models/product_edit_model.dart';

class EditUserProductScreen extends StatefulWidget {
  static const String routeName = '/EditUserProduct';

  EditUserProductScreen({Key? key}) : super(key: key);

  @override
  State<EditUserProductScreen> createState() => _EditUserProductScreenState();
}

class _EditUserProductScreenState extends State<EditUserProductScreen> {
  bool isInit = false;
  var _isLoading = false;
  final _imageUrlControler = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = ProductEditModel();
  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!isInit) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final productId = ModalRoute.of(context)?.settings.arguments as String;
        if (productId.isNotEmpty) {
          final product =
              Provider.of<Products>(context, listen: false).findByID(productId);
          _editedProduct = product.toProductEditModel();
          _initValues = {
            'title': _editedProduct.title,
            'price': _editedProduct.price.toString(),
            'description': _editedProduct.description,
            'imageUrl': '',
          };
          _imageUrlControler.text = _editedProduct.imageUrl;
        }
        isInit = true;
      }
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlControler.dispose();
    _imageUrlFocusNode.removeListener(_updateImage);
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImage() {
    if (_imageUrlControler.text.isNotEmpty &&
        (!(_imageUrlControler.text.startsWith('http') ||
                _imageUrlControler.text.startsWith('https')) ||
            !(_imageUrlControler.text.endsWith('.jpeg') ||
                _imageUrlControler.text.endsWith('.jpg') ||
                _imageUrlControler.text.endsWith('.png')))) return;

    if (!_imageUrlFocusNode.hasFocus) setState(() {});
  }

  void _saveForm() {
    final isValid = _form.currentState?.validate();
    if (!isValid!) return;

    setState(() {
      _isLoading = true;
    });

    _form.currentState?.save();

    Provider.of<Products>(
      context,
      listen: false,
    ).updateProduct(_editedProduct).catchError(
      (error) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Shomthing went wrong!'),
            content: Text('${error.toString()}'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  setState(() {
                    _isLoading = false;
                  });
                },
                child: const Text('Ok'),
              ),
            ],
          ),
        );
      },
    ).then(
      (_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
              onPressed: () => _saveForm(),
              icon: Icon(
                Icons.done,
              ))
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                  key: _form,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        initialValue: _initValues['title'],
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Title is Requiered';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _editedProduct.title =
                              newValue!.isEmpty ? '' : newValue;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Price',
                        ),
                        initialValue: _initValues['price'],
                        keyboardType: TextInputType.numberWithOptions(),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Price is Requiered';
                          } else if (double.tryParse(value) == null) {
                            return 'Price is not a valid number';
                          } else if (double.parse(value) <= 0) {
                            return 'Price must be greater than 0';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _editedProduct.price = double.parse(
                              newValue!.isEmpty ? '0.0' : newValue);
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        initialValue: _initValues['description'],
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Description is Requiered';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _editedProduct.description =
                              newValue!.isEmpty ? '' : newValue;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(
                              top: 8,
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(
                              width: 1,
                              color: Theme.of(context).accentColor,
                            )),
                            child: _imageUrlControler.text.isEmpty
                                ? Text('Enter a Image URL')
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlControler.text,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Image URL',
                              ),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Image URL is Requiered';
                                }

                                if (_imageUrlControler.text.isNotEmpty &&
                                    (!(_imageUrlControler.text
                                                .startsWith('http') ||
                                            _imageUrlControler.text
                                                .startsWith('https')) ||
                                        !(_imageUrlControler.text
                                                .endsWith('.jpeg') ||
                                            _imageUrlControler.text
                                                .endsWith('.jpg') ||
                                            _imageUrlControler.text
                                                .endsWith('.png')))) {
                                  return 'URL is not supported';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _editedProduct.imageUrl =
                                    newValue!.isEmpty ? '' : newValue;
                              },
                              controller: _imageUrlControler,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) => _saveForm(),
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
