import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/widgets/cast_horizontal.dart';

class PeliculaDetalle extends StatelessWidget {
  final peliculasProvider = new PeliculasProvider();
  @override
  Widget build(BuildContext context) {

    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;
    final mediaQuery = MediaQuery.of(context);
    final availableWidth = mediaQuery.size.width - 160;

    return Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            _crearAppBar(pelicula, availableWidth),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(height: 10,),
                  _posterTitulo(pelicula, context),
                  _descripcion(pelicula),
                  _crearCasting(pelicula, context)
                ]
              ),
            )
          ],
        ),
      );
  }

  Widget _crearAppBar(Pelicula pelicula, availableWidth) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: availableWidth
          ),
          child: Text(
            pelicula.title,
            
            style: TextStyle(color: Colors.white, fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        background: FadeInImage(
          image: NetworkImage(pelicula.getBackgroundImg()),
          placeholder: AssetImage('assets/img/loading.gif'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(Pelicula pelicula, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
              image: NetworkImage(pelicula.getImagePath()),
              height: 150,
            ),
          ),
          SizedBox(width: 20),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(pelicula.title, style: Theme.of(context).textTheme.title),
                Row(
                  children: <Widget>[
                    Text('Calificacion:', style: Theme.of(context).textTheme.subhead,),
                    Icon(Icons.star_border),
                    Text(pelicula.voteAverage.toString(), style: Theme.of(context).textTheme.subhead,)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _descripcion(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _crearCasting(Pelicula pelicula, BuildContext context) {

    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Text('Cast', style: Theme.of(context).textTheme.subhead),
          SizedBox(height: 5),
          FutureBuilder(
            future: peliculasProvider.getCast(pelicula.id.toString()),
            builder: (BuildContext context, AsyncSnapshot<List<Actor>> snapshot) {
              if (snapshot.hasData) {
                return CastHorizontal(actores: snapshot.data);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        ],
      ),
    );

  }

}