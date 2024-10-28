import 'dart:convert';

class Post{
  int? userId;
  int? id;
  String? title;
  String? body;

  Post(String jsonString){
    Map data = jsonDecode(jsonString);
    this.userId = data['userId'];
    this.id = data['id'];
    this.title = data['title'];
    this.body = data['body'];
  }
}