import 'package:flutter/material.dart';
import 'package:app/BLoC/wallet_list_bloc.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/wallet_list_model.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';
import 'package:app/Screens/GenerateQR/scan_qr_screen.dart';
import 'package:flutter/services.dart';

class WalletListScreen extends StatefulWidget {
  @override
  _WalletListScreenState createState() => _WalletListScreenState();
}

class _WalletListScreenState extends State<WalletListScreen> {
  WalletListBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = WalletListBloc();
    _bloc.fetchWalletLists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Text('Danh sách ví',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: Color(0xFF222222),
      ),
      backgroundColor: Color(0xFF333333),
      body: RefreshIndicator(
        onRefresh: () => _bloc.fetchWalletLists(),
        child: StreamBuilder<ApiResponse<WalletListModel>>(
          stream: _bloc.walletListStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return LoadingWidget(loadingMessage: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  return WalletList(walletList: snapshot.data.data);
                  break;
                case Status.ERROR:
                  return ErrWidget(
                    errorMessage: snapshot.data.message,
                    onRetryPressed: () => _bloc.fetchWalletLists(),
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
          _bloc.addWallet();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }

  void createWallet() {}
}

class WalletList extends StatelessWidget {
  final WalletListModel walletList;

  const WalletList({Key key, this.walletList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final key = new GlobalKey<ScaffoldState>();
    return new ListView.builder(
      itemBuilder: (context, index) {
        return Card(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 0.0,
                vertical: 1.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => null));
                        // ShowChuckyJoke(categoryList.categories[index])));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 65,
                          child: Container(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                              child: Text(
                                walletList.walletList[index].address,
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
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                        child: Icon(
                          Icons.content_copy,
                          color: Colors.white70,
                        ),
                        onTap: () {
                          Clipboard.setData(new ClipboardData(
                              text: walletList.walletList[index].address));
                          key.currentState.showSnackBar(new SnackBar(
                            content: new Text("Đã copy"),
                          ));
                        }),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                        child: Icon(
                          Icons.center_focus_weak,
                          color: Colors.white70,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GenerateQRScreen(
                                address: walletList.walletList[index].address,
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
            color: Colors.black54);
      },
      itemCount: walletList.walletList.length,
    );
  }
}
