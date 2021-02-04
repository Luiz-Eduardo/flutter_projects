import 'package:flutter/material.dart';
import 'package:f_imc_2_ext/views/result.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double _currentSliderValue = 150;
  TextEditingController pesoController = TextEditingController();

  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  void _resetCampos() {
    pesoController.clear();
    _currentSliderValue = 150;
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora de IMC"),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(Icons.person, size: 120, color: Colors.greenAccent),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Peso (kg)",
                    labelStyle: TextStyle(color: Colors.greenAccent)),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.greenAccent, fontSize: 25.0),
                controller: pesoController,
                validator: (value) {
                  debugPrint(value);
                  if (value.isEmpty) return "Insira seu peso!";
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0)
              ),
              Text(
                "Altura (cm)",
                style: TextStyle(color: Colors.greenAccent, fontSize: 25.0),
              ),
              Center(
                child: Text(
                  _currentSliderValue.toInt().toString(),
                  style: TextStyle(color: Colors.greenAccent, fontSize: 25.0),
                )
              ),
              Slider(
                value: _currentSliderValue,
                min: 0,
                max: 250,
                divisions: 250,
                activeColor: Colors.greenAccent,
                label: _currentSliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue = value;
                  });
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                    height: 50.0,
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _calcular();
                        }
                      },
                      child: Text(
                        "Calcular",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                      color: Colors.greenAccent,
                    )),
              ),
            ], //<widget>[]
          ),
        ),
      ),
    );
  }

  void _calcular() {
    String _texto = "";
    MaterialColor _color = Colors.green;
    bool _bold = false;

    double peso = double.parse(pesoController.text);
    double altura = _currentSliderValue/100;

    double imc = peso / (altura * altura);

    if (imc < 18.6) {
      _texto = "Abaixo do peso (${imc.toStringAsPrecision(4)})";
      _color = Colors.yellow;
    } else if (imc >= 18.6 && imc < 24.9) {
      _texto = "Peso ideal (${imc.toStringAsPrecision(4)})";
      _color = Colors.green;
    } else if (imc >= 24.9 && imc < 29.9) {
      _texto = "Levemente acima do peso (${imc.toStringAsPrecision(4)})";
      _color = Colors.red;
    } else if (imc >= 29.9 && imc < 34.9) {
      _texto = "Obesidade Grau I (${imc.toStringAsPrecision(4)})";
      _color = Colors.red;
    } else if (imc >= 34.9 && imc < 39.9) {
      _texto = "Obesidade Grau II (${imc.toStringAsPrecision(4)})";
      _color = Colors.red;
      _bold = true;
    } else if (imc >= 40) {
      _texto = "Obesidade Grau III (${imc.toStringAsPrecision(4)})";
      _color = Colors.red;
      _bold = true;
    }

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Result(_color, _texto, _bold)));
  }
}