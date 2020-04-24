

import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate{

  final peliculasProvider=new PeliculasProvider();



  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones de nuestro appbar

    return [
      IconButton(
        icon: Icon(Icons.clear), 
        onPressed: (){
          query='';
        }
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icono a la izquiera del appbar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
        ), 
      onPressed: (){
        close(context,null);
      }
      );
  }

  @override
  Widget buildResults(BuildContext context) {
    // crea los resultados que se muestran
    return Center();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // sugerencias que aparecen cuando el usuario escribe
    if(query.isEmpty){
      return Container();
    }else{
      return FutureBuilder(
        future: peliculasProvider.buscarPelicula(query),
        builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
          if(snapshot.hasData){
            final peliculas= snapshot.data;
            return ListView(
              children: peliculas.map((pelicula){
                return ListTile(
                  leading: FadeInImage(
                    placeholder: AssetImage('assets/img/no-image.jpg'), 
                    image: NetworkImage(pelicula.getPosterImg()),
                    width: 50.0,
                    fit: BoxFit.contain,
                    ),
                    title: Text(pelicula.title),
                    subtitle: Text(pelicula.originalTitle),
                    onTap: (){
                      close(context, null);
                      pelicula.uniqueId='';
                      Navigator.pushNamed(context, 'detalle',arguments: pelicula);
                    },
                );
              }).toList(),
              );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    }
     
  }


  
}