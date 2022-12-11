import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/constants/constants.dart';
import 'package:tmdt/models/cart.dart';
import 'package:tmdt/models/user.dart';
import 'package:tmdt/services/review.dart';
import 'package:tmdt/ui/shared/styles/input_styles.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';
import 'package:tmdt/ui/shared/ui/scaffold_snackbar.dart';
import 'package:tmdt/ui/user/user_manager.dart';
import 'package:tmdt/utils/validator.util.dart';

class ProductReviewAddScreen extends StatefulWidget {
  static const routename = '/product-review-add-screen';
  const ProductReviewAddScreen({super.key});

  @override
  State<ProductReviewAddScreen> createState() => _ProductReviewAddScreenState();
}

class _ProductReviewAddScreenState extends State<ProductReviewAddScreen> {
  final formKey = GlobalKey<FormState>();
  final storageRef = FirebaseStorage.instance.ref();
  List<File> imagefileList = List.empty(growable: true);
  List<Map> productImageList = List.empty(growable: true);
  bool isLoading = false;
  bool isEditingProduct = false;
  double stars = 5.0;
  Map formData = {
    'userId': null,
    'username': null,
    'productId': null,
    'imageUrl': List.empty(growable: true),
    'description': '',
    'stars': 5.0
  };

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserManager>(context).getUser as User;
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    final CartItem cartItem =
        ModalRoute.of(context)?.settings.arguments as CartItem;

    return Scaffold(
      appBar: AppBar(
        leading: buildBackIcon(context),
        title: Text(
          "Add Review For ${cartItem.title}",
          overflow: TextOverflow.ellipsis,
        ),
        titleTextStyle: textTheme.titleLarge,
        centerTitle: true,
        iconTheme: themeData.iconTheme,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              productImageList.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: productImageList
                              .map((image) => Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: SizedBox(
                                            height: 150,
                                            child: image['image'],
                                          ),
                                        ),
                                        Positioned(
                                            top: 0,
                                            right: 0,
                                            child: IconButton(
                                              onPressed: () => deleteImage(
                                                  image, image['path']),
                                              icon: Icon(
                                                Icons.close,
                                                color: COLOR_BACKGROUND,
                                                size: 20,
                                              ),
                                            ))
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    )
                  : const SizedBox(
                      height: 170,
                    ),
              SizedBox(
                width: double.infinity,
                child: Align(
                  alignment: Alignment.center,
                  child: StarRating(
                    rating: stars,
                    onRatingChanged: (rating) {
                      setState(() => stars = rating);
                    },
                  ),
                ),
              ),
              ...reviewAddInputList(formData),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              handleSubmitForm(
                                      context, formData, user, cartItem)
                                  .then((value) => Navigator.of(context).pop());
                            },
                      child: isLoading
                          ? loadingIcon(text: 'Loading')
                          : const Text('Submit')),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  List<Widget> reviewAddInputList(Map formData) {
    return [
      TextFormField(
        initialValue: formData['description'],
        onSaved: (newValue) => formData['description'] = newValue,
        validator: requiredValidator,
        decoration: inputStyle(context: context, label: 'Description *'),
        maxLines: 7,
      ),
      Align(
        alignment: Alignment.center,
        child: ElevatedButton(
            onPressed:
                imagefileList.length < IMAGE_UPLOAD_LIMIT ? selectImage : null,
            child: const Text('Upload Image')),
      )
    ];
  }

  void selectImage() async {
    final imagePicker = ImagePicker();
    final List<XFile?> imageList =
        await imagePicker.pickMultiImage(imageQuality: 10);
    try {
      for (var image in imageList) {
        if (image?.path != null) {
          setState(() {
            final File imagefile = File(image?.path as String);
            imagefileList.add(imagefile);
            productImageList
                .add({'image': Image.file(imagefile), 'path': imagefile});
          });
        }
      }
    } catch (error) {
      rethrow;
    }
  }

  void deleteImage(Map image, File path) {
    setState(() {
      productImageList.removeWhere(
        (element) => element == image,
      );
      imagefileList.removeWhere(
        (element) => element == path,
      );
    });
  }

  Future handleSubmitForm(
      BuildContext context, Map formData, User user, CartItem cartItem) async {
    if ((formKey.currentState?.validate() ?? false)) {
      setState(() {
        isLoading = true;
      });
      try {
        final imageRefList = imagefileList.map((image) => {
              'ref': storageRef.child(
                  'images/review/${image.path.substring(image.path.lastIndexOf('/'), image.path.length - 1)}'),
              'file': image
            });
        for (var imageRef in imageRefList) {
          await (imageRef['ref'] as Reference)
              .putFile(imageRef['file'] as File);
        }
        for (var imageRef in imageRefList) {
          (formData['imageUrl'] as List)
              .add(await (imageRef['ref'] as Reference).getDownloadURL());
        }
        formKey.currentState?.save();
        formData['stars'] = stars;
        formData['userId'] = user.userId;
        formData['username'] = user.username;
        formData['productId'] = cartItem.productId;

        await ReviewService().postReview(formData);
        setState(() {
          imagefileList = List.empty(growable: true);
          isLoading = false;
        });

        showSnackbar(context: context, message: "Review added successfully!");
      } catch (error, stackTrace) {
        showSnackbar(context: context, message: "Error adding review");
        throw ('$error\n$stackTrace');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
