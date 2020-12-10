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
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:app/BLoC/check_logged_in_bloc.dart';

class CreateTransactionScreen extends StatefulWidget {
  @override
  _CreateTransactionScreenState createState() =>
      _CreateTransactionScreenState();
}

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class _CreateTransactionScreenState extends State<CreateTransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        child: CreateTransaction(),
      ),
    );
  }
}

class CreateTransaction extends StatelessWidget {
  String _myActivity;
  String _myActivityResult;
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    _myActivity = '';
    _myActivityResult = '';
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/background.jpg'),
                    fit: BoxFit.cover),
                gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.white,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    tileMode: TileMode.clamp)),
            child:
                DraggableScrollableSheet(builder: (context, scrollController) {
              return Container(
                child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 24,
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(16),
                                      child: DropDownFormField(
                                        titleText: 'Account',
                                        hintText: 'Please choose Account',
                                        value: _myActivity,
                                        dataSource: [
                                          {
                                            "display": "Running",
                                            "value": "Running",
                                          },
                                          {
                                            "display": "Climbing",
                                            "value": "Climbing",
                                          },
                                          {
                                            "display": "Walking",
                                            "value": "Walking",
                                          },
                                          {
                                            "display": "Swimming",
                                            "value": "Swimming",
                                          },
                                          {
                                            "display": "Soccer Practice",
                                            "value": "Soccer Practice",
                                          },
                                          {
                                            "display": "Baseball Practice",
                                            "value": "Baseball Practice",
                                          },
                                          {
                                            "display": "Football Practice",
                                            "value": "Football Practice",
                                          },
                                        ],
                                        textField: 'display',
                                        valueField: 'value',
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, right: 15.0, top: 20.0),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            hintText: "Amount",
                                            fillColor: Colors.black,
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400])),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Invalid';
                                          }
                                          return null;
                                        },
                                        obscureText: true,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, right: 15.0, top: 50.0),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            hintText: "Receive Account",
                                            fillColor: Colors.black,
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400])),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Invalid';
                                          }
                                          return null;
                                        },
                                        obscureText: true,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 20.0),
                                      height: 50,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          gradient: LinearGradient(colors: [
                                            Color.fromRGBO(143, 148, 251, 1),
                                            Color.fromRGBO(143, 148, 251, .6),
                                          ])),
                                      child: Center(
                                        child: FlatButton(
                                            //onPressed: loginBtnClick,
                                            child: Text(
                                          "Send",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ])),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(243, 245, 248, 1),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40))),
              );
            })));
  }
}

// class _CreateTransactionScreenState extends State<CreateTransactionScreen> {
//   WalletListBloc _bloc;
//   @override
//   initState() {
//     super.initState();
//     _bloc = WalletListBloc();
//     _bloc.fetchWalletLists();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chuyển tiền'),
//         leading: BackButton(
//           color: Colors.white,
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         backgroundColor: Color(0xFF222222),
//       ),
//       backgroundColor: Color(0xFF333333),
//       body: StreamBuilder<ApiResponse<WalletListModel>>(
//         stream: _bloc.walletListStream,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             switch (snapshot.data.status) {
//               case Status.LOADING:
//                 return LoadingWidget(loadingMessage: snapshot.data.message);
//                 break;
//               case Status.COMPLETED:
//                 return CreateTransactionForm(walletList: snapshot.data.data);
//                 break;
//               case Status.ERROR:
//                 return ErrWidget(
//                   errorMessage: snapshot.data.message,
//                   onRetryPressed: () => _bloc.fetchWalletLists(),
//                 );
//                 break;
//             }
//           }
//           return Container();
//         },
//       ),
//     );
//   }
// }

// class CreateTransactionForm extends StatefulWidget {
//   final WalletListModel walletList;
//   CreateTransactionForm({this.walletList});

//   @override
//   _CreateTransactionFormState createState() =>
//       _CreateTransactionFormState(walletList: this.walletList);
// }

// class _CreateTransactionFormState extends State<CreateTransactionForm> {
//   Uint8List bytes = Uint8List(0);
//   TextEditingController _toAddressController;
//   TextEditingController _amountController;
//   TextEditingController _privateKeyController;
//   final _storage = FlutterSecureStorage();

//   String _fromAddress;
//   final WalletListModel walletList;
//   _CreateTransactionFormState({this.walletList});
//   List<DropdownMenuItem<String>> menuItems;

//   @override
//   initState() {
//     super.initState();
//     _toAddressController = TextEditingController();
//     _privateKeyController = TextEditingController();

//     menuItems = walletList.walletList.map((WalletModel wallet) {
//       return new DropdownMenuItem<String>(
//         value: wallet.address,
//         child: new Text(wallet.address),
//       );
//     }).toList();
//     menuItems.insert(
//       0,
//       new DropdownMenuItem<String>(
//         value: null,
//         child: new Text("Từ địa chỉ"),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: SingleChildScrollView(
//         child: Center(
//           child: Column(
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: Colors.white,
//                           border: OutlineInputBorder(),
//                           labelText: 'Đến địa chỉ',
//                         ),
//                         controller: _toAddressController,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 8.0),
//                       child: FloatingActionButton(
//                         child: Icon(Icons.center_focus_strong),
//                         backgroundColor: Colors.black38,
//                         onPressed: _scan,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   padding: const EdgeInsets.all(3.0),
//                   decoration: new BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                     border: new Border.all(color: Colors.black38),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: DropdownButton<String>(
//                       isExpanded: true,
//                       style: TextStyle(color: Colors.black54),
//                       underline: null,
//                       value: _fromAddress,
//                       items: menuItems,
//                       onChanged: (value) {
//                         setState(() {
//                           _fromAddress = value;
//                           getPrivate(value);
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   controller: _privateKeyController,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: 'Private Key',
//                     filled: true,
//                     fillColor: Colors.white,
//                   ),
//                   readOnly: true,
//                   validator: (value) {
//                     if (value.isEmpty) {
//                       return 'Không hợp lệ';
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   controller: _amountController,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: 'Số tiền',
//                     filled: true,
//                     fillColor: Colors.white,
//                   ),
//                   validator: (value) {
//                     if (value.isEmpty) {
//                       return 'Không hợp lệ';
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: SizedBox(
//                   width: 150,
//                   child: RaisedButton(
//                     onPressed: () => {},
//                     textColor: Colors.white,
//                     color: Colors.blueGrey,
//                     child: Text(
//                       'Chuyển',
//                       style: TextStyle(fontSize: 20),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//             mainAxisAlignment: MainAxisAlignment.center,
//           ),
//         ),
//       ),
//     );
//   }

//   Future _scan() async {
//     String barcode = await scanner.scan();
//     _toAddressController.text = barcode;
//   }

//   Future<Null> getPrivate(public) async {
//     String private = await _storage.read(key: public);
//     _privateKeyController.text = private;
//   }
// }
