import 'package:app/Models/bank_account_model.dart';
import 'package:flutter/material.dart';
import 'package:app/BLoC/BankAccount/bank_account_list_bloc.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/paginate_model.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';
import 'package:app/Screens/BankAccount/bank_account_detail_screen.dart';

import './../Drawer/drawer.dart';

class BankAccountListScreen extends StatefulWidget {
  @override
  _BankAccountListScreenState createState() => _BankAccountListScreenState();
}

class _BankAccountListScreenState extends State<BankAccountListScreen> {
  BankAccountListBloc _bloc;
  int page;
  bool loadingNewPage;
  bool allPageLoaded;
  PaginateModel<BankAccountModel> bankAccountList;
  ScrollController controller = ScrollController();

  @override
  void initState() {
    loadingNewPage = false;
    allPageLoaded = false;
    page = 1;
    super.initState();
    _bloc = BankAccountListBloc();
    _bloc.fetchBankAccountLists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels ==
                  (scrollInfo.metrics.maxScrollExtent - 30) &&
              !loadingNewPage &&
              !allPageLoaded) {
            loadingNewPage = true;
            page++;
            print(page);
            _bloc.fetchMoreBankAccounts(page);
          }
          return null;
        },
        child: StreamBuilder<ApiResponse<PaginateModel>>(
          stream: _bloc.bankAccountListStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return LoadingWidget(loadingMessage: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  if (bankAccountList == null) {
                    bankAccountList = snapshot.data.data;
                  } else {
                    snapshot.data.data.data.forEach((element) {
                      bankAccountList.data.add(element);
                    });
                    allPageLoaded =
                        snapshot.data.data.to == snapshot.data.data.total;
                  }
                  return BankAccountList(bankAccountList: bankAccountList);
                  break;
                case Status.ERROR:
                  return ErrWidget(
                    errorMessage: snapshot.data.message,
                    onRetryPressed: () => _bloc.fetchBankAccountLists(),
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

class BankAccountList extends StatelessWidget {
  final PaginateModel<BankAccountModel> bankAccountList;
  const BankAccountList({Key key, this.bankAccountList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.30;
    bool closeTopContainer = false;
    double topContainer = 0;
    return Scaffold(
        appBar: AppBar(
          title: Text('Bank Accounts'),
        ),
        drawer: Container(width: 250, child: Drawer(child: DrawerNav())),
        body: Container(
            height: size.height,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    child: new ListView.builder(
                      itemBuilder: (context, index) {
                        double scale = 1.0;
                        if (topContainer > 0.5) {
                          scale = index + 0.5 - topContainer;
                          if (scale < 0) {
                            scale = 0;
                          } else if (scale > 1) {
                            scale = 1;
                          }
                        }
                        return Container(
                          height: 150,
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
                                      builder: (context) =>
                                          BankAccountDetailScreen(this
                                              .bankAccountList
                                              .data[index]
                                              .id)),
                                )
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                      padding:
                                          EdgeInsets.only(top: 20, left: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "A.No:",
                                            style: TextStyle(
                                              //fontStyle: FontStyle.italic,
                                              fontSize: 18,
                                              color: Colors.black,
                                              //fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            "Type:",
                                            style: TextStyle(
                                              //fontStyle: FontStyle.italic,
                                              fontSize: 12, color: Colors.black,
                                              //fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            "Amount:",
                                            style: TextStyle(
                                              //fontStyle: FontStyle.italic,
                                              fontSize: 12, color: Colors.black,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            bankAccountList
                                                .data[index].accountNumber,
                                            style: TextStyle(
                                              //fontStyle: FontStyle.italic,
                                              fontSize: 18,
                                              color: Colors.black,
                                              //fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          if (bankAccountList.data[index].type
                                                  .toString() ==
                                              '1')
                                            Text(
                                              'Thụ hưởng',
                                              style: TextStyle(
                                                //fontStyle: FontStyle.italic,
                                                fontSize: 12,
                                                color: Colors.black,
                                                //fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          if (bankAccountList.data[index].type
                                                  .toString() !=
                                              '0')
                                            Text(
                                              'Tiết kiệm',
                                              style: TextStyle(
                                                //fontStyle: FontStyle.italic,
                                                fontSize: 12,
                                                color: Colors.black,
                                                //fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            bankAccountList.data[index].amount
                                                    .toString() +
                                                'VND',
                                            style: TextStyle(
                                              //fontStyle: FontStyle.italic,
                                              fontSize: 12, color: Colors.black,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundColor:
                                              Color.fromRGBO(50, 172, 121, 1),
                                          child: Icon(
                                            Icons.chevron_right,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          color: Colors.white,
                        );
                      },
                      itemCount: bankAccountList.data.length,
                    ),
                  ),
                ),
              ],
            )));
  }
}
