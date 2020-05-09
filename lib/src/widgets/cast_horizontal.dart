import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';

class CastHorizontal extends StatelessWidget {
  final List<Actor> actores;

  final _pageController = PageController(
    initialPage: 1,
    viewportFraction: 0.3
  );

  CastHorizontal({ @required this.actores });

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      height: _screenSize.height * 0.3,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: actores.length,
        itemBuilder: (context, i) =>  _actor(context, actores[i])
      ),
    );
  }

  Widget _actor(BuildContext context, Actor actor) {
    return Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: AssetImage('assets/img/no-image.jpg'), 
              image: NetworkImage(actor.getFoto()),
              fit: BoxFit.cover,
              height: 160,
            ),
          ),
          SizedBox(height: 5),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );
  }
}