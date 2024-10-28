import 'package:flutter/material.dart';

import '../models/post.dart';

// ignore: must_be_immutable
class Success extends StatelessWidget {
  Post post;

  // ignore: use_key_in_widget_constructors
  Success({required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20.0,),
        Image.network(
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg', 
          width: 300.0,
        ),
        Text(post.title!, style: TextStyle(fontSize: 26.0)), 
        Text(post.body!),
         Row(children: [
          Icon(Icons.favorite),
          Icon(Icons.audiotrack),
          Icon(Icons.beach_access)
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        )
        ],
    );
  }
}