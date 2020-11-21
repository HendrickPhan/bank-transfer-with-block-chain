import 'package:app/Models/bank_account_model.dart';
import 'package:flutter/material.dart';
import 'package:app/BLoC/BankAccount/bank_account_detail_bloc.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/paginate_model.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';
import 'package:app/Screens/GenerateQR/generate_qr_screen.dart';
import 'package:flutter/services.dart';

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
        title: Text('Bank Accounts',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: Color(0xFF222222),
        elevation: 0.0,
      ),
      backgroundColor: Color(0xFF333333),
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

class BankAccountDetail extends StatelessWidget {
  final BankAccountModel bankAccountDetail;

  const BankAccountDetail({Key key, this.bankAccountDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return NotificationListener<ScrollNotification>(
      child: new PageView.builder(
        itemBuilder: (context, index) {
          return Card(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 0.0,
                  vertical: 1.0,
                ),
                child: InkWell(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: size.height,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: size.height * 0.1),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                    topRight: Radius.circular(24),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Text("Detail Accounts",
                                      style: TextStyle(color: Colors.white)),
                                  Text(bankAccountDetail.accountNumber,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                  Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 200.0,
                                        height: 300.0,
                                        child: const Card(
                                            child: Text('Hello World!')),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                      // Expanded(
                      //   flex: 2,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: SizedBox(
                      //       height: 65,
                      //       child: Container(
                      //         alignment: Alignment.center,
                      //         child: Padding(
                      //           padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                      //           child: Text(
                      //             bankAccountDetail.accountNumber,
                      //             style: TextStyle(
                      //                 fontSize: 16,
                      //                 fontFamily: 'Roboto',
                      //                 color: Colors.white70),
                      //             textAlign: TextAlign.left,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Expanded(
                      //   flex: 1,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: SizedBox(
                      //       height: 65,
                      //       child: Container(
                      //         alignment: Alignment.centerRight,
                      //         child: Padding(
                      //           padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                      //           child: Text(
                      //             bankAccountDetail.amount.toString(),
                      //             style: TextStyle(
                      //                 fontSize: 16,
                      //                 fontFamily: 'Roboto',
                      //                 color: Colors.white70),
                      //             textAlign: TextAlign.left,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Expanded(
                      //   flex: 1,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: SizedBox(
                      //       height: 65,
                      //       child: Container(
                      //         alignment: Alignment.center,
                      //         child: Padding(
                      //           padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                      //           child: Text(
                      //             bankAccountDetail.type,
                      //             style: TextStyle(
                      //                 fontSize: 16,
                      //                 fontFamily: 'Roboto',
                      //                 color: Colors.white70),
                      //             textAlign: TextAlign.left,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
              color: Colors.black54);
        },
      ),
    );
  }
}
