import 'dart:async';
import 'dart:convert';

import 'package:flutter_movies/src/models/actores_model.dart';
import 'package:flutter_movies/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider {
  String _apiKey = '1d99f69c0fca34ee4331805b4205098d';
  String _url = 'api.themoviedb.org';
  String _lenguaje = 'es-ES';
  int _popularesPage = 1;
  bool _cargando = false;

  List<Pelicula> _populares = new List();
  //stream flujo o corriente de datos, el broadcast es para que cualquier componente lo pueda escuchar, sino solo uno
  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  void disposeStream() {
    _popularesStreamController
        ?.close(); // cerrar el stream ? valida si esta vacio
  }

  Future _procesarResponse(Uri url) async {
    final resp = await http.get(url); //espera la respuesta
    final decodedData = json.decode(resp.body); //decodigicar el json
    final peliculasPopulares =
        new Peliculas.fromJsonList(decodedData['results']);

    return peliculasPopulares.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(
      _url,
      '3/movie/now_playing',
      {'api_key': _apiKey, 'language': _lenguaje},
    ); //get endpoint
    final resp = await http.get(url); //espera la respuesta
    final decodedData = json.decode(resp.body); //decodigicar el json
    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getPopulares() async {
    if (_cargando) {
      return [];
    } else {
      _cargando = true;
    }
    _popularesPage++;

    final url = Uri.https(
      _url,
      '3/movie/popular',
      {
        'api_key': _apiKey,
        'language': _lenguaje,
        'page': _popularesPage.toString()
      },
    ); //get endpoint
    final response = await _procesarResponse(url);

    _populares.addAll(response);
    popularesSink(_populares);
    _cargando = false;
    return response;
  }

  Future<List<Actor>> getCast(String peliId) async {
    final url = Uri.https(_url, '3/movie/$peliId/credits',
        {'api_key': _apiKey, 'lenguage': _lenguaje});
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);
    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    final url = Uri.https(
      _url,
      '3/search/movie',
      {
        'api_key': _apiKey,
        'language': _lenguaje,
        'query': query,
      },
    ); //get endpoint
    return await _procesarResponse(url);
  }
}
