class Cart {
  int? id;
  String? idRes;
  String? restaurantName;
  String? idFood;
  String? idCus;
  String? foodName;
  int? foodPrice;
  int? amount;
  int? sum;
  String? distance;
  String? menuFood;
  String? image;
  String? transport;

  Cart({
    this.id,
    this.idRes,
    this.restaurantName,
    this.idFood,
    this.idCus,
    this.foodName,
    this.foodPrice,
    this.amount,
    this.sum,
    this.distance,
    this.menuFood,
    this.image,
    this.transport,
  });

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idRes = json['idRes'];
    restaurantName = json['restaurantName'];
    idFood = json['idFood'];
    idCus = json['idCus'];
    foodName = json['foodName'];
    foodPrice = json['foodPrice'];
    amount = json['amount'];
    sum = json['sum'];
    distance = json['distance'];
    menuFood = json['menuFood'];
    image = json['image'];
    transport = json['transport'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idRes'] = this.idRes;
    data['restaurantName'] = this.restaurantName;
    data['idFood'] = this.idFood;
    data['idCus'] = this.idCus;
    data['foodName'] = this.foodName;
    data['foodPrice'] = this.foodPrice;
    data['amount'] = this.amount;
    data['sum'] = this.sum;
    data['distance'] = this.distance;
    data['menuFood'] = this.menuFood;
    data['image'] = this.image;
    data['transport'] = this.transport;
    return data;
  }
}
