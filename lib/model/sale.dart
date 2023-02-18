class Sale {
  String? id;
  String? idRes;
  String? dateTime;
  String? foodName;
  String? foodPrice;
  String? amount;
  String? totalNet;

  Sale(
      {this.id,
      this.idRes,
      this.dateTime,
      this.foodName,
      this.foodPrice,
      this.amount,
      this.totalNet});

  Sale.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idRes = json['idRes'];
    dateTime = json['DateTime'];
    foodName = json['FoodName'];
    foodPrice = json['FoodPrice'];
    amount = json['Amount'];
    totalNet = json['TotalNet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idRes'] = this.idRes;
    data['DateTime'] = this.dateTime;
    data['FoodName'] = this.foodName;
    data['FoodPrice'] = this.foodPrice;
    data['Amount'] = this.amount;
    data['TotalNet'] = this.totalNet;
    return data;
  }
}
