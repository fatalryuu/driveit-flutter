import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImagesSlider extends StatefulWidget {
  final List<String> images;

  const ImagesSlider({super.key, required this.images});

  @override
  State<ImagesSlider> createState() => _ImagesSliderState();
}

class _ImagesSliderState extends State<ImagesSlider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CarouselSlider.builder(
              itemCount: widget.images.length,
              itemBuilder: (context, index, realIndex) {
                final urlImage = widget.images[index];
                return buildImage(urlImage, index);
              },
              options: CarouselOptions(
                height: 180,
              )),
        ],
      ),
    ));
  }

  Widget buildImage(String urlImage, int index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Image.network(urlImage, fit: BoxFit.cover),
      );
}
