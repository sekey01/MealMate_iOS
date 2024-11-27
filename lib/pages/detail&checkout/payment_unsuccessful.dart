import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PaymentUnsuccessful extends StatefulWidget {
  const PaymentUnsuccessful({super.key});

  @override
  State<PaymentUnsuccessful> createState() => _PaymentUnsuccessfulState();
}

class _PaymentUnsuccessfulState extends State<PaymentUnsuccessful> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [

            LottieBuilder.asset('assets/Icon/unsuccessful.json'),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Payment Unsuccessful',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,

                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Your payment was unsuccessful. Please try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
