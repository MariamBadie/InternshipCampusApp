import 'package:flutter/material.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  // Sample list of reminders with their on/off status
  List<Map<String, dynamic>> reminders = [
    {'dateTime': DateTime.now(), 'description': 'Morning exercise', 'isActive': true},
    {'dateTime': DateTime.now().add(Duration(hours: 6)), 'description': 'Lunch break', 'isActive': false},
  ];

  // Add new reminder to the list
  void addReminder(DateTime dateTime, String description) {
    setState(() {
      reminders.add({'dateTime': dateTime, 'description': description, 'isActive': true});
    });
  }

  // Open date and time picker and dialog for entering reminder details
  Future<void> _showAddReminderDialog() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 30)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        DateTime selectedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        String description = '';

        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Add Reminder'),
              content: TextField(
                decoration: const InputDecoration(hintText: 'Reminder description'),
                onChanged: (value) {
                  description = value;
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (description.isNotEmpty) {
                      addReminder(selectedDateTime, description);
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  // Toggle the reminder's active status
  void toggleReminder(int index) {
    setState(() {
      reminders[index]['isActive'] = !reminders[index]['isActive'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
        backgroundColor: Colors.green[400],
      ),
      body: ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          var reminder = reminders[index];
          var dateTime = reminder['dateTime'] as DateTime?;
          return ListTile(
            title: Text(reminder['description']),
            subtitle: Text(
              dateTime != null
                  ? '${dateTime.toLocal().toString().split(' ')[0]} ${dateTime.toLocal().toString().split(' ')[1].substring(0, 5)}'
                  : 'No DateTime',
            ),
            trailing: Switch(
              value: reminder['isActive'],
              onChanged: (value) {
                toggleReminder(index);
              },
              activeColor: Colors.white,
              inactiveThumbColor: Colors.grey,
              activeTrackColor: Colors.green,
              inactiveTrackColor: Colors.grey[300],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddReminderDialog,backgroundColor: Colors.white24,
        child: const Icon(Icons.add),
      ),
    );
  }
}
