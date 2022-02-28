class OrderModel {
  String? id;
  String? dateTime;
  String? idUser;
  String? nameUser;
  String? idChef;
  String? nameChef;
  String? distance;
  String? transport;
  String? idFood;
  String? nameFood;
  String? price;
  String? amount;
  String? sum;
  String? idRider;
  String? status;

  OrderModel(
      {this.id,
      this.dateTime,
      this.idUser,
      this.nameUser,
      this.idChef,
      this.nameChef,
      this.distance,
      this.transport,
      this.idFood,
      this.nameFood,
      this.price,
      this.amount,
      this.sum,
      this.idRider,
      this.status});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateTime = json['dateTime'];
    idUser = json['idUser'];
    nameUser = json['NameUser'];
    idChef = json['idChef'];
    nameChef = json['NameChef'];
    distance = json['Distance'];
    transport = json['Transport'];
    idFood = json['IdFood'];
    nameFood = json['NameFood'];
    price = json['Price'];
    amount = json['Amount'];
    sum = json['Sum'];
    idRider = json['idRider'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dateTime'] = this.dateTime;
    data['idUser'] = this.idUser;
    data['NameUser'] = this.nameUser;
    data['idChef'] = this.idChef;
    data['NameChef'] = this.nameChef;
    data['Distance'] = this.distance;
    data['Transport'] = this.transport;
    data['IdFood'] = this.idFood;
    data['NameFood'] = this.nameFood;
    data['Price'] = this.price;
    data['Amount'] = this.amount;
    data['Sum'] = this.sum;
    data['idRider'] = this.idRider;
    data['Status'] = this.status;
    return data;
  }
}
