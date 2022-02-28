class FoodModel {
  String? id;
  String? idChef;
  String? nameFood;
  String? image;
  String? price;
  String? detail;

  FoodModel(
      {this.id,
      this.idChef,
      this.nameFood,
      this.image,
      this.price,
      this.detail});

  FoodModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idChef = json['IdChef'];
    nameFood = json['NameFood'];
    image = json['Image'];
    price = json['Price'];
    detail = json['Detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['IdChef'] = this.idChef;
    data['NameFood'] = this.nameFood;
    data['Image'] = this.image;
    data['Price'] = this.price;
    data['Detail'] = this.detail;
    return data;
  }
}
