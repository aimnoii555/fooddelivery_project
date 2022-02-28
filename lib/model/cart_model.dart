class CartModel {
  int? id;
  String? idChef;
  String? nameChef;
  String? idFood;
  String? nameFood;
  String? price;
  String? amount;
  String? sum;
  String? distance;
  String? transport;

  CartModel(
      {this.id,
      this.idChef,
      this.nameChef,
      this.idFood,
      this.nameFood,
      this.price,
      this.amount,
      this.sum,
      this.distance,
      this.transport});

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idChef = json['idChef'];
    nameChef = json['nameChef'];
    idFood = json['idFood'];
    nameFood = json['nameFood'];
    price = json['price'];
    amount = json['amount'];
    sum = json['sum'];
    distance = json['distance'];
    transport = json['transport'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idChef'] = this.idChef;
    data['nameChef'] = this.nameChef;
    data['idFood'] = this.idFood;
    data['nameFood'] = this.nameFood;
    data['price'] = this.price;
    data['amount'] = this.amount;
    data['sum'] = this.sum;
    data['distance'] = this.distance;
    data['transport'] = this.transport;
    return data;
  }
}
