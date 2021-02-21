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
          ? RaisedButton(
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
            )
          : Container();
    }

    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: 12345678.9012345);
    MoneyFormatterOutput fo = fmf.output;
    return NotificationListener<ScrollNotification>(
      child: Scaffold(
        backgroundColor: Color(0xff4E295B),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Color(0xFFA5A5A5),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    tileMode: TileMode.clamp),
              ),
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 24,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Your Bills",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 24,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 32),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 32),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromRGBO(35, 60, 103, 1),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              CircleAvatar(
                                radius: 16,
                                backgroundColor:
                                    Color.fromRGBO(50, 172, 121, 1),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              Text(
                                "DETAIL",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 28,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          Text(
                            "Account Number",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2.0),
                          ),
                          Text(
                            widget.billsDetail.type_text.toString(),
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2.0),
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "AMOUNT",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue[100],
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 2.0),
                                  ),
                                  Text(
                                    fmf
                                        .copyWith(
                                            amount: widget.billsDetail.amount
                                                .toDouble(),
                                            fractionDigits: 0)
                                        .output
                                        .nonSymbol,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[100],
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 2.0),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "RATE",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue[100],
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 2.0),
                                  ),
                                  Text(
                                    widget.billsDetail.user_id.toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[100],
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 2.0),
                                  ),
                                ],
                              ),
                            ],
                          )
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
      ),
    );
  }
}
