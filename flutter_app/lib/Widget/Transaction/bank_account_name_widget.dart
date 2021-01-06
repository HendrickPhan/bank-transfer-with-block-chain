import 'package:flutter/material.dart';
// ----- screens
import 'package:app/BLoC/Transaction/get_bank_account_name_bloc.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Widget/Loading/loading_widget.dart';

class BankAccountNameWidget extends StatefulWidget {
  final String accountNumber;
  const BankAccountNameWidget({Key key, this.accountNumber}) : super(key: key);
  @override
  _BankAccountNameWidgetState createState() => _BankAccountNameWidgetState();
}

class _BankAccountNameWidgetState extends State<BankAccountNameWidget> {
  GetBankAccountNameBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = GetBankAccountNameBloc();
    _bloc.getBankAccountName(accountNumber: widget.accountNumber);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<String>>(
      stream: _bloc.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return LoadingWidget(loadingMessage: snapshot.data.message);
              break;
            case Status.COMPLETED:
              return Row(
                children: [
                  Expanded(
                    child: Text("Name", textAlign: TextAlign.left),
                  ),
                  Expanded(
                    child: Text(snapshot.data.data, textAlign: TextAlign.left),
                  ),
                ],
              );
              break;
            case Status.ERROR:
              return Row(
                children: [
                  Expanded(
                    child: Text("Name", textAlign: TextAlign.left),
                  ),
                  Expanded(
                    child: Text("NaN", textAlign: TextAlign.left),
                  ),
                ],
              );
              break;
          }
        }
        return Container();
      },
    );
  }
}
