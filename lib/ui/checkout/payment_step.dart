import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/constants/constants.dart';
import 'package:tmdt/interface/stripe.interface.dart';
import 'package:tmdt/models/checkout.dart';
import 'package:tmdt/services/checkout.dart';
import 'package:tmdt/ui/shared/ui/scaffold_snackbar.dart';

class PaymentStep extends StatefulWidget {
  final Future<dynamic> Function() onStepContinue;

  const PaymentStep({Key? key, required this.onStepContinue}) : super(key: key);

  @override
  State<PaymentStep> createState() => _PaymentStepState();
}

class _PaymentStepState extends State<PaymentStep> {
  CardFieldInputDetails? _card = const CardFieldInputDetails(complete: false);
  final CardFormEditController _cardController = CardFormEditController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CheckoutDetails checkoutDetails =
        Provider.of<CheckoutDetails>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: COLOR_BUTTON_AND_LINK_TEXT)),
          child: CardFormField(
            onCardChanged: (details) => setState(() {
              _card = details;
            }),
            controller: _cardController,
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
              onPressed: _card?.complete ?? false
                  ? () => handlePayment(checkoutDetails)
                  : null,
              child: const Text('Complete Payment')),
        )
      ],
    );
  }

  Future<dynamic> handlePayment(CheckoutDetails checkoutDetails) async {
    final PaymentMethod paymentMethod = await Stripe.instance
        .createPaymentMethod(PaymentMethodParams.card(
            paymentMethodData: PaymentMethodData(
                billingDetails: BillingDetails(
                    phone: checkoutDetails.address?.phoneNumber.toString(),
                    email: checkoutDetails.user?.email,
                    name: checkoutDetails.user?.username))));
    final intentsResponse = await createPaymentIntents(
        useStripeSDK: true,
        paymentMethodId: paymentMethod.id,
        currency: "USD",
        checkoutDetails: checkoutDetails);
    if (intentsResponse['status'] == 'succeeded') {
      showSnackbar(context: context, message: "Payment Succeeded!");
    }
  }
}
