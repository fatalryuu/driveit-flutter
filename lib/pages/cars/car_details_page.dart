import 'package:driveit/pages/cars/images_slider.dart';
import 'package:driveit/pages/common/button.dart';
import 'package:driveit/services/cars_service.dart';
import 'package:driveit/services/users_service.dart';
import 'package:flutter/material.dart';

class CarDetailsPage extends StatefulWidget {
  final Car car;

  const CarDetailsPage({super.key, required this.car});

  @override
  State<CarDetailsPage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  bool _isFavourite = false;
  bool _isLoading = false;
  bool _titleIsOneLine = true;

  Future<void> handleClick() async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (_isFavourite) {
        await UsersService.removeCarFromFavourites(widget.car.id);
      } else {
        await UsersService.addCarToFavourites(widget.car.id);
      }
    } finally {
      setState(() {
        _isLoading = false;
        _isFavourite = !_isFavourite;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getInitIsFavourite();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _titleIsOneLine = _isTitleOneLine(context);
      });
    });
  }

  bool _isTitleOneLine(BuildContext context) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.car.name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 36.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width);

    return !textPainter.didExceedMaxLines;
  }

  Future<void> _getInitIsFavourite() async {
    setState(() {
      _isLoading = true;
    });
    final isFavourite = await UsersService.isCarInFavorites(widget.car.id);
    setState(() {
      _isFavourite = isFavourite;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.pink,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.car.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                if (widget.car.images.isNotEmpty)
                  SizedBox(
                      height: 180,
                      child: ImagesSlider(images: widget.car.images))
                else
                  const Text(
                    "No photos yet",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 16.0),
                const Text(
                  "Description",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6.0),
                Container(
                  height: _titleIsOneLine ? 340 : 280,
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: SingleChildScrollView(
                    child: Text(
                      widget.car.description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                Button(
                  action: handleClick,
                  text: _isFavourite
                      ? "Remove from Favourites"
                      : "Add to Favourites",
                  disabled: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
