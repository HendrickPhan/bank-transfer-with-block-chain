import 'package:app/Models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:app/BLoC/Transaction/transaction_detail_bloc.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/paginate_model.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';
import 'package:flutter/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class TransactionDetailScreen extends StatefulWidget {
  static const String route = "transaction_detail";
  final int id;
  const TransactionDetailScreen(this.id);
  @override
  //BankAccountDetailScreen({Key key, @required this.id}) : super(key: key);
  _TransactionDetailScreenState createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  TransactionDetailBloc _bloc;
  TransactionModel transactionDetail;

  @override
  void initState() {
    super.initState();
    _bloc = TransactionDetailBloc();
    _bloc.fetchTransactionData(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History Detail',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        elevation: 0.0,
        backgroundColor: Color(0xFF222222),
      ),
      body: NotificationListener<ScrollNotification>(
        child: StreamBuilder<ApiResponse>(
          stream: _bloc.transactionDetailStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return LoadingWidget(loadingMessage: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  transactionDetail = snapshot.data.data;
                  return TransactionDetail(
                      transactionDetail: transactionDetail);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // _bloc.addBankAccount();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}

class TransactionDetail extends StatelessWidget {
  final TransactionModel transactionDetail;

  const TransactionDetail({Key key, this.transactionDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: 12345678.9012345);
    MoneyFormatterOutput fo = fmf.output;
    var type = '';
    if (transactionDetail.type.toString() == '0') {
      type = "Transfer";
    }
    if (transactionDetail.type.toString() == '1') {
      type = "Cash In";
    }
    if (transactionDetail.type.toString() == '2') {
      type = "Cash Out";
    }
    if (transactionDetail.type.toString() == '3') {
      type = "Paid Bill";
    }
    return NotificationListener<ScrollNotification>(
      child: Scaffold(
        body: Container(
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
                            "From Account",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            transactionDetail.fromAccount,
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
                            "To Account",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            transactionDetail.toAccount,
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
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            type,
                            style: TextStyle(
                              fontSize: 12,
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
                            "Ammount",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            fmf
                                .copyWith(
                                    amount: transactionDetail.amount.toDouble(),
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
                            "Date",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            transactionDetail.createdAt
                                .substring(0, 10)
                                .toString(),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
