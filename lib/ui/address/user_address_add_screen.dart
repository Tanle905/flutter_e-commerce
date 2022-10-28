import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/models/address.dart';
import 'package:tmdt/services/address.dart';
import 'package:tmdt/ui/shared/styles/input_styles.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';
import 'package:tmdt/ui/shared/ui/scaffold_snackbar.dart';
import 'package:tmdt/ui/user/user_manager.dart';
import 'package:tmdt/utils/validator.util.dart';

class UserAddressAddScreen extends StatefulWidget {
  static const routeName = '/user-address-add';

  const UserAddressAddScreen({Key? key}) : super(key: key);

  @override
  State<UserAddressAddScreen> createState() => _UserAddressAddScreenState();
}

class _UserAddressAddScreenState extends State<UserAddressAddScreen> {
  bool isLoading = false;
  late Future<List<dynamic>> futureCitiesList;
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> addressFormData = {
    'fullName': null,
    'phoneNumber': null,
    'address': null,
    'city': null,
    'country': 'Vietnam'
  };

  @override
  void initState() {
    futureCitiesList = fetchCities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final UserManager userManager =
        Provider.of<UserManager>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
          iconTheme: themeData.iconTheme,
          leading: buildBackIcon(context),
          title: const Text("Add Shipping Address"),
          centerTitle: true,
          titleTextStyle: themeData.textTheme.titleLarge),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                ...buildAddressForm(),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                handleSubmitForm(context, userManager);
                              }
                            },
                      child: isLoading
                          ? loadingIcon(text: "Adding... Please Wait")
                          : const Text('Add Shipping Address')),
                )
              ],
            )),
      ),
    );
  }

  List<Widget> buildAddressForm() {
    return [
      TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: inputStyle(
            context: context,
            label: 'Full Name',
            icon: const Icon(FluentIcons.person_16_regular)),
        onSaved: (newValue) => addressFormData['fullName'] = newValue,
        validator: requiredValidator,
      ),
      TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: inputStyle(
            context: context,
            label: 'Phone Number',
            icon: const Icon(FluentIcons.phone_16_regular)),
        onSaved: (newValue) => addressFormData['phoneNumber'] = newValue,
        keyboardType: TextInputType.number,
        inputFormatters: [numberFormatter],
        validator: requiredValidator,
      ),
      TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: inputStyle(
            context: context,
            label: 'Home Address',
            icon: const Icon(FluentIcons.home_16_regular)),
        onSaved: (newValue) => addressFormData['address'] = newValue,
        validator: requiredValidator,
      ),
      FutureBuilder(
        future: futureCitiesList,
        builder: (context, snapshot) {
          return FormField<String>(
            builder: (FormFieldState<String> state) {
              return InputDecorator(
                decoration: inputStyle(
                    icon: const Icon(FluentIcons.city_16_regular),
                    label: 'City',
                    context: context),
                isEmpty: addressFormData['city'] == null,
                child: DropdownButtonHideUnderline(
                  child: snapshot.hasData
                      ? DropdownButton<String>(
                          itemHeight: 50,
                          value: addressFormData['city'],
                          isDense: true,
                          onChanged: (newValue) {
                            setState(() {
                              addressFormData['city'] = newValue;
                            });
                          },
                          items: (snapshot.data as List).map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )
                      : Center(
                          child: loadingIcon(text: "Loading cities..."),
                        ),
                ),
              );
            },
          );
        },
      )
    ]
        .map((widget) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: widget,
            ))
        .toList();
  }

  void handleSubmitForm(BuildContext context, UserManager userManager) async {
    try {
      _formKey.currentState?.save();
      final response = await addUserAddress(addressFormData);
      userManager.setUser = response;
      Navigator.of(context).pop();
      showSnackbar(
          context: context, message: 'Shipping address added successfully!');
    } catch (error) {
      rethrow;
      // showSnackbar(context: context, message: (error as dynamic)['message']);
    }
  }
}
