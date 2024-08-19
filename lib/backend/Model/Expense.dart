import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum Category { supplies, transportation, food, activities, housing, technology }

const categoryIcons = {
  Category.supplies: Icons.book,
  Category.transportation: Icons.directions_bus,
  Category.food: Icons.restaurant,
  Category.activities: Icons.group,
  Category.housing: Icons.home,
  Category.technology: Icons.computer,
};

class Expense {
  final String? id;
  final String? authorID;
  final String title;
  final double amount;
  final DateTime createdAt;
  final Category category;

  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.createdAt,
    required this.category,
    this.authorID,
  });

  Map<String, dynamic> toMap() {
    return {
      'authorID': authorID,
      'title': title,
      'amount': amount,
      'createdAt': createdAt,
      'category': category.toString().split('.').last,
    };
  }

  factory Expense.fromMap(String id, Map<String, dynamic> data) {
    return Expense(
      id: id, // Use the document ID as the id
      title: data['title'],
      authorID: (data['authorID'] as DocumentReference).id, // Convert DocumentReference to ID
      amount: data['amount'].toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      category: Category.values.firstWhere(
        (e) => e.toString() == 'Category.${data['category']}',
      ),
    );
  }

  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? createdAt,
    Category? category,
    String? authorID,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      authorID: authorID ?? this.authorID,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
    );
  }
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount;
    }

    return sum;
  }
}
