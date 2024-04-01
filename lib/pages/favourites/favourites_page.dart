import 'package:driveit/pages/cars/car_details_page.dart';
import 'package:driveit/pages/common/car_item.dart';
import 'package:driveit/services/cars_service.dart';
import 'package:driveit/services/users_service.dart';
import 'package:flutter/material.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  List<Car> _favourites = [];

  @override
  void initState() {
    super.initState();
    _fetchFavourites();
  }

  Future<void> _fetchFavourites() async {
    List<Car> favourites = await UsersService.getCarsFromFavorites();
    setState(() {
      _favourites = favourites;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32.0),
                const Text(
                  "Favourites",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                if (_favourites.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _favourites.map((car) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CarDetailsPage(car: car),
                              ),
                            ).then((_) {
                              _fetchFavourites();
                            });
                          },
                          child: CarItem(car: car));
                    }).toList(),
                  )
                else
                  const Column(children: [
                    Text(
                      "Nothing to show",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "You can add some on the \"Cars\" tab",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
