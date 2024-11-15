import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Post>? futurePost;
  final TextEditingController _controller = TextEditingController();

  Future<Post> fetchData(int id) async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/$id');
    final response = await http.get(url);
    await Future.delayed(const Duration(seconds: 4));
    if (response.statusCode == 200) {
      return Post(response.body);
    } else {
      throw Exception('Error al cargar datos');
    }
  }

  void loadPost() {
    final id = int.tryParse(_controller.text);
    if (id != null) {
      setState(() {
        futurePost = fetchData(id);
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ID no válido'),
          content: const Text('Por favor ingresa un número válido de ID.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.purple,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Buscar Post por ID',
              style: TextStyle(color: Colors.purple)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Ingrese el ID del post',
                  labelStyle: TextStyle(color: Colors.purple),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: loadPost,
                child: const Text('Buscar',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: FutureBuilder<Post>(
                  future: futurePost,
                  builder:
                      (BuildContext context, AsyncSnapshot<Post> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loading();
                    } else if (snapshot.hasError) {
                      return const Errordatos();
                    } else if (snapshot.hasData) {
                      return Success(post: snapshot.data!);
                    } else {
                      return const Center(
                          child: Text('Ingrese un ID para buscar un post.',
                              style: TextStyle(color: Colors.white)));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// POST

class Post {
  int? userId;
  int? id;
  String? title;
  String? body;

  Post(String jsonString) {
    Map data = jsonDecode(jsonString);
    userId = data['userId'];
    id = data['id'];
    title = data['title'];
    body = data['body'];
  }
}

// ErrorDatos
class Errordatos extends StatelessWidget {
  const Errordatos({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Mira bien lo que estas haciendo (ERROR!)',
          style: TextStyle(color: Colors.redAccent)),
    );
  }
}

// Loading
class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.purple),
          SizedBox(height: 10),
          Text('Cargando datos...', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

// Success
class Success extends StatelessWidget {
  final Post post;

  const Success({required this.post});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            Image.network(
              'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
              width: 300.0,
            ),
            const SizedBox(height: 40.0),
            Text(
              post.title!,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            Text(
              post.body!,
              style: const TextStyle(fontSize: 15.0, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.favorite, color: Colors.red),
                Icon(Icons.audiotrack, color: Colors.blue),
                Icon(Icons.beach_access, color: Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
