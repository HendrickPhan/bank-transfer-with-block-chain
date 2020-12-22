import 'package:app/Models/bank_account_model.dart';
import 'package:flutter/material.dart';
import 'package:app/BLoC/BankAccount/bank_account_list_bloc.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/paginate_model.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';
import 'package:app/Screens/BankAccount/bank_account_detail_screen.dart';
import './../Drawer/drawer.dart';

class HistoryListScreen extends StatefulWidget {
  @override
  _HistoryListScreenState createState() => _HistoryListScreenState();
}

class _HistoryListScreenState extends State<HistoryListScreen> {
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
                  return HistoryList(bankAccountList: bankAccountList);
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
    );
  }

  void createBankAccount() {}
}

class HistoryList extends StatelessWidget {
  final PaginateModel<BankAccountModel> bankAccountList;
  const HistoryList({Key key, this.bankAccountList}) : super(key: key);

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
                                side:
                                    BorderSide(color: Colors.white70, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 5,
                              child: Padding(
                                padding: EdgeInsets.only(top: 40, left: 30),
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
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            bankAccountList
                                                .data[index].accountNumber,
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 28,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            bankAccountList.data[index].amount
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 2.0),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 40),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            CircleAvatar(
                                              radius: 16,
                                              backgroundColor: Color.fromRGBO(
                                                  50, 172, 121, 1),
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
                              color: Color.fromRGBO(35, 60, 103, 1),
                            ));
                      },
                      itemCount: bankAccountList.data.length,
                    ),
                  ),
                ),
              ],
            )));
  }
}
