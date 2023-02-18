class Category {
  String? id;
  String? idRes;
  String? categoryName;

  Category({this.id, this.idRes, this.categoryName});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idRes = json['idRes'];
    categoryName = json['categoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idRes'] = this.idRes;
    data['categoryName'] = this.categoryName;
    return data;
  }
}
