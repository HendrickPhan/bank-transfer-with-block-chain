import 'package:flutter/material.dart';
import 'package:app/Widget/BankAccountSelect/bank_account_select_widget.dart';
import 'package:app/Ultilities/custom_text_input_formatter.dart';

class ConfirmTransferScreen extends StatefulWidget {
  static const String route = "transfer";
  final String from_account;
  final String to_account;
  final int amount;
  final String description;

  const ConfirmTransferScreen({
    Key key,
    this.from_account,
    this.to_account,
    this.amount,
    this.description,
  }) : super(key: key);

  @override
  _ConfirmTransferScreenState createState() => _ConfirmTransferScreenState();
}

class _ConfirmTransferScreenState extends State<ConfirmTransferScreen> {
  final _formKey = GlobalKey<FormState>();
  var _passKey = GlobalKey<FormFieldState>();
  String to_account_name = '';
  @override
  void initState() {
    super.initState();
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
              children: [
                rowItem("From Account:", widget.from_account),
                rowItem("To Account:", widget.to_account),
                rowItem("To Account Name:", to_account_name),
                rowItem("Amount:", widget.amount),
                rowItem("From Account:", widget.from_account),
              ],
            );
          }),
        ),
      ),
    );
  }

  Row rowItem(String fieldName, var value) {
    return Row(
      children: [
        Expanded(
          child: Text(fieldName, textAlign: TextAlign.left),
        ),
        Expanded(
          child: Text(value, textAlign: TextAlign.left),
        ),
      ],
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
    // to account
    formWidget.add(new TextFormField(
      decoration: InputDecoration(
          labelText: 'Enter To Account', hintText: 'To Account'),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter to account';
        }
        return null;
      },
      onSaved: (value) {
        setState(() {
          _to_account = value;
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
      onSaved: (value) {
        setState(() {
          _amount = int.parse(value.replaceAll(',', ''));
        });
      },
    ));

    formWidget.add(new TextFormField(
      decoration: InputDecoration(
          labelText: 'Enter Descrition', hintText: 'Descrition'),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter description';
        }
        return null;
      },
      onSaved: (value) {
        setState(() {
          _description = value;
        });
      },
    ));

    void onPressedSubmit() {
      _formKey.currentState.save();
      print("_from_account " + _from_account);
      print("_to_account " + _to_account);
      print("_amount " + _amount.toString());
      print("_description " + _description);
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
