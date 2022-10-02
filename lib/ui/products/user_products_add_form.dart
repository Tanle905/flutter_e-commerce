import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tmdt/constants/endpoints.dart';
import 'package:tmdt/services/products.dart';
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
  late File imagefile;
  Image productImage = Image.network(placeholderImage);

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 200,
              child: productImage,
            ),
            ...productsAddInputList().map((widget) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: widget,
                )),
            ElevatedButton(
                onPressed: handleSubmitForm, child: const Text('Submit'))
          ],
        ));
  }

  List<Widget> productsAddInputList() {
    return [
      TextFormField(
        onSaved: (newValue) => formData['title'] = newValue,
        validator: requiredValidator,
        decoration: inputStyle(label: 'Title *'),
      ),
      TextFormField(
        onSaved: (newValue) => formData['description'] = newValue,
        validator: requiredValidator,
        decoration: inputStyle(label: 'Description *'),
        maxLines: 5,
      ),
      TextFormField(
        onSaved: (newValue) => formData['price'] = newValue,
        validator: requiredValidator,
        decoration: inputStyle(label: 'Price *'),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
        ],
      ),
      // TextFormField(
      //   onSaved: (newValue) => formData['imageUrl'] = newValue,
      //   validator: requiredValidator,
      //   decoration: inputStyle(label: 'Image link'),
      // )
      ElevatedButton(onPressed: selectImage, child: const Text('Upload Image'))
    ];
  }

  InputDecoration inputStyle({String? label}) {
    return InputDecoration(
        labelText: label,
        enabledBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        fillColor: Colors.grey.shade300);
  }

  void selectImage() async {
    final imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);
    try {
      setState(() {
        imagefile = File(image!.path);
        productImage = Image.file(imagefile);
      });
    } catch (error) {
      rethrow;
    }
  }

  void handleSubmitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final imageRef = storageRef.child(
            'images/${imagefile.path.substring(imagefile.path.lastIndexOf('/'), imagefile.path.length - 1)}');
        await imageRef.putFile(imagefile);
        formData['imageUrl'] = await imageRef.getDownloadURL();
        _formKey.currentState!.save();
        postProduct(formData);
      } catch (error) {
        rethrow;
      }
    }
  }
}
