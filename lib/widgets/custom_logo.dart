import 'package:flutter/material.dart';
class CustomLogo extends StatelessWidget {
  final String image;
  final String title;
  CustomLogo({@required this.image,@required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: MediaQuery.of(context).size.height*0.3,
        width: MediaQuery.of(context).size.width*0.3,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image(
              image: AssetImage(image),
            ),
            Positioned(
              bottom: 0,
              child: Text(title,style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 20,fontWeight: FontWeight.bold
              ),),
            ),
          ],
        ),
      ),
    );
  }
}