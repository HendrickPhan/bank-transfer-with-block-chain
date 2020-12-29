import 'package:flutter/material.dart';
import 'package:app/Widget/Transaction/transaction_list_widget.dart';

class TransactionListScreen extends StatefulWidget {
  static const String route = "transaction-list";
  @override
  _TransactionListScreenState createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: TransactionWidget());
  }
}
