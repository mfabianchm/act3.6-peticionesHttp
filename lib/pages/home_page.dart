import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peticiones_http/model/pokemon.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  List<Pokemon> pokemons = [];

  Future getData() async {
    var response = await http
        .get(Uri.https('pokeapi.co', '/api/v2/pokemon', {'q': 'limit=20'}));
    var jsonData = jsonDecode(response.body);

    for (var eachPokemon in jsonData['results']) {
      final pokemon =
          Pokemon(name: eachPokemon['name'], path: eachPokemon['url']);
      pokemons.add(pokemon);
    }
    print(pokemons.length);
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
        body: FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            itemCount: pokemons.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(pokemons[index].name),
                subtitle: Text(pokemons[index].path),
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ));
  }
}
