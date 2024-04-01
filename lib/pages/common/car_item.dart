import 'package:driveit/pages/cars/car_details_page.dart';
import 'package:driveit/services/cars_service.dart';
import 'package:flutter/material.dart';

class CarItem extends StatelessWidget {
  final Car car;

  const CarItem({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.pink,
          borderRadius: BorderRadius.circular(16.0),
        ),
        height: 200.0,
        child: Center(
          child: Text(
            car.name,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
