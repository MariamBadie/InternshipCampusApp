import 'package:campus_app/backend/Controller/reminderController.dart';
import 'package:campus_app/backend/Model/Reminder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

String userID = 'upeubEqcmzSU9aThExaO';

class _RemindersPageState extends State<RemindersPage> {
  late Future<List<Reminder>> reminders;

  @override
  void initState() {
    super.initState();
    loadReminders();
  }

  void loadReminders() {
    setState(() {
      reminders = viewRemindersByUser(userID);
    });
  }

  // Add new reminder to Firestore
  Future<void> addReminder(DateTime dateTime, String description) async {
    Reminder reminder = Reminder(
      timestamp: Timestamp.fromDate(dateTime),
      onOff: true,
      content: description,
      userID: userID,
    );

    await createReminder(reminder);
    loadReminders(); // Reload reminders after adding a new one
  }

  // Edit existing reminder's content and timestamp
  Future<void> editReminder(Reminder reminder) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: reminder.timestamp!.toDate(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(reminder.timestamp!.toDate()),
      );

      if (selectedTime != null) {
        DateTime selectedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        String description = reminder.content ?? '';

        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Edit Reminder'),
              content: TextField(
                decoration: const InputDecoration(hintText: 'Reminder description'),
                controller: TextEditingController(text: description),
                onChanged: (value) {
                  description = value;
                },
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    if (description.isNotEmpty) {
                      await changeReminderContent(reminder.id!, description);
                      await changeReminderTime(reminder.id!, Timestamp.fromDate(selectedDateTime));
                      loadReminders(); // Reload after editing
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  // Toggle reminder on/off status
  Future<void> changestatus(Reminder reminder, bool value) async {
    await toggleReminder(reminder.id!, value); // Toggle on/off in Firestore
    loadReminders(); // Refresh the reminders after toggle
  }

  // Delete a reminder
  Future<void> delete(String reminderId) async {
    await deleteReminder(reminderId); // Delete from Firestore
    loadReminders(); // Refresh after deleting
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reminders"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              loadReminders(); // Refresh the page
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Reminder>>(
        future: reminders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading reminders'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('No reminders found'));
          }

          var reminderList = snapshot.data!;

          return ListView.builder(
            itemCount: reminderList.length,
            itemBuilder: (context, index) {
              var reminder = reminderList[index];
              var dateTime = reminder.timestamp?.toDate();
              return ListTile(
                title: Text(reminder.content ?? 'No Content'),
                subtitle: Text(
                  dateTime != null
                      ? '${dateTime.toLocal().toString().split(' ')[0]} ${dateTime.toLocal().toString().split(' ')[1].substring(0, 5)}'
                      : 'No DateTime',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        editReminder(reminder); // Edit the reminder
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        delete(reminder.id!); // Delete the reminder
                      },
                    ),
                    Switch(
                      value: reminder.onOff ?? false,
                      onChanged: (value) {
                        changestatus(reminder, value); // Toggle on/off status
                      },
                      activeColor: Colors.white,
                      inactiveThumbColor: Colors.grey,
                      activeTrackColor: Colors.green,
                      inactiveTrackColor: Colors.grey[300],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddReminderDialog,
        backgroundColor: Colors.white24,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Open dialog for adding reminder
  Future<void> _showAddReminderDialog() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
}
