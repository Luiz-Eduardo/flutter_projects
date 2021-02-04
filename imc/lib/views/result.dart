import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  MaterialColor _color;
  String _texto;
  bool _bold;

  Result(this._color, this._texto, this._bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("Resultado"), backgroundColor: Colors.blueAccent),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              _texto,
              style: TextStyle(color: _color, fontSize: 22.0, fontStyle: FontStyle.italic, fontWeight: _bold ? FontWeight.bold : FontWeight.normal),
            ),
          )
        ],
      ),
    );
  }
}
