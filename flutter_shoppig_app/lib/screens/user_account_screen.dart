//package
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//providers
import '../providers/auth.dart';
import '../widgets/app_drawer.dart';

class UserAccountScreen extends StatelessWidget {
  static const routeName = '/UserAccount';

  const UserAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);
    final userName = authProvider.userName ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Account'),
      ),
      body: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, //Center Row contents horizontally,
        crossAxisAlignment: CrossAxisAlignment.center,
        //Center Row contents vertically,
        children: <Widget>[
          Center(
            child: Icon(
              Icons.person_pin_circle_outlined,
              size: 100,
            ),
          ),
          Text(
            userName,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: authProvider.isAuth
                  ? () {
                      Navigator.of(context).pushReplacementNamed('/');
                      authProvider.logout();
                    }
                  : null,
              child: const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 35),
                maximumSize: const Size(150, 35),
              ),
            ),
          )
        ],
      ),
    );
  }
}
