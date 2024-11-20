import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_api/models/Git.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Gif>> _listadoGits;

  @override
  void initState() {
    super.initState();
    _listadoGits = _getGifs();
  }

  Future<List<Gif>> _getGifs() async {
    final response = await http.get(Uri.parse(
        "https://api.giphy.com/v1/gifs/trending?api_key=qzQ3ECiKPI7jZi6uK2WykKIDsXqBzG3c&limit=1&offset=0&rating=g&bundle=messaging_non_clips"));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final gifs =
          (jsonData['data'] as List).map((gif) => Gif.fromJson(gif)).toList();
      return gifs;
    } else {
      throw Exception("Fallo la conexion");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Gifs')),
        body: FutureBuilder<List<Gif>>(
          future: _listadoGits,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No gifs found'));
            } else {
              final gifs = snapshot.data!;
              return ListView.builder(
                itemCount: gifs.length,
                itemBuilder: (context, index) {
                  final gif = gifs[index];
                  return ListTile(
                    title: Text(gif.title),
                    leading: Image.network(gif.url),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
