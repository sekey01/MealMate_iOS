import 'package:flutter/material.dart';
import 'package:mealmate_ios/pages/navpages/searchByCollection.dart';
import 'package:provider/provider.dart';
import '../../models&ReadCollectionModel/cartmodel.dart';
import 'cart.dart';
import 'index.dart';
import 'order.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _pages = [
    Index(),
    Search(),
    Cart(),
    OrderList(),
  ];
  int _currentIndex = 0;

  final TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          backgroundColor: Colors.white,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.blueGrey,
          elevation: 1,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: ImageIcon(
                  color: Colors.blueGrey,
                  AssetImage('assets/Icon/Home.png'),
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: ImageIcon(
                  color: Colors.blueGrey,
                  AssetImage('assets/Icon/Search.png'),
                ),
                label: 'Search'),
            BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Badge(
                  backgroundColor: Colors.green,
                  label: Consumer<CartModel>(
                      builder: (context, value, child) => Text(
                            value.cart.length.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                  child: ImageIcon(
                      color: Colors.blueGrey, AssetImage('assets/Icon/favourite.png')),
                ),
                label: 'Favourites'),
            BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: ImageIcon(
                    color: Colors.blueGrey, AssetImage('assets/Icon/Order.png')),
                label: 'Orders'),
          ],
        ));
  }
}
