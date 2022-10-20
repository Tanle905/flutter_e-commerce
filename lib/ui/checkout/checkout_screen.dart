import 'package:flutter/material.dart';
import 'package:tmdt/ui/checkout/payment_step.dart';
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
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () => onStepContinue(),
        onStepTapped: (currentStep) => setState(() {
          _currentStep = currentStep;
        }),
        type: StepperType.horizontal,
        controlsBuilder: (context, details) => const SizedBox.shrink(),
        steps: <Step>[
          Step(
              title: const Text("Shipping"),
              content: ShippingStep(
                onStepContinue: onStepContinue,
              )),
          Step(
              title: const Text("Payment"),
              content: PaymentStep(
                onStepContinue: onStepContinue,
              )),
          const Step(title: Text("Review"), content: SizedBox.shrink())
        ],
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
