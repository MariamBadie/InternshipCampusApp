enum Category { supplies, transportation, food, activities, housing, technology }

class Expense {

  String id;
  String authorID;
  int amount;
  DateTime createdAt;
  Category category;

  Expense({required this.id, required this.authorID, required this.amount, required this.createdAt,
  required this.category});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'authorID': authorID,
      'amount': amount,
      'createdAt': createdAt,
      'category': category
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map){
    return Expense(
      id: map['id'],
      authorID: map['authorID'],
      amount: map['amount'],
      createdAt: map['createdAt'],
      category: map['category']
    );
  }

}