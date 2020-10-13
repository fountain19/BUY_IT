import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;


class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({this.message, this.success});
}


class StripeServices {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeServices.apiBase}/payment_intents';
  static String secret =
      'sk_test_51HD34yA44Hfayk6RYI6yq9qOvKJeEyK4akDjDf8xBUn66ZToPyX14VWdrovCcUafGcj5wPvMk43lAXQFdElH4hVq00NFEXXGns';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeServices.secret}',
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  static init() {
    StripePayment.setOptions(StripeOptions(
        publishableKey:
        'pk_test_51HD34yA44Hfayk6R1KBKUKI4J4jjGGY1Rt42Ge5dgSZkxaXKVEuvVyr69XFvp7oD9yxylQpFIqtXcEHZGFzgdoqC00GgmFtdBd',
        merchantId: "Test",
        androidPayMode: 'test'));
  }


  static Future <StripeTransactionResponse> payViaExistingCard(
      {String amount, String currency, CreditCard card}) async{
    try {
      var paymentMethod = await StripePayment.createPaymentMethod(
          PaymentMethodRequest(card: card));
      var paymentIntent =
      await StripeServices.createPaymentIntent(amount, currency);
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id));
      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
          message: 'Transaction successfully',
          success: true,
        );
      } else {
        return new StripeTransactionResponse(
          message: 'Transaction failed',
          success: false,
        );
      }
    } on PlatformException catch (err) {
      return StripeServices.getPlatformExceptionResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
        message: 'Transaction failed:${err.toString()}',
        success: false,
      );
    }
  }


  static Future<StripeTransactionResponse> payWithNewCard(
      {String amount, String currency}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      var paymentIntent =
      await StripeServices.createPaymentIntent(amount, currency);
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id));
      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
          message: 'Transaction successfully',
          success: true,
        );
      } else {
        return new StripeTransactionResponse(
          message: 'Transaction failed',
          success: false,
        );
      }
    } on PlatformException catch (err) {
      return StripeServices.getPlatformExceptionResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
        message: 'Transaction failed:${err.toString()}',
        success: false,
      );
    }
  }


  static getPlatformExceptionResult(err) {
    String message = 'Some thing went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled ';
    }
    return new StripeTransactionResponse(
      message: message,
      success: false,
    );
  }


  static Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String,dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(StripeServices.paymentApiUrl,
          body: body, headers: StripeServices.headers);
      return jsonDecode(response.body);
    } catch (err) {
      print(err.toString());
    }
    return null;
  }
}
