import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sms_maintained/sms.dart';
import '../providers/auth.dart';
import '../providers/school.dart';
// import 'dart:async';

class BusinessOverViewScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _BusinessOverViewScreenState createState() => _BusinessOverViewScreenState();
}

class _BusinessOverViewScreenState extends State<BusinessOverViewScreen> {
  //   Timer timer;
//   int counter = 0;
  @override
  void initState() {
    super.initState();
  }

  sendMessage(int index, String address, String message, String id) {
    SmsSender sender = new SmsSender();
    if (index <= 10) {
      print('This is Running-- $index');
      sender.sendSms(
        SmsMessage(
          address,
          message,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('BuildContext Called');
    // new Timer.periodic(Duration(seconds: 60), (Timer t) => setState(() {}));
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text(
          Provider.of<EmailAuth>(context, listen: false).schoolName.toString(),
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          RaisedButton(
            onPressed: () {
              Provider.of<EmailAuth>(context, listen: false).logOut();
            },
            child: Text('Log Out'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
        child: FutureBuilder(
          future: Records().getMessages(
            Provider.of<EmailAuth>(context, listen: false).schoolId,
          ),
          builder: (context, snapshot) {
            // new Timer.periodic(
            //     Duration(seconds: 30), (Timer t) => setState(() {}));
            // print('Timer Working');
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  var dataOfApi = snapshot.data['records'][index];

                  String address = dataOfApi['Contact'];
                  // sendMessage(
                  //     index, address, dataOfApi['Message'], dataOfApi['id']);

                  return Container(
                    height: 100,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      child: Center(
                        child: ListTile(
                          title: Text(dataOfApi['Message']),
                          subtitle: Text(dataOfApi['Contact']),
                          trailing: Text('Sent'),
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xff7c94b6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(dataOfApi['id']),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data['records'].length,
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
