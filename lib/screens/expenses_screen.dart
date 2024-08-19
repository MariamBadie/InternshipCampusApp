import 'package:campus_app/backend/Controller/expenseController.dart';
import 'package:campus_app/backend/Model/Expense.dart';
import 'package:campus_app/screens/add_new_expense_screen.dart';
import 'package:campus_app/widgets/chart/chart.dart';
import 'package:campus_app/widgets/expenses/expense_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [];
  final String userID = 'yq2Z9NaQdPz0djpnLynN'; // Hardcoded userID

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  Future<void> _fetchExpenses() async {
    try {
      List<Expense> expenses = await getAllExpenses(userID);
      setState(() {
        _registeredExpenses.addAll(expenses);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load expenses: $e')),
      );
    }
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });

    // Add the expense to Firestore
    addExpense(expense, userID);
  }

  void _removeExpense(Expense expense) async {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });

    // Try deleting the expense from Firestore
    try {
      await deleteExpense(expense.id!);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: const Text('Expense deleted.'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              _undoDeleteExpense(expense, expenseIndex);
            },
          ),
        ),
      );
    } catch (e) {
      _undoDeleteExpense(expense, expenseIndex);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete expense: $e')),
      );
    }
  }

  void _undoDeleteExpense(Expense expense, int expenseIndex) async {
    setState(() {
      _registeredExpenses.insert(expenseIndex, expense);
    });

    // Re-add the expense to Firestore with the authorID as a reference
    try {
      await addExpense(expense, userID);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to restore expense: $e')),
      );
    }
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Expense Tracker",
            style: GoogleFonts.poppins(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 237, 229, 250),
          actions: [
            IconButton(
              onPressed: _openAddExpenseOverlay,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: Column(
          children: [
            Chart(expenses: _registeredExpenses),
            Expanded(
              child: mainContent,
            ),
          ],
        ),
      ),
    );
  }
}
