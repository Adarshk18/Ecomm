import 'package:eshopee/views/screens/nav_screens/account_screen.dart';
import 'package:eshopee/views/screens/nav_screens/cart_screen.dart';
import 'package:eshopee/views/screens/nav_screens/favourite_screen.dart';
import 'package:eshopee/views/screens/nav_screens/home_screen.dart';
import 'package:eshopee/views/screens/nav_screens/stores_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get _currentUser => _auth.currentUser;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomeScreen(),
      FavoriteScreen(),
      StoresScreen(),
      CartScreen(),
      AccountScreen(
        userName: _currentUser?.displayName ?? 'Guest',
        userEmail: _currentUser?.email ?? 'guest@example.com',
      ),
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        currentIndex: _pageIndex,
        onTap: (value) {
          setState(() {
            _pageIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icons/home.png",
                width: 25,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icons/love.png",
                width: 25,
              ),
              label: "Favourite"),
          BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icons/mart.png",
                width: 25,
              ),
              label: "Stores"),
          BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icons/cart.png",
                width: 25,
              ),
              label: "Cart"),
          BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icons/user.png",
                width: 25,
              ),
              label: "Account"),
        ],
      ),
      body: _pages[_pageIndex],
    );
  }
}
