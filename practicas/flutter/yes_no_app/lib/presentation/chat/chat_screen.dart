import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage('https://www.google.com/url?sa=i&url=https%3A%2F%2Fus.idyllic.app%2Fgen%2Falexandra-daddario-portrait-155055&psig=AOvVaw0HQXm0Y5fmUTKs_g0OfTD2&ust=1748789327251000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCIDVwor6zY0DFQAAAAAdAAAAABAV'),
          ),
        ),
        title: Text('Mi amor')
      )
    );
  }
}
