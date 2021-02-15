import 'package:flutter/material.dart';
import 'package:app/Widget/BankAccountSelect/bank_account_select_widget.dart';
import 'package:app/Ultilities/custom_text_input_formatter.dart';

class CreateCashOutScreen extends StatefulWidget {
  static const String route = "cash-out";
  final String fromAccount;
  final int amount;
  const CreateCashOutScreen({
    Key key,
    this.fromAccount = '',
    this.amount = 0,
  }) : super(key: key);
  @override
  _CreateCashOutScreenState createState() => _CreateCashOutScreenState();
}

class _CreateCashOutScreenState extends State<CreateCashOutScreen> {
  final _formKey = GlobalKey<FormState>();
  String _from_account;
  int _amount;
  @override
  void initState() {
    super.initState();
    setState(() {
      _from_account = widget.fromAccount;
      _amount = widget.amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Builder(builder: (BuildContext context) {
            return ListView(
              children: getFormWidget(context),
            );
          }),
        ),
      ),
    );
  }

  List<Widget> getFormWidget(BuildContext context) {
    List<Widget> formWidget = new List();
    // from account
    formWidget.add(BankAccountSelectWidget(
      onChanged: (value) {
        setState(() {
          _from_account = value;
        });
      },
    ));
    // amount
    formWidget.add(new TextFormField(
      decoration:
          InputDecoration(labelText: 'Enter Amount', hintText: 'Amount'),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter amount';
        }
        return null;
      },
      inputFormatters: [CustomTextInputFormatter()],
      initialValue: _amount.toString(),
      onSaved: (value) {
        setState(() {
          _amount = int.parse(value.replaceAll(',', ''));
        });
      },
    ));

    void onPressedSubmit() {
      _formKey.currentState.save();
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Form Submitted')));
    }

    formWidget.add(
      new RaisedButton(
        color: Colors.blue,
        textColor: Colors.white,
        child: new Text('Continue'),
        onPressed: onPressedSubmit,
      ),
    );

    return formWidget;
  }
}
