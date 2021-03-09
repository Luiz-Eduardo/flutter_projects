import 'dart:convert';

class TodoModel {
  String title;
  bool done;
  int id;

  TodoModel({
    this.title,
    this.done,
    this.id,
  });



  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'done': done ? 1 : 0,
      'id': id,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TodoModel(
      title: map['title'],
      done: map['done'] == 0 ? false : true,
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoModel.fromJson(String source) => TodoModel.fromMap(json.decode(source));
}