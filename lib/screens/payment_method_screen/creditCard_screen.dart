import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/payment_repository.dart';
import 'package:active_ecommerce_flutter/screens/order_list.dart';
import 'package:active_ecommerce_flutter/screens/package/packages.dart';
import 'package:active_ecommerce_flutter/screens/wallet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:toast/toast.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CreditCard extends StatefulWidget {
  String title;
  // String payment_type;
  // String? payment_method_key;
  var package_id;
  double? amount;
  CreditCard({
    Key? key,
    this.amount = 0.00,
    this.title = "",
    // this.payment_type = "",
    this.package_id,
    // this.payment_method_key = ""
  }) : super(key: key);

  @override
  _CreditCardState createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  int? _combined_order_id = 0;
  bool _initial_url_fetched = false;
  bool _isLoading = true;

  WebViewController _webViewController = WebViewController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("pak  ${widget.package_id}");
    createOrder();
    // if (widget.payment_type == "cart_payment") {
    // }
  }

  createOrder() async {
    // var orderCreateResponse = await PaymentRepository()
    //     .getOrderCreateResponse(widget.payment_method_key);

    // if (orderCreateResponse.result == false) {
    //   ToastComponent.showDialog(orderCreateResponse.message,
    //       gravity: Toast.center, duration: Toast.lengthLong);
    //   Navigator.of(context).pop();
    //   return;
    // }
    // _combined_order_id = orderCreateResponse.combined_order_id;

    if (widget.package_id != null) {
      pay(Uri.parse(
          "${AppConfig.BASE_URL}/afs?amount=${widget.amount}&package_id=${widget.package_id}"));
    } else {
      pay(Uri.parse("${AppConfig.BASE_URL}/afs?amount=${widget.amount}"));
    }
  }

  pay(url) {
    _webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          // onPageStarted: (controller) {
          //   _webViewController.loadRequest(Uri.parse(_initial_url));
          // },
          onWebResourceError: (error) {},
          onPageStarted: (page) {
            print(page);
          },
          onPageFinished: (page) {
            print(page);
            if (page.contains("afs/success")) {
              print("payment Done");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OrderList(
                            from_checkout: true,
                          )));
              //   if (widget.payment_type == "cart_payment") {
              //   } else if (widget.payment_type == "wallet_payment") {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => Wallet(
              //                   from_recharge: true,
              //                 )));
              //   } else if (widget.payment_type == "customer_package_payment") {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => UpdatePackage(
              //                   go_back: false,
              //                 )));
              //   }
            } else if (page.contains("/afs/cancel")) {
              ToastComponent.showDialog("Payment is not complete",
                  gravity: Toast.center, duration: Toast.lengthLong);
              Navigator.of(context).pop();
            }
            setState(() {
              _isLoading =
                  false; // Set isLoading to false when the page is finished loading
            });
          },
        ),
      )
      ..loadRequest(url,
          headers: {"Authorization": "Bearer ${access_token.$}"});
    _initial_url_fetched = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: buildBody(),
      ),
    );
  }

/*
  void getData() {
    print('called.........');
    String? payment_details = '';

    _webViewController
        .runJavaScriptReturningResult("document.body.innerText")
        .then((data) {
      // var decodedJSON = jsonDecode(data);
      var responseJSON = jsonDecode(data as String);
      if (responseJSON.runtimeType == String) {
        responseJSON = jsonDecode(responseJSON);
      }
      //print(responseJSON.toString());
      if (responseJSON["result"] == false) {
        Toast.show(responseJSON["message"],
            duration: Toast.lengthLong, gravity: Toast.center);

        Navigator.pop(context);
      } else if (responseJSON["result"] == true) {
        print("a");
        payment_details = responseJSON['payment_details'];
        onPaymentSuccess(payment_details);
      }
    });
  }*/
/*
  onPaymentSuccess(payment_details) async {
    print("b");

    var razorpayPaymentSuccessResponse = await PaymentRepository()
        .getRazorpayPaymentSuccessResponse(widget.payment_type, widget.amount,
        _combined_order_id, payment_details);

    if (razorpayPaymentSuccessResponse.result == false) {
      print("c");
      Toast.show(razorpayPaymentSuccessResponse.message!,
          duration: Toast.lengthLong, gravity: Toast.center);
      Navigator.pop(context);
      return;
    }

    Toast.show(razorpayPaymentSuccessResponse.message!,
        duration: Toast.lengthLong, gravity: Toast.center);
    if (widget.payment_type == "cart_payment") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return OrderList(from_checkout: true);
      }));

      /*OneContext().push(MaterialPageRoute(builder: (_) {
        return OrderList(from_checkout: true);
      }));*/
    } else if (widget.payment_type == "wallet_payment") {
      print("d");
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Wallet(from_recharge: true);
      }));
    }
  }
*/
  buildBody() {
    if (_isLoading) {
      // Show a loading indicator while the page is loading
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      // Show the WebView when the page has finished loading
      return WillPopScope(
        onWillPop: () async {
          ToastComponent.showDialog("Payment is not complete",
              gravity: Toast.center, duration: Toast.lengthLong);
          Navigator.of(context).pop();
          // Return true to allow the back button press to continue
          return true;
        },
        child: SizedBox.expand(
          child: Container(
            child: WebViewWidget(
              controller: _webViewController,
            ),
          ),
        ),
      );
    }
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(CupertinoIcons.arrow_left, color: MyTheme.dark_grey),
          onPressed: () {
            ToastComponent.showDialog("Payment is not complete",
                gravity: Toast.center, duration: Toast.lengthLong);
            Navigator.of(context).pop();
          },
        ),
      ),
      title: Text(
        widget.title,
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}
