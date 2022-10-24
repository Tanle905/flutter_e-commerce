import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:tmdt/constants/constants.dart';
import 'package:tmdt/ui/checkout/checkout_manager.dart';
import 'package:tmdt/services/checkout.dart';
import 'package:tmdt/ui/checkout/checkout_completed.dart';
import 'package:tmdt/ui/order/order_manager.dart';
import 'package:tmdt/ui/shared/ui/icons.dart';
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
  bool _isPaymentCompleted = false;
  bool _isLoading = false;

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
    final CheckoutManager checkoutDetails =
        Provider.of<CheckoutManager>(context);
    final CheckoutManager setCheckoutDetails =
        Provider.of<CheckoutManager>(context, listen: false);
    final OrderManager orderManager =
        Provider.of<OrderManager>(context, listen: false);

    return _isPaymentCompleted
        ? const CheckoutCompleted()
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: 1, color: COLOR_BUTTON_AND_LINK_TEXT)),
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
                        ? _isLoading
                            ? null
                            : () => handlePayment(
                                checkoutDetails: checkoutDetails,
                                setCheckoutDetails: setCheckoutDetails,
                                orderManager: orderManager)
                        : null,
                    child: _isLoading
                        ? loadingIcon(text: "Proceeding Payment...")
                        : const Text('Complete Payment')),
              )
            ],
          );
  }

  Future<dynamic> handlePayment(
      {required CheckoutManager checkoutDetails,
      required CheckoutManager setCheckoutDetails,
      required OrderManager orderManager}) async {
    setState(() {
      _isLoading = true;
    });
    final PaymentMethod paymentMethod = await Stripe.instance
        .createPaymentMethod(PaymentMethodParams.card(
            paymentMethodData: PaymentMethodData(
                billingDetails: BillingDetails(
                    phone: checkoutDetails.address?.phoneNumber.toString(),
                    email: checkoutDetails.user?.email,
                    name: checkoutDetails.address?.fullName,
                    address: Address(
                        city: checkoutDetails.address?.city,
                        country: checkoutDetails.address?.country,
                        line1: null,
                        line2: null,
                        postalCode: null,
                        state: null)))));
    try {
      final intentsResponse = await createPaymentIntents(
          useStripeSDK: true,
          paymentMethodId: paymentMethod.id,
          currency: "USD",
          checkoutDetails: checkoutDetails);
      if (intentsResponse['status'] == 'succeeded') {
        setCheckoutDetails.setOrderStatus = 'pending';
        setCheckoutDetails.setPaymentStatus = 'paid';
        setCheckoutDetails.setCurrency = 'USD';
        orderManager.addOrder(checkoutDetails);
        showSnackbar(context: context, message: "Payment Succeeded!");
        setState(() {
          _isPaymentCompleted = true;
        });
      }
    } catch (error) {
      showSnackbar(context: context, message: error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
