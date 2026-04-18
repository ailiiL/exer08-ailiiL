import 'dart:convert';

class Expense {
  String? id;
  String name;
  String desc;
  String category;
  int amount;
  bool paid;

  Expense({this.id, required this.name, required this.desc, required this.category, required this.amount, required this.paid});

  // Factory constructor to instantiate object from json format
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      name: json['name'],
      desc: json['desc'],
      category: json['category'],
      amount: json['amount'],
      paid: json['paid']
    );
  }

  static List<Expense> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Expense>((dynamic d) => Expense.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'desc': desc, 'category': category, 'amount': amount, 'paid': paid};
  }
}
