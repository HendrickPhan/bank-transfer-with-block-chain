import 'package:flutter/material.dart';
import '../Home/home_screen.dart';

class RegisterCompleteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Complete Screen'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    image: AssetImage('assets/images/champion_cup.png'),
                  ),
                ),
              ),
              flex: 2,
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Chúc mừng',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'Bạn đã đăng ký thành công.',
                    ),
                    Text('Hãy tiến hành cập nhập thông tin của mình ngay'),
                    Text('để có thể nộp đơn ứng tuyển ngay nhé.'),
                  ]),
                ),
              ),
              flex: 1,
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 150,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      textColor: Colors.white,
                      color: Colors.green,
                      child: Text(
                        'Cập nhập',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      textColor: Colors.white,
                      color: Colors.green,
                      child: Text(
                        'Bỏ qua',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              ),
              flex: 1,
            )
          ],
        ),
      ),
    );
  }
}
