import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const key = 'e44937de';
const url = 'https://api.hgbrasil.com';
const request = '${url}/finance/stock_price?key=${key}&symbol=';

void main() {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.blue, primaryColor: Colors.blue),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController stockController = TextEditingController();

  String _textInfo = "";

  Future <Map> getData(String stock) async {
    http.Response response = await http.get('${request}${stock}');

    Map<String, dynamic> data = json.decode(response.body);

    if(data["results"][stock.toUpperCase()].containsKey("error")){
      setState((){
        _textInfo = "O nome da ação digitada não está na base de dados ou não existe";
      });
    } else {
      String name;
      String price;

      setState(() {
        name = data["results"][stock.toUpperCase()]["name"].toString();
        price = double.parse(
            data["results"][stock.toUpperCase()]["price"].toString())
            .toStringAsFixed(2);

        _textInfo = "${name} - R\$ ${price}";
      });
    }
    return data;
  }

  void _resetCampos() {
    stockController.clear();

    setState(() {
      _textInfo = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ações BOVESPA"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetCampos,
          )
        ], //<Widget>[]
      ), // app bar
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Ação",
                    labelStyle: TextStyle(color: Colors.blue)),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blue, fontSize: 25.0),
                controller: stockController,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: ButtonTheme(
                    height: 50.0,
                    highlightColor: Colors.amber,
                    child: RaisedButton(
                      onPressed: () {
                        getData(stockController.text);
                      },
                      child: Text(
                        "Pesquisar",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                      color: Colors.blue,
                    )),
              ),
              Text(
                _textInfo,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blue, fontSize: 25.0),
              )
            ], //<widget>[]
          ),
        ),
    );
  }
}