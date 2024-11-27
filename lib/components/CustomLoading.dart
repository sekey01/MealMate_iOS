import 'package:card_loading/card_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomLoGoLoading extends StatelessWidget {
  const CustomLoGoLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardLoading(
          animationDuration: const Duration(seconds: 5),
          animationDurationTwo: const Duration(seconds: 5),

            borderRadius: BorderRadius.circular(10),
            height: 100,
            child: const Image(
              image: AssetImage("assets/images/logo.png"),
              height: 100, width: 150,
              //borderRadius: BorderRadius.all(Radius.circular(10)),
              //margin: EdgeInsets.only(bottom: 10),
              //animationDuration: Duration(seconds: 2),
            )),
        const Padding(
          padding: EdgeInsets.only(right: 100, left: 100),
          child: LinearProgressIndicator(color: Colors.black, backgroundColor: Colors.white,),
        ),
      ],
    );
  }
}



/// THIS DISPLAYS IF  THE LOADING OUTLOOK FOR EMPTY COLLECTION
class NewSearchLoadingOutLook extends StatelessWidget {
  const NewSearchLoadingOutLook({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: 250,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: LinearProgressIndicator( color: Colors.blueGrey.shade100,),
          ),
          const SizedBox(height: 10),
          Container(
            height: 20,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: LinearProgressIndicator(color: Colors.blueGrey.shade100,),

          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 20,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: LinearProgressIndicator(color: Colors.blueGrey.shade100),

              ),
              const SizedBox(width: 10),
              Container(
                height: 20,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: LinearProgressIndicator(color: Colors.blueGrey.shade100,),

              ),
              const SizedBox(width: 10),
              Container(
                height: 20,
                width: 130,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: LinearProgressIndicator(color: Colors.blueGrey.shade100,),

              ),
            ],
          )
        ],
      ),
    );
  }
}


/// THIS DISPLAYS IF  THE LOADING OUTLOOK FOR COURIER DETAILS
class CourierDetailsLoading extends StatelessWidget {
  const CourierDetailsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 200,
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: 250,
            decoration: BoxDecoration(
              //color: Colors.blueGrey.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 70,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade50,
                    borderRadius: BorderRadius.circular(30),
                  ),
               //   child: Image(image: AssetImage("assets/Icon/no_food_found.png"), height: 50, width: 140,),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                 // child: Image(image: AssetImage("assets/Icon/no_food_found.png"), height: 50, width: 140,),
                ),
              ],
            ),),
          const SizedBox(height: 10),
          Container(
            height: 20,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child:Row(
              children: [
                Container(
                  height: 20,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  //child: LinearProgressIndicator(color: Colors.grey.shade50,),

                ),
                const SizedBox(width: 10),
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius: BorderRadius.circular(50),
                  ),
               //   child: LinearProgressIndicator(color: Colors.grey.shade50,),

                ),
                const SizedBox(width: 10),
                Container(
                  height: 20,
                  width: 110,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                 // child: LinearProgressIndicator(color: Colors.grey.shade50,),

                ),
              ],
            ),

          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 20,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
              //  child: LinearProgressIndicator(color: Colors.grey.shade50,),

              ),
              const SizedBox(width: 10),
              Container(
                height: 40,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
              //  child: LinearProgressIndicator(color: Colors.grey.shade50,),

              ),
              const SizedBox(width: 10),
              Container(
                height: 40,
                width: 110,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
              //  child: LinearProgressIndicator(color: Colors.grey.shade50,),

              ),
            ],
          )
        ],
      ),
    );
  }
}









//// THIS DISPLAYS IF  THE LOADING OUTLOOK FOR EMPTY COLLECTION

class EmptyCollection extends StatefulWidget {
  const EmptyCollection({super.key});

  @override
  State<EmptyCollection> createState() => _EmptyCollectionState();
}

class _EmptyCollectionState extends State<EmptyCollection> {
  @override
  Widget build(BuildContext context) {
    return   CardLoading(
        animationDuration: const Duration(seconds: 5),
        animationDurationTwo: const Duration(seconds: 5),
        cardLoadingTheme: CardLoadingTheme.defaultTheme,
        borderRadius: BorderRadius.circular(10),
        height: 100,
        child: Container(
          height: 200,
          width: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children:[
                  Container(
                    height: 120,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Image(image: AssetImage("assets/Icon/no_food_found.png"), height: 50, width: 140,),
                  ),
                  const Positioned(
                    bottom: 1,
                    left: 45,
                    child:
                  Text("no restaurant in your area yet",
                    style: TextStyle(color: Colors.blueGrey, fontSize: 10,fontWeight: FontWeight.bold,fontFamily: 'Poppins'),)),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 20,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 20,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 20,
                    width: 140,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
    );
  }
}


class SearchLoadingOutLook extends StatelessWidget {
  const SearchLoadingOutLook({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CardLoading(
        borderRadius: BorderRadius.circular(10),
        height: 100,
        child: const Image(
          image: AssetImage("assets/images/logo.png"),
          height: 50, width: 150,
          //borderRadius: BorderRadius.all(Radius.circular(10)),
          //margin: EdgeInsets.only(bottom: 10),
          //animationDuration: Duration(seconds: 2),
        ));
  }
}
