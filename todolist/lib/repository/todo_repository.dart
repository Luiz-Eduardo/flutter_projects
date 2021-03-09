import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/model/todo_model.dart';

class TodoRepository{
  Database db;
  List<TodoModel> todoList;
  StreamController<bool> readyStream = StreamController();
  TextEditingController title = TextEditingController();

  TodoRepository(){
    readyStream.add(false);
    openDatabase("todo_db.db", version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
        create table todo ( 
          id integer primary key autoincrement, 
          title text not null,
          done integer not null)
        '''
          );
        }).then(
            (value) {
          db = value;
          db.query("todo").then(
                  (value){
                todoList = value.map((e) => TodoModel.fromMap(e)).toList();
                readyStream.add(true);
              }
          );
        });
  }

  Future<bool> update(TodoModel model) async {
    try{
      var resp = await db.update("todo", model.toMap(), where: "id = ?", whereArgs: [model.id]);

      if(resp == 1){
        todoList.removeWhere((element) => element.id == model.id);
        todoList.add(model);

        return true;
      }else{
        return false;
      }
    }
    catch(e){
      return false;
    }
  }

  Future<TodoModel> insert(TodoModel model) async {
    try {
      int id = await db.insert("todo", model.toMap());

      todoList.add(model..id = id);

      return model..id = id;
    } catch(e){
      return null;
    }
  }

  Future<bool> remove(TodoModel model) async{
    try {
      int resp = await db.delete("todo", where: "id = ?", whereArgs: [model.id]);

      if(resp == 1){
        todoList.removeWhere((element) => element.id == model.id);
        return true;
      } else {
        return false;
      }
    } catch(e){
      return null;
    }
  }

  dispose(){
    readyStream.close();
  }

}