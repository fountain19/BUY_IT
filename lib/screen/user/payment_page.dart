import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:store_app/constans.dart';


import 'package:store_app/screen/user/existing_card.dart';
import 'package:store_app/services/payment_service.dart';

class PaymentPage extends StatefulWidget {
  static String id='PaymentPage';
  @override
  _PaymentPageState createState() => _PaymentPageState();
}
class _PaymentPageState extends State<PaymentPage> {
  onItemPress(BuildContext context,int index)async{
   var price=ModalRoute.of(context).settings.arguments;
    switch(index)
    {
      case 0:
       payViaNewCard(context);
        break;
      case 1:
        Navigator.pushNamed(context, ExistingCard.id,arguments: price);
        break;
    }
  }
  @override
  void initState() {
    super.initState();
    StripeServices.init();
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: KmainColor,
        title: Text('Payment Page'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),

        child: ListView.separated(itemBuilder:(context,index){
          Icon icon;
          Text text;
          switch(index){
            case 0:
              icon=Icon(Icons.add_circle,color: KmainColor,);
        text= Text('Pay With A New Card');
          break;
            case 1:
              icon=Icon(Icons.credit_card,color: KmainColor,);
              text= Text('Pay With An Existing Card');
              break;

             }
             return InkWell(
               onTap: (){
                 onItemPress(context,index);
               },
               child: ListTile(

                 title: text,
                 leading: icon,
               ),
             );
             }
        , separatorBuilder: (context,index)=>Divider(
          color: KmainColor,
        ), itemCount:2 ),
      ),
    );
  }

  void payViaNewCard(BuildContext context)async {
    int price=ModalRoute.of(context).settings.arguments;
    ProgressDialog dialog=ProgressDialog(context);
    dialog.style(message: 'Please wait....'
    );
    dialog.show();
    var response=await StripeServices.payWithNewCard(
        amount: '${price*100}'.toString(),
        currency: 'Usd'
    );
    await dialog.hide();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(response.message),
      duration: Duration(seconds:response.success?3:10),));
    }

}
