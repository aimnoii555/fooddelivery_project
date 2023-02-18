class Order {
  String? id;
  String? dateTime;
  String? idCus;
  String? customerName;
  String? idRes;
  String? restaurantName;
  String? distance;
  String? transport;
  String? idFood;
  String? foodName;
  String? foodPrice;
  String? amount;
  String? sum;
  String? sumTotal;
  String? idRider;
  String? payment;
  String? message;
  String? status;

  Order(
      {this.id,
      this.dateTime,
      this.idCus,
      this.customerName,
      this.idRes,
      this.restaurantName,
      this.distance,
      this.transport,
      this.idFood,
      this.foodName,
      this.foodPrice,
      this.amount,
      this.sum,
      this.sumTotal,
      this.idRider,
      this.payment,
      this.message,
      this.status});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateTime = json['DateTime'];
    idCus = json['idCus'];
    customerName = json['Customer_Name'];
    idRes = json['idRes'];
    restaurantName = json['Restaurant_Name'];
    distance = json['Distance'];
    transport = json['Transport'];
    idFood = json['idFood'];
    foodName = json['FoodName'];
    foodPrice = json['FoodPrice'];
    amount = json['Amount'];
    sum = json['Sum'];
    sumTotal = json['SumTotal'];
    idRider = json['idRider'];
    payment = json['Payment'];
    message = json['Message'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['DateTime'] = this.dateTime;
    data['idCus'] = this.idCus;
    data['Customer_Name'] = this.customerName;
    data['idRes'] = this.idRes;
    data['Restaurant_Name'] = this.restaurantName;
    data['Distance'] = this.distance;
    data['Transport'] = this.transport;
    data['idFood'] = this.idFood;
    data['FoodName'] = this.foodName;
    data['FoodPrice'] = this.foodPrice;
    data['Amount'] = this.amount;
    data['Sum'] = this.sum;
    data['SumTotal'] = this.sumTotal;
    data['idRider'] = this.idRider;
    data['Payment'] = this.payment;
    data['Message'] = this.message;
    data['Status'] = this.status;
    return data;
  }
}
