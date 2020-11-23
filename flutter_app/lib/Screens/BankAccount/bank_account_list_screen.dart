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
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF6267D7),
        leading: Icon(
          Icons.menu,
          color: Colors.black,
        ),
        title: Text('Bank Accounts',
            style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
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
    ));
  }

  void createBankAccount() {}
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
    return Container(
        height: size.height,
        child: Column(
          children: [
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
                    return Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
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
                                  children: <Widget>[
                                    Text(
                                      bankAccountList.data[index].accountNumber,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    Text(
                                      bankAccountList.data[index].amount
                                              .toString() +
                                          '1000000000VND',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        color: Colors.white);
                  },
                  itemCount: bankAccountList.data.length,
                ),
              ),
            ),
          ],
        ));
  }
}
