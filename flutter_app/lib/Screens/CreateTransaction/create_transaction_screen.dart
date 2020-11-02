import 'dart:async';
import 'dart:typed_data';

import 'package:app/Models/wallet_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:app/Networking/api_responses.dart';
import 'package:app/BLoC/wallet_list_bloc.dart';
import 'package:app/Models/wallet_list_model.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CreateTransactionScreen extends StatefulWidget {
  @override
  _CreateTransactionScreenState createState() =>
      _CreateTransactionScreenState();
}

class _CreateTransactionScreenState extends State<CreateTransactionScreen> {
  WalletListBloc _bloc;
  @override
  initState() {
    super.initState();
    _bloc = WalletListBloc();
    _bloc.fetchWalletLists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chuyển tiền'),
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Color(0xFF222222),
      ),
      backgroundColor: Color(0xFF333333),
      body: StreamBuilder<ApiResponse<WalletListModel>>(
        stream: _bloc.walletListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return LoadingWidget(loadingMessage: snapshot.data.message);
                break;
              case Status.COMPLETED:
                return CreateTransactionForm(walletList: snapshot.data.data);
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
    );
  }
}

class CreateTransactionForm extends StatefulWidget {
  final WalletListModel walletList;
  CreateTransactionForm({this.walletList});

  @override
  _CreateTransactionFormState createState() =>
      _CreateTransactionFormState(walletList: this.walletList);
}

class _CreateTransactionFormState extends State<CreateTransactionForm> {
  Uint8List bytes = Uint8List(0);
  TextEditingController _toAddressController;
  TextEditingController _amountController;
  TextEditingController _privateKeyController;
  final _storage = FlutterSecureStorage();

  String _fromAddress;
  final WalletListModel walletList;
  _CreateTransactionFormState({this.walletList});
  List<DropdownMenuItem<String>> menuItems;

  @override
  initState() {
    super.initState();
    _toAddressController = TextEditingController();
    _privateKeyController = TextEditingController();

    menuItems = walletList.walletList.map((WalletModel wallet) {
      return new DropdownMenuItem<String>(
        value: wallet.address,
        child: new Text(wallet.address),
      );
    }).toList();
    menuItems.insert(
      0,
      new DropdownMenuItem<String>(
        value: null,
        child: new Text("Từ địa chỉ"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: 'Đến địa chỉ',
                        ),
                        controller: _toAddressController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: FloatingActionButton(
                        child: Icon(Icons.center_focus_strong),
                        backgroundColor: Colors.black38,
                        onPressed: _scan,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(3.0),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    border: new Border.all(color: Colors.black38),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      style: TextStyle(color: Colors.black54),
                      underline: null,
                      value: _fromAddress,
                      items: menuItems,
                      onChanged: (value) {
                        setState(() {
                          _fromAddress = value;
                          getPrivate(value);
                        });
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _privateKeyController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Private Key',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  readOnly: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Không hợp lệ';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Số tiền',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Không hợp lệ';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 150,
                  child: RaisedButton(
                    onPressed: () => {},
                    textColor: Colors.white,
                    color: Colors.blueGrey,
                    child: Text(
                      'Chuyển',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
    );
  }

  Future _scan() async {
    String barcode = await scanner.scan();
    _toAddressController.text = barcode;
  }

  Future<Null> getPrivate(public) async {
    String private = await _storage.read(key: public);
    _privateKeyController.text = private;
  }
}
