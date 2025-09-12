import 'package:flutter/material.dart';
import 'package:yes_no_app/domain/entities/message.dart';

class ChatProvider extends ChangeNotifier {
  List<Message> message = [
    Message(text: 'hola mi amor!', fromWho: FromWho.me),
    Message(text: 'hola mi amor!', fromWho: FromWho.me),
  ];

  Future<void> enviarMensaje(String text) async{
    
  }
}
