import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/constants/constants.dart';
import 'package:tmdt/models/address.dart';
import 'package:tmdt/models/checkout.dart';
import 'package:tmdt/services/address.dart';
import 'package:tmdt/ui/address/user_address_card.dart';
import 'package:tmdt/ui/shared/ui/widget.dart';

class ShippingStep extends StatefulWidget {
  final Future<dynamic> Function() onStepContinue;

  const ShippingStep({Key? key, required this.onStepContinue})
      : super(key: key);

  @override
  State<ShippingStep> createState() => _ShippingStepState();
}

class _ShippingStepState extends State<ShippingStep> {
  late Future<List<Address>> futureAddressesList;
  int selectedIndex = -1;

  @override
  void initState() {
    futureAddressesList = fetchUserAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return FutureBuilder(
      future: futureAddressesList,
      builder: (context, snapshot) {
        List<Address> addressesList = List.empty();
        if (snapshot.hasData) {
          addressesList = snapshot.data as List<Address>;
        }
        return snapshot.hasData
            ? Column(children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Select Shipping Address",
                      style: themeData.textTheme.titleLarge,
                    ),
                  ),
                ),
                SizedBox(
                  height: 490,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: [
                          ...(addressesList
                              .asMap()
                              .entries
                              .map(
                                (entry) => InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () => setState(() {
                                    selectedIndex = entry.key;
                                  }),
                                  child: UserAddressCard(
                                    userAddress: entry.value,
                                    borderColor: selectedIndex == entry.key
                                        ? COLOR_BUTTON_AND_LINK_TEXT
                                        : null,
                                  ),
                                ),
                              )
                              .toList()),
                          buildUserAddAddress(
                              context: context, themeData: themeData),
                        ]
                            .map((widget) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: widget,
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: selectedIndex >= 0
                          ? () {
                              Provider.of<CheckoutDetails>(context,
                                      listen: false)
                                  .setAddress = addressesList[selectedIndex];
                              widget.onStepContinue();
                            }
                          : null,
                      child: const Text('Continue to Payment')),
                )
              ])
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
