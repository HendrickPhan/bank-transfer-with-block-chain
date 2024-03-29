import 'package:app/Models/bank_account_model.dart';
import 'package:flutter/material.dart';
import 'package:app/BLoC/BankAccount/bank_account_list_bloc.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/paginate_model.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';
import 'package:app/Screens/BankAccount/bank_account_detail_screen.dart';
import 'package:app/Screens/GenerateQR/generate_qr_screen.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

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

  void _scrollListener() {
    if (controller.position.extentAfter < 500 &&
        !allPageLoaded &&
        !loadingNewPage) {
      page++;
      _bloc.fetchMoreBankAccounts(page);
      loadingNewPage = true;
    }
  }

  @override
  void initState() {
    loadingNewPage = false;
    allPageLoaded = false;
    page = 1;
    super.initState();
    _bloc = BankAccountListBloc();
    _bloc.fetchBankAccountLists();
    controller.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<ApiResponse<PaginateModel>>(
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
                  allPageLoaded = snapshot.data.data.currentPage >=
                      snapshot.data.data.lastPage;
                  loadingNewPage = false;
                }
                return BankAccountList(
                  bankAccountList: bankAccountList,
                  controller: controller,
                );
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
    );
  }
}

class BankAccountList extends StatelessWidget {
  final PaginateModel<BankAccountModel> bankAccountList;
  final ScrollController controller;
  const BankAccountList({Key key, this.bankAccountList, this.controller})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: 12345678.9012345);
    MoneyFormatterOutput fo = fmf.output;
    return Container(
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
      child: new ListView.builder(
        controller: controller,
        itemBuilder: (context, index) {
          return Container(
            padding: new EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
            height: 110,
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
                        builder: (context) => BankAccountDetailScreen(
                            this.bankAccountList.data[index].id)),
                  )
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: IconButton(
                        icon: Icon(Icons.account_balance),
                        color: Colors.blueAccent,
                        onPressed: () {
                          // Navigator.pushNamed(
                          //   context,
                          //   GenerateQRScreen.route,
                          //   arguments:
                          //       bankAccountList.data[index].accountNumber,
                          // );
                        },
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "A.No:",
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
                              "Amount:",
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
                              "Type:",
                              style: TextStyle(
                                //fontStyle: FontStyle.italic,
                                fontSize: 12, color: Colors.grey,
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
                              bankAccountList.data[index].accountNumber,
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
                            if (bankAccountList.data[index].type.toString() ==
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
                              fmf
                                  .copyWith(
                                      amount: bankAccountList.data[index].amount
                                          .toDouble(),
                                      fractionDigits: 0)
                                  .output
                                  .nonSymbol,
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
                              bankAccountList.data[index].type,
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
                        child: IconButton(
                          icon: Icon(Icons.qr_code),
                          color: Colors.blueAccent,
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              GenerateQRScreen.route,
                              arguments:
                                  bankAccountList.data[index].accountNumber,
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            //color: Colors.white,
          );
        },
        itemCount: bankAccountList.data.length,
      ),
    );
  }
}
