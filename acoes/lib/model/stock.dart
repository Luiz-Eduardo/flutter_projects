class Stock{
  final String name;
  final double price;

  Stock({this.name, this.price});

  factory Stock.fromJson(Map<String, dynamic> json){
    return Stock(
      name: json['results'][0]['name'],
      price: json['results'][0]['price'],
    );
  }

}