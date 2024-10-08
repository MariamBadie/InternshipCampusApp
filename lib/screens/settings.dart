import 'package:campus_app/backend/Controller/userController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:campus_app/screens/feedback_screen.dart';
import 'package:campus_app/screens/about_us_page.dart';
import '../models/ThemeNotifier.dart';
import 'package:campus_app/screens/blocked_accounts_page.dart';
import 'package:campus_app/screens/expenses_screen.dart';
import 'package:campus_app/screens/archive_page.dart';
import 'package:campus_app/screens/favorites_page.dart';
import 'package:campus_app/screens/my_activity_page.dart';
import 'package:campus_app/screens/signin.dart';
import '../screens/community_general_page.dart';

class SettingsPage2 extends StatefulWidget {
  const SettingsPage2({super.key});

  @override
  State<SettingsPage2> createState() => _SettingsPage2State();
}
  final AuthService _authService = AuthService();

class _SettingsPage2State extends State<SettingsPage2> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeNotifier>(context);
    bool isDark = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ListView(
            children: [
              _SingleSection(
                title: "General",
                children: [
                  _CustomListTile(
                    title: "Dark Mode",
                    icon: Icons.dark_mode_outlined,
                    trailing: Switch(
                      value: isDark,
                      onChanged: (value) {
                        themeProvider.toggleTheme(value);
                      },
                    ),
                  ),
                  const _CustomListTile(
                    title: "Notifications",
                    icon: Icons.notifications_none_rounded,
                  ),
                  const _CustomListTile(
                    title: "Security Status",
                    icon: CupertinoIcons.lock_shield,
                  ),
                ],
              ),
              const Divider(),
              _SingleSection(
                title: "Organization",
                children: [
                  const _CustomListTile(
                    title: "Profile",
                    icon: Icons.person_outline_rounded,
                  ),
                  _CustomListTile(
                    title: "Blocked Accounts",
                    icon: Icons.person_outline_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BlockedAccounts(),
                        ),
                      );
                    },
                  ),
                  const _CustomListTile(
                    title: "Messaging",
                    icon: Icons.message_outlined,
                  ),
                  const _CustomListTile(
                    title: "Calling",
                    icon: Icons.phone_outlined,
                  ),
                  const _CustomListTile(
                    title: "People",
                    icon: Icons.contacts_outlined,
                  ),
                  const _CustomListTile(
                    title: "Calendar",
                    icon: Icons.calendar_today_rounded,
                  ),
                  _CustomListTile(
                    title: "Communities",
                    icon: Icons.people,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>CommunityGeneralPage()
//     ); ,
                        ),
                      );
                    },
                  ),
                  _CustomListTile(
                    title: "Expense Tracker",
                    icon: Icons.add_chart_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Expenses(),
                        ),
                      );
                    },
                  ),
                  _CustomListTile(
                    title: "Favorites",
                    icon: Icons.favorite,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FavoritesPage(),
                        ),
                      );
                    },
                  ),
                  _CustomListTile(
                    title: "Your activity",
                    icon: Icons.timeline,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyActivityPage(),
                        ),
                      );
                    },
                  ),
                  _CustomListTile(
                    title: "Archives",
                    icon: Icons.archive,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ArchivePage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const Divider(),
              _SingleSection(
                title: "Help and Support",
                children: [
                  _CustomListTile(
                    title: "Feedback & suggestions",
                    icon: Icons.help_outline_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FeedbackScreen(),
                        ),
                      );
                    },
                  ),
                  _CustomListTile(
                    title: "About Us",
                    icon: Icons.info_outline_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutUsPage(),
                        ),
                      );
                    },
                  ),
                  _CustomListTile(
                    title: "Sign Out",
                    icon: Icons.exit_to_app_rounded,
                    onTap: () =>{ _logOut(context)},
                  ),
                  TextButton.icon(
                    onPressed: () => _deleteDialog,
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text(
                      'DELETE ACCOUNT',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _CustomListTile({
    required this.title,
    required this.icon,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const _SingleSection({
    this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ...children,
      ],
    );
  }
}

void _deleteDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String commentText = '';
      String reasonText = '';

      return AlertDialog(
        title: const Text('Sorry to see u go! 😢'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Type DELETE to confirm that you want to delete your account'),
            TextField(
              onChanged: (value) {
                commentText = value;
              },
              decoration: const InputDecoration(hintText: "Type DELETE to confirm"),
            ),
            TextField(
              onChanged: (value) {
                reasonText = value;
              },
              decoration: const InputDecoration(hintText: "Reason for deletion"),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('DELETE'),
            onPressed: () {
              if (commentText == "DELETE") {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const Signin()),
                );
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}

void _logOut(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Are You sure you want to Log Out?')
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () async{
              await _authService.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const Signin()),
              );
            },
          ),
        ],
      );
    },
  );
}
