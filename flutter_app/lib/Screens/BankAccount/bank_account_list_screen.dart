import 'package:app/Models/bank_account_model.dart';
import 'package:flutter/material.dart';
import 'package:app/BLoC/BankAccount/bank_account_list_bloc.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/paginate_model.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';
import 'package:app/Screens/BankAccount/bank_account_detail_screen.dart';

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
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Text('Bank Accounts',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: Color(0xFF222222),
      ),
      backgroundColor: Color(0xFF333333),
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

  void createBankAccount() {}
}

class BankAccountList extends StatelessWidget {
  final PaginateModel<BankAccountModel> bankAccountList;

  const BankAccountList({Key key, this.bankAccountList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: <Widget>[
          Expanded(child: Text("Account Number")),
          Expanded(child: Text("Type")),
          Expanded(child: Text("Ammount")),
        ]),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            child: new ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 0.0,
                        vertical: 1.0,
                      ),
                      child: InkWell(
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BankAccountDetailScreen(
                                    this.bankAccountList.data[index].id)),
                          )
                        },
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 65,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                      child: Text(
                                        bankAccountList
                                            .data[index].accountNumber,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Roboto',
                                            color: Colors.white70),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 65,
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                      child: Text(
                                        bankAccountList.data[index].amount
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Roboto',
                                            color: Colors.white70),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 65,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                      child: Text(
                                        bankAccountList.data[index].type,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Roboto',
                                            color: Colors.white70),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    color: Colors.black54);
              },
              itemCount: bankAccountList.data.length,
            ),
          ),
        ),
      ],
    );
  }
}
