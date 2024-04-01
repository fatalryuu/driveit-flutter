import 'package:driveit/pages/cars/car_details_page.dart';
import 'package:driveit/pages/common/car_item.dart';
import 'package:driveit/services/cars_service.dart';
import 'package:flutter/material.dart';

class CarsPage extends StatefulWidget {
  const CarsPage({super.key});

  @override
  State<CarsPage> createState() => _CarsPageState();
}

class _CarsPageState extends State<CarsPage> {
  List<Car> _cars = [];
  String _search = "";

  @override
  void initState() {
    super.initState();
    _fetchCars();
  }

  Future<void> _fetchCars() async {
    List<Car> cars = await CarsService.getCars();
    setState(() {
      _cars = cars;
    });
  }

  List<Car> _filteredCars() {
    return _cars.where((car) {
      final name = car.name.toLowerCase();
      final filter = _search.toLowerCase();
      return name.contains(filter);
    }).toList();
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
                  "Cars",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17.0),
                    child: SizedBox(
                        child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _search = value;
                            });
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search...",
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.only(bottom: 5.0),
                          ),
                          cursorColor: Colors.white,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500),
                          autocorrect: false,
                        ),
                      ),
                    ))),
                const SizedBox(height: 12.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _filteredCars().map((car) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CarDetailsPage(car: car),
                            ),
                          );
                        },
                        child: CarItem(car: car));
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
