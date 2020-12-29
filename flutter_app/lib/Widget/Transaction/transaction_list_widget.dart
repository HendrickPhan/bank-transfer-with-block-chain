import 'package:flutter/material.dart';
// ----- screens
import 'package:app/Screens/Transaction/transaction_detail_screen.dart';
import 'package:app/Screens/Transaction/transaction_list_screen.dart';
import 'package:app/Screens/Home/home_screen.dart';
import 'package:app/Screens/Profile/profile_screen.dart';
import 'package:app/BLoC/auth_bloc.dart';
import 'package:app/BLoC/Transaction/transaction_list_bloc.dart';
import 'package:app/Models/paginate_model.dart';
import 'package:app/Models/transaction_model.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';
import 'package:intl/intl.dart';

class TransactionWidget extends StatefulWidget {
  static const String route = "transaction-widget";
  final String bankAccount;
  const TransactionWidget({Key key, this.bankAccount}) : super(key: key);
  @override
  _TransactionWidgetState createState() => _TransactionWidgetState();
}

class _TransactionWidgetState extends State<TransactionWidget> {
  TransactionListBloc _bloc;
  int page;
  bool loadingNewPage;
  bool allPageLoaded;
  PaginateModel<TransactionModel> transactionList;
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    loadingNewPage = false;
    allPageLoaded = false;
    page = 1;
    super.initState();
    _bloc = TransactionListBloc();

    String bankAccount = widget.bankAccount.toString();
    //DebugPrint('xxxxxx' + bankAccount);
    if (bankAccount == 'null') {
      _bloc.fetchTransactionLists();
    } else {
      _bloc.fetchTransactionListsById(bankAccount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<PaginateModel>>(
      stream: _bloc.transactionListStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return LoadingWidget(loadingMessage: snapshot.data.message);
              break;
            case Status.COMPLETED:
              if (transactionList == null) {
                transactionList = snapshot.data.data;
              } else {
                snapshot.data.data.data.forEach((element) {
                  transactionList.data.add(element);
                });
                allPageLoaded =
                    snapshot.data.data.to == snapshot.data.data.total;
              }
              return TransactionList(transactionList: transactionList);
              break;
            case Status.ERROR:
              return ErrWidget(
                errorMessage: snapshot.data.message,
                onRetryPressed: () => _bloc.fetchTransactionLists(),
              );
              break;
          }
        }
        return Container();
      },
    );
  }
}

class TransactionList extends StatelessWidget {
  final PaginateModel<TransactionModel> transactionList;
  final ScrollController controller;
  const TransactionList({Key key, this.transactionList, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.30;
    bool closeTopContainer = false;
    double topContainer = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      //drawer: Container(width: 250, child: Drawer(child: DrawerNav())),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
              Colors.white,
              Color(0xFF4E54C8),
            ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                tileMode: TileMode.clamp)),
        height: size.height,
        child: new ListView.builder(
          controller: controller,
          itemBuilder: (context, index) {
            return Container(
              height: 100,
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                child: InkWell(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TransactionDetailScreen(
                              this.transactionList.data[index].id)),
                    )
                  },
                  child: Column(children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white70, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Center(
                              child: IconButton(
                                icon: Icon(Icons.account_balance),
                                color: Colors.blueAccent,
                                onPressed: () {},
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "From:",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      "To:",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        //fontWeight: FontWeight.w700,
                                        //letterSpacing: 2.0
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Amount:",
                                      style: TextStyle(
                                        //fontStyle: FontStyle.italic,
                                        fontSize: 12,
                                        color: Colors.grey,
                                        //fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Date:",
                                      style: TextStyle(
                                        //fontStyle: FontStyle.italic,
                                        fontSize: 12,
                                        color: Colors.grey,
                                        //fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      transactionList.data[index].fromAccount
                                          .toString(),
                                      style: TextStyle(
                                        //fontStyle: FontStyle.italic,
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    if (transactionList.data[index].toAccount
                                            .toString() ==
                                        '1')
                                      Text(
                                        'Thụ hưởng',
                                        style: TextStyle(
                                          //fontStyle: FontStyle.italic,
                                          fontSize: 12,
                                          color: Colors.grey,
                                          //fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    Text(
                                      transactionList.data[index].amount
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          //fontWeight: FontWeight.w700,
                                          letterSpacing: 2.0),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      transactionList.data[index].amount
                                          .toString(),
                                      style: TextStyle(
                                        //fontStyle: FontStyle.italic,
                                        fontSize: 12,
                                        color: Colors.grey,
                                        //fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      transactionList.data[index].createdAt
                                          .toString()
                                          .substring(0, 10),
                                      style: TextStyle(
                                        //fontStyle: FontStyle.italic,
                                        fontSize: 12,
                                        color: Colors.grey,
                                        //fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                )),
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Center(
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor:
                                      Color.fromRGBO(50, 172, 121, 1),
                                  child: Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            );
          },
          itemCount: transactionList.data.length,
        ),
      ),
    );
  }
}
