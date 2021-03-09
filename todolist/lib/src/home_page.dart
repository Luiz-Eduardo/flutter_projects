import 'package:flutter/material.dart';
import 'package:todolist/model/todo_model.dart';
import 'package:todolist/repository/todo_repository.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final repository = TodoRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Todo List"),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width*0.7,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    controller: repository.title,
                    decoration: InputDecoration(
                        hintText: "Digite uma tarefa"
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      child: Text("Adicionar"),
                      onPressed: () async {
                        await repository.insert(TodoModel(title: repository.title.text, done: false));

                        setState(() {
                          repository.title.clear();
                        });
                      },
                    ),
                  )
              )
            ],
          ),
          StreamBuilder<Object>(
              stream: repository.readyStream.stream,
              initialData: false,
              builder: (context, snapshot) {
                if(snapshot.data){
                  return Expanded(
                    child: ListView.builder(
                        itemCount: repository.todoList.length,
                        itemBuilder: (_, index){
                          return Dismissible(
                            key: UniqueKey(),
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(repository.todoList[index].title),
                                  Checkbox(value: repository.todoList[index].done, onChanged: (v) async {
                                    await repository.update(repository.todoList[index]..done = v);

                                    setState(() {

                                    });
                                  })
                                ],
                              ),
                            ),
                            onDismissed: (_) async {
                              await repository.remove(repository.todoList[index]);
                              setState(() {

                              });
                            },
                          );
                        }
                    ),
                  );
                }
                else{
                  return Center(child: CircularProgressIndicator(),);
                }
              }
          )
        ],
      ),
    );
  }
}