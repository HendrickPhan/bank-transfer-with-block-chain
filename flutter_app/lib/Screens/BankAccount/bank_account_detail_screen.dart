import 'package:app/Models/bank_account_model.dart';
import 'package:flutter/material.dart';
import 'package:app/BLoC/BankAccount/bank_account_detail_bloc.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/paginate_model.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';
import 'package:app/Widget/Transaction/transaction_list_widget.dart';
import 'package:app/Screens/Transaction/transaction_list_screen.dart';
import 'package:flutter/services.dart';
import 'package:app/Screens/GenerateQR/generate_qr_screen.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class BankAccountDetailScreen extends StatefulWidget {
  final int id;
  const BankAccountDetailScreen(this.id);
  @override
  //BankAccountDetailScreen({Key key, @required this.id}) : super(key: key);
  _BankAccountDetailScreenState createState() =>
      _BankAccountDetailScreenState();
}

class _BankAccountDetailScreenState extends State<BankAccountDetailScreen> {
  BankAccountDetailBloc _bloc;
  BankAccountModel bankAccountDetail;

  @override
  void initState() {
    super.initState();
    _bloc = BankAccountDetailBloc();
    _bloc.fetchBankAccountDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bank Accounts Detail',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        elevation: 0.0,
      ),
      body: NotificationListener<ScrollNotification>(
        child: StreamBuilder<ApiResponse>(
          stream: _bloc.bankAccountDetailStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return LoadingWidget(loadingMessage: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  bankAccountDetail = snapshot.data.data;
                  return BankAccountDetail(
                      bankAccountDetail: bankAccountDetail);
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

class BankAccountDetail extends StatelessWidget {
  final BankAccountModel bankAccountDetail;

  const BankAccountDetail({Key key, this.bankAccountDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      Color(0xFF4E54C8),
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
                                "Your Account",
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
                            bankAccountDetail.accountNumber,
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
                                            amount: bankAccountDetail.amount
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
                                    bankAccountDetail.interestRate.toString(),
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
                                    "TYPE",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue[100],
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 2.0),
                                  ),
                                  Text(
                                    bankAccountDetail.type,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[100],
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 2.0),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      child: Text(
                        "More Informations",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Colors.black),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 32),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 20.0,
                            )
                          ]),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      margin: EdgeInsets.symmetric(horizontal: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.wifi_tethering,
                                color: Colors.lightBlue[900],
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              InkWell(
                                child: Text("Transaction History"),
                                onTap: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TransactionWidget(
                                              bankAccount: this
                                                  .bankAccountDetail
                                                  .accountNumber
                                                  .toString(),
                                            )),
                                  )
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 20.0,
                            )
                          ]),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      margin: EdgeInsets.symmetric(horizontal: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.qr_code,
                                  color: Colors.lightBlue[900],
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Text("QR Code"),
                              ],
                            ),
                            onTap: () => {
                              Navigator.pushNamed(
                                context,
                                GenerateQRScreen.route,
                                arguments: bankAccountDetail.accountNumber,
                              )
                            },
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   height: 16,
                    // ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.all(Radius.circular(10)),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: Colors.black54,
                    //           blurRadius: 20.0,
                    //         )
                    //       ]),
                    //   padding:
                    //       EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    //   margin: EdgeInsets.symmetric(horizontal: 32),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: <Widget>[
                    //       Row(
                    //         children: <Widget>[
                    //           Icon(
                    //             Icons.mobile_screen_share,
                    //             color: Colors.lightBlue[900],
                    //           ),
                    //           SizedBox(
                    //             width: 16,
                    //           ),
                    //           Text(
                    //             "",
                    //             style: TextStyle(
                    //                 fontWeight: FontWeight.w500,
                    //                 fontSize: 18,
                    //                 color: Colors.grey[700]),
                    //           )
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
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
