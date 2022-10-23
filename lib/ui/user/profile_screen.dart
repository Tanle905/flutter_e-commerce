import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/constants/constants.dart';
import 'package:tmdt/models/user.dart';
import 'package:tmdt/services/user.dart';
import 'package:tmdt/ui/address/user_address_screen.dart';
import 'package:tmdt/ui/drawer/drawer.dart';
import 'package:tmdt/ui/shared/styles/input_styles.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';
import 'package:tmdt/ui/shared/ui/scaffold_snackbar.dart';
import 'package:tmdt/utils/validator.util.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({Key? key}) : super(key: key);
  static const routeName = '/user-settings';

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final storageRef = FirebaseStorage.instance.ref();
  final _formKey = GlobalKey<FormState>();
  late Future<User?> futureUserProfile;
  final Map userSettingsFormData = {
    'username': null,
    'email': null,
    'phoneNumber': null,
    'imageUrl': null
  };
  bool isLoading = false;
  File imagefile = File('');
  Image avatar = const Image(
    image: IMAGE_PLACEHOLDER,
  );

  @override
  void initState() {
    super.initState();
    futureUserProfile = fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      backgroundColor: themeData.backgroundColor,
      appBar: AppBar(
        leading: Builder(
          builder: (context) => buildDrawerIcon(context),
        ),
        title: Text(
          'User settings',
          style: textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: futureUserProfile,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final User userInfo = snapshot.data as User;
            userSettingsFormData
                .updateAll((key, value) => value = userInfo.toJson()[key]);
            imagefile.exists().then((value) {
              if (userInfo.imageUrl != null && !value) {
                setState(() {
                  avatar = Image.network(userInfo.imageUrl as String);
                });
              }
            });
          }

          return snapshot.hasData
              ? SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: SizedBox(
                                width: 150,
                                height: 150,
                                child: InkWell(
                                  onTap: selectImage,
                                  splashColor: Colors.white10,
                                  child: avatar,
                                ),
                              )),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20)),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: userSettingsInputList()
                                  .map((item) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: item,
                                      ))
                                  .toList(),
                            ),
                          )
                        ],
                      )))
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
      drawer: const NavigationDrawer(),
    );
  }

  List<Widget> userSettingsInputList() {
    return [
      TextFormField(
        initialValue: userSettingsFormData['username'],
        decoration: inputStyle(
            context: context,
            label: 'Username',
            icon: const Icon(FluentIcons.person_16_regular)),
        onSaved: (newValue) => userSettingsFormData['username'] = newValue,
        validator: requiredValidator,
      ),
      TextFormField(
        initialValue: userSettingsFormData['email'],
        decoration: inputStyle(
            context: context,
            label: 'Email',
            icon: const Icon(FluentIcons.mail_16_regular)),
        onSaved: (newValue) => userSettingsFormData['email'] = newValue,
        validator: requiredValidator,
      ),
      TextFormField(
        initialValue: userSettingsFormData['phoneNumber']?.toString(),
        keyboardType: TextInputType.number,
        inputFormatters: [numberFormatter],
        decoration: inputStyle(
            context: context,
            label: 'Phone Number',
            icon: const Icon(FluentIcons.phone_16_regular)),
        onSaved: (newValue) => userSettingsFormData['phoneNumber'] = newValue,
      ),
      SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(UserAddressScreen.routeName),
            child: const Text('Go to Shipping Address')),
      ),
      const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
      SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
            onPressed: isLoading ? null : () => handleSubmitForm(context),
            child: isLoading
                ? loadingIcon(text: "Updating Account...")
                : const Text('Update Account')),
      )
    ];
  }

  void selectImage() async {
    final imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 10);
    try {
      if (image != null) {
        setState(() {
          imagefile = File(image.path);
          avatar = Image.file(
            imagefile,
            fit: BoxFit.cover,
          );
        });
      }
    } catch (error) {
      rethrow;
    }
  }

  Future handleSubmitForm(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState?.validate() ?? false) {
      try {
        if (await imagefile.exists()) {
          final imageRef = storageRef.child(
              'images/user/${imagefile.path.substring(imagefile.path.lastIndexOf('/'), imagefile.path.length)}');
          await imageRef.putFile(imagefile);
          userSettingsFormData['imageUrl'] = await imageRef.getDownloadURL();
        }
        _formKey.currentState?.save();
        await updateUserProfile(userSettingsFormData).then((user) {
          Provider.of<UserManager>(context, listen: false).setUser = user;
        });
        showSnackbar(context: context, message: USER_SETTINGS_SAVED_SUCCESSFUL);
      } catch (error, stackTrace) {
        setState(() {
          isLoading = false;
        });
        showSnackbar(context: context, message: USER_SETTINGS_SAVED_FAILED);
        throw ('$error\n$stackTrace');
      }
    }
    setState(() {
      isLoading = false;
    });
  }
}
