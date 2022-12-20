import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:olx/model/anuncio.dart';

class DetalhesAnuncio extends StatefulWidget {
  Anuncio anuncio;
  DetalhesAnuncio({super.key, required this.anuncio});

  @override
  State<DetalhesAnuncio> createState() => _DetalhesAnuncioState();
}

class _DetalhesAnuncioState extends State<DetalhesAnuncio> {
  late Anuncio anuncio;
  CarouselController buttonCarouselController = CarouselController();
  List<Widget> urls() {
    List<String> listaUrls = anuncio.fotos;
    return listaUrls
        .map(
          (e) => Container(
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(e),
                fit: BoxFit.fitWidth,
              ),
            ),
            // child: Image.network(e),
          ),
        )
        .toList();
  }

  @override
  void initState() {
    anuncio = widget.anuncio;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Anúncio"),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              SizedBox(
                height: 250,
                child: CarouselSlider(
                  items: urls(),
                  carouselController: buttonCarouselController,
                  options: CarouselOptions(
                    height: 400,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
