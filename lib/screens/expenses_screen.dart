import 'package:campus_app/models/expense.dart';
import 'package:campus_app/screens/add_new_expense_screen.dart';
import 'package:campus_app/widgets/chart/chart.dart';
import 'package:campus_app/widgets/expense_list.dart';
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
  final List<Expense> _registeredExpenses = [
  Expense(
    title: 'Dorm Rent',
    amount: 200.00,
    date: DateTime(DateTime.now().year, DateTime.now().month - 1, 5), // Previous month, 5th day
    category: Category.housing,
  ),
  Expense(
    title: 'Machine Learning Textbook',
    amount: 50.00,
    date: DateTime(DateTime.now().year, DateTime.now().month, 14), // Current month, 14th day
    category: Category.supplies,
  ),
  Expense(
    title: 'Bus Ticket to Campus',
    amount: 2.50,
    date: DateTime(DateTime.now().year, DateTime.now().month - 2, 21), // Two months ago, 21st day
    category: Category.transportation,
  ),
  Expense(
    title: 'Lunch at the Cafeteria',
    amount: 7.00,
    date: DateTime(DateTime.now().year, DateTime.now().month, 3), // Current month, 3rd day
    category: Category.food,
  ),
  Expense(
    title: 'Club Outing',
    amount: 15.00,
    date: DateTime(DateTime.now().year, DateTime.now().month - 1, 28), // Previous month, 28th day
    category: Category.activities,
  ),
  Expense(
    title: 'Laptop Repair',
    amount: 120.00,
    date: DateTime(DateTime.now().year, DateTime.now().month - 3, 15), // Three months ago, 15th day
    category: Category.technology,
  ),
  Expense(
    title: 'Basketball Event',
    amount: 15.00,
    date: DateTime(DateTime.now().year, DateTime.now().month, 10), // Current month, 10th day
    category: Category.activities,
  ),
];


  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
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
            fontSize: 22, // Adjusted font size
            fontWeight: FontWeight.w600,
          ),
        ),
          backgroundColor: Color.fromARGB(255, 237, 229, 250), // Background color
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


// Suggested Categories:
// Books & Supplies:
// For tracking expenses on textbooks, stationery, and other academic materials.
// Transportation:
// For tracking costs related to commuting, carpooling, public transport, or bike rentals.
// Food & Dining:
// For tracking spending on meals, snacks, and coffee runs on campus.
// Social Activities:
// For expenses related to student events, parties, club fees, or social gatherings.
// Housing & Utilities:
// For students living off-campus who want to track rent, utilities, or dorm-related expenses.
// Technology:
// For tracking expenses on gadgets, software, or any tech-related purchases necessary for studies.
// Miscellaneous:
// For other expenses that don't fit into the main categories, such as clothing or personal care.
// Potential Uses:
// Budgeting: Students can use this feature to manage their monthly budget by tracking where their money goes.
// Saving Goals: They could set saving goals for specific categories, like saving for a new laptop or a trip.
// Financial Planning: Helps in understanding spending patterns, making it easier to plan finances for the semester.
// Expense Sharing: Could be useful for sharing expenses in group projects or shared accommodations.
// Tracking Reimbursements: For students who need to get reimbursed for club expenses or other activities, they can track these within the app.
// These adjustments make the Expense Tracker a more integral part of a student’s life, helping them manage their finances in a campus-specific context.
