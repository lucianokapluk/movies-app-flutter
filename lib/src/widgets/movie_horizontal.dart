import 'package:flutter/material.dart';
import 'package:flutter_movies/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;

  final Function siguientePage;
  MovieHorizontal({@required this.peliculas, @required this.siguientePage});
  final _pageController =
      new PageController(initialPage: 1, viewportFraction: 0.3);

  @override
  Widget build(BuildContext context) {
    final _screensize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        siguientePage();
      }
    });
    return Container(
      height: _screensize.height * 0.25,
      child: PageView.builder(
        // se renderiza mientras aparecen las moviees
        pageSnapping: false, // keep magnet scroll
        controller: _pageController,
        //children: _tarjetas(),
        itemCount: peliculas.length,
        itemBuilder: (context, i) {
          return _tarjetas(context, peliculas[i]);
        },
      ),
    );
  }

  Widget _tarjetas(context, pelicula) {
    pelicula.uniqueId = '${pelicula.id}-poster';
    final tarjeta = Container(
      margin: EdgeInsets.only(right: 1.0),
      child: Column(
        children: [
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/img/no-image.jpg'),
                image: NetworkImage(pelicula.getPosterImg()),
                fit: BoxFit.cover,
                height: 120.0,
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            pelicula.title,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
    return GestureDetector(
      child: tarjeta,
      onTap: () {
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
    );
  }
}
