import 'package:flutter/material.dart';
import 'package:app/Models/bank_account_model.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/BLoC/BankAccount/bank_account_select_list_bloc.dart';

class BankAccountSelectWidget extends StatefulWidget {
  final Function onChanged;

  const BankAccountSelectWidget({Key key, this.onChanged}) : super(key: key);

  @override
  _BankAccountSelectWidgetState createState() =>
      _BankAccountSelectWidgetState();
}

class _BankAccountSelectWidgetState extends State<BankAccountSelectWidget> {
  List<BankAccountModel> bankAccounts;
  BankAccountSelectListBloc _bloc;

  String _value = null;
  List<DropdownMenuItem> _items;

  void initState() {
    super.initState();
    _bloc = BankAccountSelectListBloc();
    _bloc.fetchBankAccountSelectLists();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<ApiResponse<List<BankAccountModel>>>(
        stream: _bloc.bankAccountSelectListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                print("ok1");
                break;
              case Status.COMPLETED:
                bankAccounts = snapshot.data.data;
                _items = bankAccounts.map((BankAccountModel bankAccountModel) {
                  return new DropdownMenuItem<String>(
                    value: bankAccountModel.accountNumber,
                    child: new Text(bankAccountModel.accountNumber),
                  );
                }).toList();
                return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        hintText: 'From Account', labelText: 'From Account'),
                    value: _value,
                    items: _items,
                    onChanged: (value) {
                      setState(() {
                        _value = value;
                      });
                      widget.onChanged(value);
                    });
              case Status.ERROR:
                return Container();
            }
          }
          return Container();
        },
      ),
    );
  }
}
