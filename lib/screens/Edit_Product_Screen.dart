import 'package:flutter/material.dart';
import 'package:shopping_app/providers/product.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  static const routeName = "/editScreen";
  const EditScreen({Key? key}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _priceFocusNode = FocusNode();
  final _descripFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  Product _editedProduct =
      Product(id: '', title: '', description: '', imageUrl: '', price: 0);

  @override
  void initState() {
    // TODO: implement initState
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descripFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  var _initValue = {
    "title": '',
    "description": '',
    "price": '',
    "imageUrl": ''
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      final String? productId =
          ModalRoute.of(context)!.settings.arguments as String?;

      if (productId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .findById(productId.toString());
        _initValue = {
          "title": _editedProduct.title,
          "description": _editedProduct.description,
          "price": _editedProduct.price.toString(),
          "imageUrl": ''
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          _imageUrlController.text.startsWith("http") &&
              _imageUrlController.text.startsWith("https") ||
          _imageUrlController.text.endsWith(".png") &&
              _imageUrlController.text.endsWith(".jpg") &&
              _imageUrlController.text.endsWith("jpeg")) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _SaveForm() async{
    final isValid = _form.currentState!
        .validate(); //it will return true if there are no error massage
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != '') {
     await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try{
         await Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct);
      }catch(error){
        print(error);
          await  showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("an error occured"),
                  content: Text(error.toString()),
                  actions: [
                    TextButton(child: Text("OK"),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    )
                  ]
                ));
      }
      /*finally{
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }*/
    }
          setState(() {
        _isLoading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Editing Product"), actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _SaveForm)
        ]),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(6.0),
                child: Form(
                    key: _form,
                    child: ListView(children: [
                      TextFormField(
                        initialValue: _initValue["title"],
                        decoration: InputDecoration(
                          labelText: "title",
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: value as String,
                              imageUrl: _editedProduct.imageUrl,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              isFavorite: _editedProduct.isFavorite);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "please enter your value ";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                          initialValue: _initValue["price"],
                          decoration: InputDecoration(labelText: "Price"),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _priceFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_descripFocusNode);
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                imageUrl: _editedProduct.imageUrl,
                                description: _editedProduct.description,
                                price: double.parse(value as String),
                                isFavorite: _editedProduct.isFavorite);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter the price";
                            }
                            if (double.tryParse(value) == null) {
                              return "please Enter a valid number";
                            }
                            if (double.parse(value) <= 0) {
                              return "Please enter a number greater than zero";
                            }
                            return null;
                          }),
                      TextFormField(
                          initialValue: _initValue["description"],
                          decoration: InputDecoration(labelText: "Description"),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descripFocusNode,
                          onSaved: (value) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                imageUrl: _editedProduct.imageUrl,
                                description: value as String,
                                price: _editedProduct.price,
                                isFavorite: _editedProduct.isFavorite);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter a description";
                            }
                            if (value.length < 10) {
                              return "should be at least 10 character";
                            }

                            return null;
                          }),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                                width: 100,
                                height: 100,
                                margin:
                                    const EdgeInsets.only(top: 8, right: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    color: Colors.grey),
                                child: _imageUrlController.text.isEmpty
                                    ? Text("Enter a URL")
                                    : FittedBox(
                                        child: Image.network(
                                        _imageUrlController.text,
                                        fit: BoxFit.cover,
                                        alignment: Alignment.center,
                                      ))),
                            Expanded(
                              child: TextFormField(
                                  decoration:
                                      InputDecoration(labelText: 'Image URL'),
                                  keyboardType: TextInputType.url,
                                  textInputAction: TextInputAction.done,
                                  controller: _imageUrlController,
                                  focusNode: _imageUrlFocusNode,
                                  onSaved: (value) {
                                    _editedProduct = Product(
                                        id: _editedProduct.id,
                                        title: _editedProduct.title,
                                        imageUrl: value as String,
                                        description: _editedProduct.description,
                                        price: _editedProduct.price,
                                        isFavorite: _editedProduct.isFavorite);
                                  },
                                  onFieldSubmitted: (_) {
                                    _SaveForm();
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter a Image Url";
                                    }
                                    if (value.startsWith("http://") &&
                                        value.startsWith("https://")) {
                                      return "please Enter a valid URL";
                                    }
                                    if (value.endsWith(".png") &&
                                        value.endsWith(".jpg") &&
                                        value.endsWith("jpeg")) {
                                      return "please enter a valid Image Url";
                                    }
                                    return null;
                                  }),
                            )
                          ])
                    ])),
              ));
  }
}
