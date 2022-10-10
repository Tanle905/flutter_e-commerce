import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tmdt/services/products.dart';
import 'package:tmdt/ui/shared/styles/input_styles.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';
import 'package:tmdt/ui/shared/ui/scaffold_snackbar.dart';
import 'package:tmdt/utils/validator.util.dart';

class UserProductAddForm extends StatefulWidget {
  const UserProductAddForm({Key? key}) : super(key: key);

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
    'imageUrl': null
  };
  File imagefile = File('');
  late Image productImage;
  bool isLoading = false;
  bool isImageValid = false;

  @override
  Widget build(BuildContext context) {
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
            ElevatedButton(
                onPressed: () {
                  isLoading ? null : handleSubmitForm(context);
                },
                child: isLoading
                    ? loadingIcon(text: 'Loading')
                    : const Text('Submit'))
          ],
        ));
  }

  List<Widget> productsAddInputList() {
    return [
      TextFormField(
        onSaved: (newValue) => formData['title'] = newValue,
        validator: requiredValidator,
        decoration: inputStyle(context: context, label: 'Title *'),
      ),
      TextFormField(
        onSaved: (newValue) => formData['description'] = newValue,
        validator: requiredValidator,
        decoration: inputStyle(context: context, label: 'Description *'),
        maxLines: 5,
      ),
      TextFormField(
        onSaved: (newValue) => formData['price'] = newValue,
        validator: requiredValidator,
        decoration: inputStyle(context: context, label: 'Price *'),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
        ],
      ),
      ElevatedButton(onPressed: selectImage, child: const Text('Upload Image'))
    ];
  }

  void selectImage() async {
    final imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 25);
    try {
      setState(() {
        imagefile = File(image!.path);
        productImage = Image.file(imagefile);
        isImageValid = true;
      });
    } catch (error) {
      rethrow;
    }
  }

  Future handleSubmitForm(BuildContext context) async {
    if (_formKey.currentState!.validate() && isImageValid) {
      setState(() {
        isLoading = true;
      });
      try {
        final imageRef = storageRef.child(
            'images/product/${imagefile.path.substring(imagefile.path.lastIndexOf('/'), imagefile.path.length - 1)}');
        await imageRef.putFile(imagefile);
        formData['imageUrl'] = await imageRef.getDownloadURL();
        _formKey.currentState!.save();
        await postProduct(formData);
        _formKey.currentState?.reset();
        showSnackbar(
            context: context, message: "Product added/edited successfully!");
        setState(() {
          imagefile.writeAsStringSync('');
          isLoading = false;
          isImageValid = false;
        });
      } catch (error, stackTrace) {
        setState(() {
          isLoading = false;
        });
        showSnackbar(context: context, message: "Error adding/editing product");
        throw ('$error\n$stackTrace');
      }
    } else if (!isImageValid) {
      showSnackbar(context: context, message: 'Please add product image!');
    }
  }
}
