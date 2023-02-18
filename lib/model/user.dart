class User {
  String? id;
  String? type;
  String? username;
  String? password;

  User({this.id, this.type, this.username, this.password});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['Type'];
    username = json['Username'];
    password = json['Password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Type'] = this.type;
    data['Username'] = this.username;
    data['Password'] = this.password;
    return data;
  }
}

class Customer extends User {
  String? id;
  String? username;
  String? password;
  String? firstName;
  String? lastName;
  String? address;
  String? phone;
  String? lat;
  String? lng;
  String? token;

  Customer(
      {this.id,
      this.username,
      this.password,
      this.firstName,
      this.lastName,
      this.address,
      this.phone,
      this.lat,
      this.lng,
      this.token});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['Username'];
    password = json['Password'];
    firstName = json['First_Name'];
    lastName = json['Last_Name'];
    address = json['Address'];
    phone = json['Phone'];
    lat = json['Lat'];
    lng = json['Lng'];
    token = json['Token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Username'] = this.username;
    data['Password'] = this.password;
    data['First_Name'] = this.firstName;
    data['Last_Name'] = this.lastName;
    data['Address'] = this.address;
    data['Phone'] = this.phone;
    data['Lat'] = this.lat;
    data['Lng'] = this.lng;
    data['Token'] = this.token;
    return data;
  }
}

class Restaurant extends User {
  String? id;
  String? restaurantName;
  String? username;
  String? password;
  String? firstName;
  String? lastName;
  String? address;
  String? phone;
  String? image;
  String? lat;
  String? lng;
  String? status;
  String? token;
  String? statusOff;
  String? orderAmountRes;
  String? dateTime;

  Restaurant({
    this.id,
    this.restaurantName,
    this.username,
    this.password,
    this.firstName,
    this.lastName,
    this.address,
    this.phone,
    this.image,
    this.lat,
    this.lng,
    this.status,
    this.token,
    this.statusOff,
    this.orderAmountRes,
    this.dateTime,
  });

  Restaurant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantName = json['Restaurant_Name'];
    username = json['Username'];
    password = json['Password'];
    firstName = json['First_Name'];
    lastName = json['Last_Name'];
    address = json['Address'];
    phone = json['Phone'];
    image = json['Image'];
    lat = json['Lat'];
    lng = json['Lng'];
    status = json['Status'];
    token = json['Token'];
    statusOff = json['StatusOff'];
    orderAmountRes = json['OrderAmountRes'];
    dateTime = json['DateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Restaurant_Name'] = this.restaurantName;
    data['Username'] = this.username;
    data['Password'] = this.password;
    data['First_Name'] = this.firstName;
    data['Last_Name'] = this.lastName;
    data['Address'] = this.address;
    data['Phone'] = this.phone;
    data['Image'] = this.image;
    data['Lat'] = this.lat;
    data['Lng'] = this.lng;
    data['status'] = this.status;
    data['Token'] = this.token;
    data['StatusOff'] = this.statusOff;
    data['OrderAmountRes'] = this.orderAmountRes;
    data['DateTime'] = this.dateTime;
    return data;
  }
}

class Rider extends User {
  String? id;
  String? username;
  String? password;
  String? firstName;
  String? lastName;
  String? address;
  String? phone;
  String? status;
  String? bankNumber;
  String? bankName;
  String? licensePlate;
  String? image;
  String? token;
  String? dateTime;

  Rider({
    this.id,
    this.username,
    this.password,
    this.firstName,
    this.lastName,
    this.address,
    this.phone,
    this.status,
    this.bankNumber,
    this.bankName,
    this.licensePlate,
    this.image,
    this.token,
    this.dateTime,
  });

  Rider.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['Username'];
    password = json['Password'];
    firstName = json['First_Name'];
    lastName = json['Last_Name'];
    address = json['Address'];
    phone = json['Phone'];
    status = json['Status'];
    bankNumber = json['Bank_Number'];
    bankName = json['Bank_Name'];
    licensePlate = json['LicensePlate'];
    image = json['Image'];
    token = json['Token'];
    dateTime = json['DateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Username'] = this.username;
    data["Password"] = this.password;
    data['First_Name'] = this.firstName;
    data['Last_Name'] = this.lastName;
    data['Address'] = this.address;
    data['Phone'] = this.phone;
    data['Status'] = this.status;
    data['Bank_Number'] = this.bankNumber;
    data['Bank_Name'] = this.bankName;
    data['LicensePlate'] = this.licensePlate;
    data['Image'] = this.image;
    data['Token'] = this.token;
    data['DateTime'] = this.dateTime;
    return data;
  }
}
