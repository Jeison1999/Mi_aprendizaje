import 'package:flutter/material.dart';
import 'package:yes_no_app/presentation/widgets/chat/my_message_bubble.dart';
import 'package:yes_no_app/presentation/widgets/shared/message_field_box.dart';

import '../../widgets/chat/her_message_bubbble.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              'https://media.themoviedb.org/t/p/w500/lh5zibQXYH1MNqkuX8TmxyNYHhK.jpg',
            ),
          ),
        ),
        title: Text('Mi amor'),
      ),
      body: _ChatView(),
    );
  }
}

class _ChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return index % 2 == 0
                  ? MyMessageBubble()
                  : HerMessageBubble()
                  ;
                },
              ),
            ),

            /// Caja de texto
            MessageFieldBox(),
          ],
        ),
      ),
    );
  }
}
