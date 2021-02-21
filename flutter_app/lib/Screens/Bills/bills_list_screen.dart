import 'package:app/Models/bills_model.dart';
import 'package:flutter/material.dart';
import 'package:app/BLoC/Bills/bills_list_bloc.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/paginate_model.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';
import 'package:app/Screens/Bills/bills_detail_screen.dart';
import 'package:app/Screens/GenerateQR/generate_qr_screen.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class BillsListScreen extends StatefulWidget {
  static const String route = "bills-list";
  @override
  _BillsListScreenState createState() => _BillsListScreenState();
}

class _BillsListScreenState extends State<BillsListScreen> {
  BillsListBloc _bloc;
  int page;
  bool loadingNewPage;
  bool allPageLoaded;
  PaginateModel<BillsModel> billsList;
  ScrollController controller = ScrollController();

  void _scrollListener() {
    if (controller.position.extentAfter < 500 &&
        !allPageLoaded &&
        !loadingNewPage) {
      page++;
      _bloc.fetchMoreBills(page);
      loadingNewPage = true;
    }
  }

  @override
  void initState() {
    loadingNewPage = false;
    allPageLoaded = false;
    page = 1;
    super.initState();
    _bloc = BillsListBloc();
    _bloc.fetchBillsLists();
    controller.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Bills', style: TextStyle(color: Colors.white, fontSize: 20)),
        elevation: 0.0,
        backgroundColor: Color(0xFF333333),
      ),
      body: StreamBuilder<ApiResponse<PaginateModel>>(
        stream: _bloc.billsListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return LoadingWidget(loadingMessage: snapshot.data.message);
                break;
              case Status.COMPLETED:
                if (billsList == null) {
                  billsList = snapshot.data.data;
                } else {
                  snapshot.data.data.data.forEach((element) {
                    billsList.data.add(element);
                  });
                  allPageLoaded = snapshot.data.data.currentPage >=
                      snapshot.data.data.lastPage;
                  loadingNewPage = false;
                }
                return BillsList(
                  billsList: billsList,
                  controller: controller,
                );
                break;
              case Status.ERROR:
                return ErrWidget(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () => _bloc.fetchBillsLists(),
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

class BillsList extends StatelessWidget {
  final PaginateModel<BillsModel> billsList;
  final ScrollController controller;
  const BillsList({Key key, this.billsList, this.controller}) : super(key: key);
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
                        builder: (context) =>
                            BillsDetailScreen(this.billsList.data[index].id)),
                  )
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: IconButton(
                        icon: Icon(Icons.account_balance_wallet_rounded),
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
                              "User ID:",
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
                              "Type:",
                              style: TextStyle(
                                //fontStyle: FontStyle.italic,
                                fontSize: 12, color: Colors.grey,
                                //fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(
                              height: 5,
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
                            billsList.data[index].user_id.toString(),
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
                          Text(
                            billsList.data[index].type_text.toString(),
                            style: TextStyle(
                              //fontStyle: FontStyle.italic,
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            fmf
                                .copyWith(
                                    amount:
                                        billsList.data[index].amount.toDouble(),
                                    fractionDigits: 0)
                                .output
                                .nonSymbol,
                            style: TextStyle(
                              //fontStyle: FontStyle.italic,
                              fontSize: 12,
                              color: Colors.grey,
                              //fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Center(
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Color.fromRGBO(50, 172, 121, 1),
                          child: Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //color: Colors.white,
          );
        },
        itemCount: billsList.data.length,
      ),
    );
  }
}
