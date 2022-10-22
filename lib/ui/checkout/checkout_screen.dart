import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/models/cart.dart';
import 'package:tmdt/models/checkout.dart';
import 'package:tmdt/models/user.dart';
import 'package:tmdt/ui/cart/cart_manager.dart';
import 'package:tmdt/ui/checkout/payment_step.dart';
import 'package:tmdt/ui/checkout/review_step.dart';
import 'package:tmdt/ui/checkout/shipping_step.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';

class CheckoutScreen extends StatefulWidget {
  static const String routeName = '/checkout-screen';
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final CartList cartList = Provider.of<CartList>(context);
    final UserModel userModel = Provider.of<UserModel>(context);
    final CheckoutDetails checkoutDetails = CheckoutDetails(
        user: userModel.getUser, totalPrice: CartManager(cartList).totalAmount);
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: buildBackIcon(context),
        title: const Text("Checkout"),
        centerTitle: true,
        titleTextStyle: themeData.textTheme.titleLarge,
        iconTheme: themeData.iconTheme,
      ),
      backgroundColor: themeData.backgroundColor,
      body: ChangeNotifierProvider.value(
        value: checkoutDetails,
        child: Theme(
            data: themeData,
            child: Stepper(
              onStepTapped: null,
              currentStep: _currentStep,
              onStepContinue: () => onStepContinue(),
              type: StepperType.horizontal,
              controlsBuilder: (context, details) => const SizedBox.shrink(),
              steps: <Step>[
                Step(
                    title: const Text("Shipping"),
                    content: ShippingStep(
                      onStepContinue: onStepContinue,
                    )),
                Step(
                    title: const Text("Review"),
                    content: ReviewStep(onStepContinue: onStepContinue)),
                Step(
                    title: const Text("Payment"),
                    content: PaymentStep(
                      onStepContinue: onStepContinue,
                    )),
              ],
            )),
      ),
    );
  }

  Future<dynamic> onStepContinue() async {
    if (_currentStep < 2) {
      setState(() {
        _currentStep += 1;
      });
    }
  }
}
