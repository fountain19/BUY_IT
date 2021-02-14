import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:store_app/constans.dart';

import 'package:store_app/services/payment_service.dart';
import 'package:stripe_payment/stripe_payment.dart';

class ExistingCard extends StatefulWidget {
  static String id = 'ExistingCard';
  @override
  _ExistingCardState createState() => _ExistingCardState();
}

class _ExistingCardState extends State<ExistingCard> {
  List cards = [
    {
      'cardNumber': '4242424242424242',
      'expiryDate': '04/24',
      'cardHolderName': 'Yaser Aslan',
      'cvvCode': '424',
      'showBackView': false,
    },
    {
      'cardNumber': '5555555555554444',
      'expiryDate': '04/23',
      'cardHolderName': 'Tracer',
      'cvvCode': '123',
      'showBackView': false,
    },
  ];
 void payViaExistingCard(BuildContext context, card)async {
  var price=ModalRoute.of(context).settings.arguments;
    ProgressDialog dialog=ProgressDialog(context);
    dialog.style(
      message: 'Please wait....'
    );
    await dialog.show();
    var expiryArr=card['expiryDate'].split('/');
    CreditCard stripeCard=CreditCard(
      number: card['cardNumber'],
      expMonth: int.parse(expiryArr[0]),
      expYear: int.parse(expiryArr[1]),
    );
    var response =await StripeServices.payViaExistingCard(
        amount:price.toString()*100 , currency: 'Usd', card: stripeCard);

     await dialog.hide();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(response.message),
        duration: Duration(seconds: 3),
      )).closed.then((_){Navigator.pop(context);
      }
      );
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2c425e),
        title: Text('Choose your card'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
            itemCount: cards.length,
            itemBuilder: (BuildContext context, int index) {
              var card = cards[index];
              return InkWell(
                onTap: () {
                  payViaExistingCard(context, card);
                },
                child: CreditCardWidget(
                  cardNumber: card['cardNumber'],
                  expiryDate: card['expiryDate'],
                  cardHolderName: card['cardHolderName'],
                  cvvCode: card['cvvCode'],
                  showBackView:
                      false, //true when you want to show cvv(back) view
                ),
              );
            }),
      ),
    );
  }

}
