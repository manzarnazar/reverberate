import 'package:active_ecommerce_flutter/custom/enum_classes.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:active_ecommerce_flutter/screens/subscription_checkout.dart';

class Subscription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SubscriptionScreen(),
    );
  }
}

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.white,
    centerTitle: false,
    leading: Builder(
      builder: (context) => IconButton(
        icon: UsefulElements.backButton(context),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ),
    title: Text(
      "Subscription",
      style: TextStyle(
          fontSize: 16,
          color: MyTheme.dark_font_grey,
          fontWeight: FontWeight.bold),
    ),
    elevation: 0.0,
    titleSpacing: 0,
  );
}

class SubscriptionScreen extends StatefulWidget {
  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int selectedPlanIndex = 0; // Initially, the first plan is selected

  void selectPlan(int index) {
    setState(() {
      selectedPlanIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> plansList = [
      {"packageId": 1, "title": "silver", "price": 24.00},
      {"packageId": 2, "title": "gold", "price": 33.00},
      {"packageId": 3, "title": "diamond", "price": 51.00},
    ];

    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/reverberate_logo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 32,
          ),
          Center(
            child: Text(
              "choose your plan".toUpperCase(),
              style: TextStyle(
                  color: Color.fromRGBO(0, 8, 42, 1.0),
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Row(
                children: List.generate(plansList.length, (index) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child: SubscriptionPlanBox(
                    title: plansList[index]["title"],
                    price: "${plansList[index]["price"]}",
                    isSelected: selectedPlanIndex == index,
                    onTap: () => selectPlan(index),
                  ),
                ),
              );
            })),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SubscriptionCheckout(
                        title: "Checkout",
                        packageId: plansList[selectedPlanIndex]["packageId"],
                        paymentFor: PaymentFor.Subscription,
                        rechargeAmount: plansList[selectedPlanIndex]["price"],
                      );
                    }));
                  },
                  child: Text("Sign Up"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(0, 8, 42, 1.0)),
                    minimumSize: MaterialStateProperty.all(Size(200, 50)),
                  ),
                )),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: selectedPlanDetails(selectedPlanIndex),
          ),
        ],
      ),
    );
  }

  Widget buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(
                  0, 8, 42, 1.0), // Customize the bullet point color
            ),
            margin: EdgeInsets.only(right: 8, top: 4),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget selectedPlanDetails(choice) {
    switch (choice) {
      case 0:
        return Column(
          children: [
            buildBulletPoint(
                "5% off after every 3rd purchase up-to \nto a maximum of 24 purchases (any brands within reverberate portfolio)"),
            SizedBox(
              height: 10,
            ),
            buildBulletPoint("Free delivery on all orders"),
          ],
        );
      case 1:
        return Column(
          children: [
            buildBulletPoint(
                "10% off after every 3rd purchase upto \nto a maximum of 33 purchases (any brands within reverberate portfolio)"),
            SizedBox(
              height: 10,
            ),
            buildBulletPoint("Free delivery on all orders"),
          ],
        );
      case 2:
        return Column(
          children: [
            buildBulletPoint(
                "15% off after every 3rd purchase upto \nto a maximum of 51 purchases (any brands within reverberate portfolio)"),
            SizedBox(
              height: 10,
            ),
            buildBulletPoint("Free delivery on all orders"),
          ],
        );

      default:
        return Container();
    }
  }
}

class SubscriptionPlanBox extends StatelessWidget {
  final String title;
  final String price;
  final bool isSelected;
  final VoidCallback onTap;

  SubscriptionPlanBox({
    required this.title,
    required this.price,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        isSelected ? Color.fromRGBO(0, 8, 42, 1.0) : MyTheme.grey_153;
    final textColor =
        isSelected ? Color.fromRGBO(0, 8, 42, 1.0) : MyTheme.grey_153;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          //cap over the box

          Row(
            children: [
              Expanded(
                child: Container(
                  height: 20.0,
                  decoration: BoxDecoration(
                      color: isSelected == true
                          ? Color.fromRGBO(0, 8, 42, 1.0)
                          : Colors.transparent,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                ),
              ),
            ],
          ),

          Row(
            children: [
              Expanded(
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: borderColor,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: title.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: textColor,
                              )),
                        ]),
                      ),
                      SizedBox(height: 5.0),
                      RichText(
                        text: TextSpan(children: [
                          WidgetSpan(
                            child: Transform.translate(
                              offset: const Offset(0, -10),
                              child: Text(
                                'BD',

                                //superscript is usually smaller in size
                                textScaleFactor: 0.7,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ),
                          WidgetSpan(
                            child: Text(price,
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                )),
                          ),
                        ]),
                      ),
                      SizedBox(height: 2.0),
                      Text("Annually",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
