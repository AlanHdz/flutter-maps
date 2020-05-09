import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {

  String _apiKey = 'a81508f1ec45bc21e09e5cb62d54776b';
  String _url = 'api.themoviedb.org';
  String _language = 'es-MX';
  String _region = 'MX';

  int _popularesPage = 0;
  bool _cargando = false;

  //Lista de peliculas de populares
  List<Pelicula> _populares = new List();

  //Stream controller que escuchara una lista de peliculas
  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  //Agrega peliculas al afluente que maneja el stream
  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  //Escuchar peliculas 
  Stream<List<Pelicula>> get popuplaresStream => _popularesStreamController.stream; 

  void disposeStreams() {
    _popularesStreamController?.close();
  }

  //Funcion para la respuesta
  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key' : _apiKey,
      'language' : _language,
      'region' : _region
    });
    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    
    if (_cargando) return [];

    _cargando = true;
    //Incremento de la paginador de peliculas
    _popularesPage++;

    //Hacemos la peticion al servicio pasandole parametros
    final url = Uri.https(_url, '3/movie/popular', {
      'api_key' : _apiKey,
      'language' : _language,
      'region' : _region,
      'page': _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);

    //Agregamos la respuesta a la lista de peliculas populares
    _populares.addAll(resp);

    //Utilizamos el sink para mandarlo al stream de datos
    popularesSink(_populares);
    _cargando = false;
    return resp;
  }

  Future<List<Actor>> getCast(String peliId) async {

    final url = Uri.https(_url, '3/movie/$peliId/credits', {
      'api_key' : _apiKey
    });

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;

  }

}