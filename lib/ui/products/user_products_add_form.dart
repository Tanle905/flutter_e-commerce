import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/models/products.dart';
import 'package:tmdt/services/products.dart';
import 'package:tmdt/ui/screens.dart';
import 'package:tmdt/ui/shared/styles/input_styles.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';
import 'package:tmdt/ui/shared/ui/scaffold_snackbar.dart';
import 'package:tmdt/utils/validator.util.dart';

class UserProductAddForm extends StatefulWidget {
  final Product? initalData;
  const UserProductAddForm({Key? key, this.initalData}) : super(key: key);
  @override
  State<UserProductAddForm> createState() => _UserProductAddFormState();
}

class _UserProductAddFormState extends State<UserProductAddForm> {
  final _formKey = GlobalKey<FormState>();
  final storageRef = FirebaseStorage.instance.ref();
  Map formData = {
    'title': null,
    'description': null,
    'price': null,
    'imageUrl': null,
    'productQuantity': null
  };
  File imagefile = File('');
  late Image productImage;
  bool isLoading = false;
  bool isImageValid = false;
  bool isEditingProduct = false;

  @override
  void initState() {
    super.initState();
    if (widget.initalData != null) {
      formData = {
        'productId': widget.initalData?.productId,
        'title': widget.initalData?.title,
        'description': widget.initalData?.description,
        'price': widget.initalData?.price,
        'productQuantity': widget.initalData?.productQuantity,
        'imageUrl': widget.initalData?.imageUrl
      };
      if (widget.initalData?.imageUrl != null) {
        productImage = Image.network(widget.initalData?.imageUrl as String);
        isImageValid = true;
      }
      isEditingProduct = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ProductManager productManager =
        Provider.of<ProductManager>(context, listen: false);
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SizedBox(
                height: 200,
                child: isImageValid ? productImage : null,
              ),
            ),
            ...productsAddInputList().map((widget) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: widget,
                )),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            handleSubmitForm(context, productManager);
                          },
                    child: isLoading
                        ? loadingIcon(text: 'Loading')
                        : const Text('Submit')),
              ),
            )
          ],
        ));
  }

  List<Widget> productsAddInputList() {
    return [
      TextFormField(
        initialValue: formData['title'],
        onSaved: (newValue) => formData['title'] = newValue,
        validator: requiredValidator,
        decoration: inputStyle(context: context, label: 'Title *'),
      ),
      TextFormField(
        initialValue: formData['description'],
        onSaved: (newValue) => formData['description'] = newValue,
        validator: requiredValidator,
        decoration: inputStyle(context: context, label: 'Description *'),
        maxLines: 7,
      ),
      TextFormField(
        initialValue: formData['productQuantity']?.toString(),
        onSaved: (newValue) => formData['productQuantity'] = newValue,
        validator: requiredValidator,
        decoration: inputStyle(context: context, label: 'Quantity *'),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[numberFormatter],
      ),
      TextFormField(
        initialValue: formData['price']?.toString(),
        onSaved: (newValue) => formData['price'] = newValue,
        validator: requiredValidator,
        decoration: inputStyle(context: context, label: 'Price *'),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[numberFormatter],
      ),
      ElevatedButton(onPressed: selectImage, child: const Text('Upload Image'))
    ];
  }

  void selectImage() async {
    final imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 10);
    try {
      if (image?.path != null) {
        setState(() {
          imagefile = File(image?.path as String);
          productImage = Image.file(imagefile);
          isImageValid = true;
        });
      }
    } catch (error) {
      rethrow;
    }
  }

  Future handleSubmitForm(
      BuildContext context, ProductManager productManager) async {
    if ((_formKey.currentState?.validate() ?? false) && isImageValid) {
      setState(() {
        isLoading = true;
      });
      try {
        if (!isEditingProduct) {
          final imageRef = storageRef.child(
              'images/product/${imagefile.path.substring(imagefile.path.lastIndexOf('/'), imagefile.path.length - 1)}');
          await imageRef.putFile(imagefile);
          formData['imageUrl'] = await imageRef.getDownloadURL();
        }
        _formKey.currentState?.save();
        isEditingProduct
            ? await updateProduct(
                payload: formData, productId: formData['productId'])
            : await postProduct(formData);
        _formKey.currentState?.reset();
        if (!isEditingProduct) {
          setState(() {
            imagefile = File('');
            isLoading = false;
            isImageValid = false;
          });
        }
        productManager.updateProduct(widget.initalData as Product);
        showSnackbar(
            context: context, message: "Product added/edited successfully!");
      } catch (error, stackTrace) {
        showSnackbar(context: context, message: "Error adding/editing product");
        throw ('$error\n$stackTrace');
      }
      setState(() {
        isLoading = false;
      });
    } else if (!isImageValid) {
      showSnackbar(context: context, message: 'Please add product image!');
    }
  }
}
