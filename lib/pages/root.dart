import 'package:driveit/pages/auth/auth_page.dart';
import 'package:driveit/pages/cars/cars_page.dart';
import 'package:driveit/pages/favourites/favourites_page.dart';
import 'package:driveit/pages/profile/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ProfilePage(),
    CarsPage(),
    FavouritesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Scaffold(
                  body: Center(
                    child: _widgetOptions.elementAt(_selectedIndex),
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    backgroundColor: Colors.black,
                    selectedItemColor: Colors.pink,
                    unselectedItemColor: Colors.grey[600],
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'Profile',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.car_rental),
                        label: 'Cars',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.bookmark),
                        label: 'Favourites',
                      ),
                    ],
                    currentIndex: _selectedIndex,
                    onTap: _onItemTapped,
                    iconSize: 30,
                  ),
                );
              } else {
                return const AuthPage();
              }
            }
        )
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

