import 'package:campus_app/backend/Model/Expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy'); // Change to 'dd-MM-yyyy' for hyphen
    final formattedDate = dateFormat.format(expense.createdAt); // Directly format DateTime

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      color: Color.fromARGB(255, 210, 237, 231),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        child: Column(
          children: [
            Text(expense.title),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('\$${expense.amount.toStringAsFixed(2)}'),
                const Spacer(),
                Row(
                  children: [
                    Icon(categoryIcons[expense.category]),
                    const SizedBox(width: 8),
                    Text(formattedDate),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
