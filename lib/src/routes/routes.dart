import 'package:flutter/material.dart';
import 'package:flutter_movies/src/pages/home_page.dart';
import 'package:flutter_movies/src/pages/pelicula_detalle.dart';

getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => HomePage(),
    'detalle': (BuildContext context) => PeliculaDetalle(),
  };
}
