import 'package:flutter/material.dart';

class MealMate extends StatelessWidget {
  const MealMate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          RichText(
            text: const TextSpan(
              text: ' Meal',
              style: TextStyle(
                fontFamily: 'Righteous',
                letterSpacing: 3,
                fontSize: 25,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          RichText(
            text: TextSpan(

                text: 'Mate 🍕 ',
                style: TextStyle(
                  fontFamily: 'Righteous',
                  letterSpacing: 3,
                  fontSize: 25,
                  color: Colors.deepOrangeAccent,
                  fontWeight: FontWeight.bold,
                )),
          )
        ]),
      ),
    );
  }
}
