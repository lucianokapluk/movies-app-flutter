import 'package:flutter/material.dart';
import 'package:flutter_movies/src/models/pelicula_model.dart';
import 'package:flutter_movies/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  final peliculas = ['Spiderman', 'Acuaman', 'Batman', 'Gohost'];
  final peliculasRecientes = ['Spiderman', 'Capitan America'];
  final peliculasProvider = new PeliculasProvider();
  @override
  List<Widget> buildActions(BuildContext context) {
    //las acciones de nuestro app bar, cancelar o cerrar busqueda
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icono a la izquierda del app bar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // builder crea los resultados que vamos a mosatrar
    return Container();
  }

  Widget buildSuggestions(BuildContext context) {
    //son las sugerencias mientras el usuario va escribiendo
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
        future: peliculasProvider.buscarPelicula(query),
        builder:
            (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
          final peliculas = snapshot.data;
          if (snapshot.hasData) {
            return ListView(
              children: peliculas.map(
                (pelicula) {
                  return ListTile(
                      leading: FadeInImage(
                        placeholder: AssetImage('assets/img/no-image.jpg'),
                        image: NetworkImage(
                          pelicula.getPosterImg(),
                        ),
                        width: 50.0,
                        fit: BoxFit.cover,
                      ),
                      title: Text(pelicula.title),
                      subtitle: Text(pelicula.originalTitle),
                      onTap: () {
                        close(context, null);
                        pelicula.uniqueId = '';
                        Navigator.pushNamed(context, 'detalle',
                            arguments: pelicula);
                      });
                },
              ).toList(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
  /*  @override
  Widget buildSuggestions(BuildContext context) {
    //son las sugerencias mientras el usuario va escribiendo
    final listaSugerida = (query.isEmpty)
        ? peliculasRecientes
        : peliculas
            .where((element) =>
                element.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemCount: listaSugerida.length,
      itemBuilder: (context, i) {
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(listaSugerida[i]),
          onTap: () {},
        );
      },
    );
  } */
}
