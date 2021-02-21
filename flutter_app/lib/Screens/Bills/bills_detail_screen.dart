import 'package:app/Models/bills_model.dart';
import 'package:app/Screens/Bills/pin_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/BLoC/Bills/bills_detail_bloc.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/paginate_model.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';
import 'package:app/Widget/Transaction/transaction_list_widget.dart';
import 'package:app/Screens/Transaction/transaction_list_screen.dart';
import 'package:flutter/services.dart';
import 'package:app/Screens/GenerateQR/generate_qr_screen.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:app/Widget/BankAccountSelect/bank_account_select_widget.dart';

class BillsDetailScreen extends StatefulWidget {
  static const String route = "bills-detail";
  final int id;
  const BillsDetailScreen(this.id);
  @override
  //BankAccountDetailScreen({Key key, @required this.id}) : super(key: key);
  _BillsDetailScreenState createState() => _BillsDetailScreenState();
}

class _BillsDetailScreenState extends State<BillsDetailScreen> {
  BillsDetailBloc _bloc;
  BillsModel billsDetail;

  @override
  void initState() {
    super.initState();
    _bloc = BillsDetailBloc();
    _bloc.fetchBillsDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bills Detail',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        elevation: 0.0,
        backgroundColor: Color(0xFF222222),
      ),
      body: NotificationListener<ScrollNotification>(
        child: StreamBuilder<ApiResponse>(
          stream: _bloc.billsDetailStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return LoadingWidget(loadingMessage: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  billsDetail = snapshot.data.data;
                  return BillsDetail(billsDetail: billsDetail);
                  break;
                case Status.ERROR:
                  return ErrWidget(
                    errorMessage: snapshot.data.message,
                  );
                  break;
              }
            }
            return Container();
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // _bloc.addBankAccount();
      //   },
      //   child: Icon(Icons.add),
      //   backgroundColor: Colors.lightBlue,
      // ),
    );
  }
}

class BillsDetail extends StatefulWidget {
  final BillsModel billsDetail;

  const BillsDetail({Key key, this.billsDetail}) : super(key: key);

  @override
  _BillsDetailState createState() => _BillsDetailState();
}

class _BillsDetailState extends State<BillsDetail> {
  String _from_account;

  void onPressedSubmit() {
    Map billInfo = {
      "accountNumber": _from_account,
      "billId": widget.billsDetail.id,
    };
    Navigator.pushNamed(
      context,
      BillPinCodeScreen.route,
      arguments: billInfo,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget paidButton() {
      return widget.billsDetail.status == 0
          ? Padding(
              padding: EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
              child: RaisedButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: new Text('Paid'),
                disabledColor: Colors.grey,
                onPressed: () => showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: new Text('Select Bank Account'),
                        content: Center(
                          child: Column(
                            children: [
                              BankAccountSelectWidget(
                                onChanged: (value) {
                                  setState(() {
                                    _from_account = value;
                                  });
                                },
                              ),
                              RaisedButton(
                                child: new Text('Paid'),
                                onPressed: onPressedSubmit,
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ))
          : Container();
    }

    final Size size = MediaQuery.of(context).size;
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: 12345678.9012345);
    MoneyFormatterOutput fo = fmf.output;
    var status = '';
    if (widget.billsDetail.status.toString() == '0') {
      status = "Unpaid";
    }
    if (widget.billsDetail.status.toString() == '1') {
      status = "Paid";
    }

    return NotificationListener<ScrollNotification>(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                  Colors.white,
                  Color(0xFFA5A5A5),
                ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    tileMode: TileMode.clamp)),
            height: size.height,
            width: size.width,
            child: Container(
              height: 250,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 32),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "User ID",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              widget.billsDetail.user_id.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Type",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              widget.billsDetail.type_text.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Ammount",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              fmf
                                  .copyWith(
                                      amount:
                                          widget.billsDetail.amount.toDouble(),
                                      fractionDigits: 0)
                                  .output
                                  .nonSymbol,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Status",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              status,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Date",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              widget.billsDetail.paid_at
                                  .substring(0, 10)
                                  .toString(),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  paidButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
