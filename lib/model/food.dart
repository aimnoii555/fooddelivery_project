class Food {
  String? id;
  String? idCategory;
  String? idRes;
  String? foodName;
  String? foodPrice;
  String? menuFood;
  String? detail;
  String? image;
  String? depleted;

  Food({
    this.id,
    this.idCategory,
    this.idRes,
    this.foodName,
    this.foodPrice,
    this.menuFood,
    this.detail,
    this.image,
    this.depleted,
  });

  Food.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idCategory = json['idCategory'];
    idRes = json['idRes'];
    foodName = json['FoodName'];
    foodPrice = json['FoodPrice'];
    menuFood = json['MenuFood'];
    detail = json['Detail'];
    image = json['Image'];
    depleted = json['Depleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idCategory'] = this.idCategory;
    data['idRes'] = this.idRes;
    data['FoodName'] = this.foodName;
    data['FoodPrice'] = this.foodPrice;
    data['MenuFood'] = this.menuFood;
    data['Detail'] = this.detail;
    data['Image'] = this.image;
    data['Depleted'] = this.depleted;
    return data;
  }
}
