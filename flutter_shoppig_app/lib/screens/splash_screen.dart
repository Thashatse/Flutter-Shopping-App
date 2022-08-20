// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
//Models
import '../widgets/the_shop_logo.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          const TheShopLogoBackDropWidget(),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                        bottom: 25,
                      ),
                      child: const TheShopLogoWidget()),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: const CircularProgressIndicator(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
