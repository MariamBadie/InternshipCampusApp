import 'package:campus_app/models/BlockedAccount.dart';
import 'package:campus_app/widgets/blocked_accounts/blocked_account_item.dart';
import 'package:flutter/material.dart';


class BlockedAccountsList extends StatelessWidget {
  const BlockedAccountsList({super.key, required this.accounts, required this.onUnblock});

  final List<BlockedAccountObject> accounts;
  final void Function(int) onUnblock;

  @override
  Widget build(context) {
    return ListView.builder(
      itemCount: accounts.length,
      itemBuilder: (ctx, index) => BlockedAccountItem(
        accounts[index],
        () => onUnblock(index),
      ),
    );
  }
}
