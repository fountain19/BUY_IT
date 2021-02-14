import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_app/constans.dart';

class AboutUs extends StatelessWidget {
  static String id = 'AboutUs';
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          backgroundColor: Color(0xFF2c425e),
          elevation: 0.0,
          title: Text('About Us'),
        ),
        body: Stack(

          children: <Widget>[
            Column(

               mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                 Padding(
                   padding: const EdgeInsets.only(right: 100),
                   child: Container(

                     child: Text(
                      'Deer customers: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.black
                      ),
                ),
                   ),
                 ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Text('in "BUY IT" we try to meet all your needs from the world of fashion and fashion in your hands. Your comfort is our goal and meet your needs in the fastest time. We thank you for your confidence and enjoy your time.',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.blueGrey[750]
                    ),),
                ),
              ],
            ),
            Material(
              color: Color(0xFF2c425e),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 100),
                child: Container(
                  height: MediaQuery.of(context).size.height * .1,
                ),
              ),
            ),
          ],
        ));
  }
}
