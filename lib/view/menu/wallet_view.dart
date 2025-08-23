import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taxi_driver/common/appContants.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common_widget/wallet_row.dart';
import 'package:taxi_driver/view/menu/add_momey_view.dart';

import '../../controller/authController.dart';

class WalletView extends StatefulWidget {
  const WalletView({super.key});

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  List walletArr = [
    {
      "icon": "assets/img/wallet_add.png",
      "name": "Added to Wallet",
      "time": "1 Feb'19 • #123467",
      "price": "\$40"
    },
    {
      "icon": "assets/img/trips_cut.png",
      "name": "Trip Deducted",
      "time": "1 Feb'19 • #123467",
      "price": "\$40"
    },
    {
      "icon": "assets/img/withdraw.png",
      "name": "Withdraw to Wallet",
      "time": "1 Feb'19 • #123467",
      "price": "\$40"
    },
        {
      "icon": "assets/img/wallet_add.png",
      "name": "Added to Wallet",
      "time": "1 Feb'19 • #123467",
      "price": "\$40"
    },
    {
      "icon": "assets/img/trips_cut.png",
      "name": "Trip Deducted",
      "time": "1 Feb'19 • #123467",
      "price": "\$40"
    },
    {
      "icon": "assets/img/withdraw.png",
      "name": "Withdraw to Wallet",
      "time": "1 Feb'19 • #123467",
      "price": "\$40"
    },
        {
      "icon": "assets/img/wallet_add.png",
      "name": "Added to Wallet",
      "time": "1 Feb'19 • #123467",
      "price": "\$40"
    },
    {
      "icon": "assets/img/trips_cut.png",
      "name": "Trip Deducted",
      "time": "1 Feb'19 • #123467",
      "price": "\$40"
    },
    {
      "icon": "assets/img/withdraw.png",
      "name": "Withdraw to Wallet",
      "time": "1 Feb'19 • #123467",
      "price": "\$40"
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {



      Get.find<AuthController>().getWalletHistory();



      setState(() {

      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {

        double totalAmount = 0;
        if (authController.walletResponseList.isNotEmpty) {
          totalAmount = authController.walletResponseList
              .map((e) {
            double amount = double.tryParse(e.walletAmount ?? "0") ?? 0;
            return (e.trnType?.toLowerCase() == "debit") ? -amount : amount;
          })
              .reduce((a, b) => a + b);
        }
       return Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Image.asset(
              "assets/img/back.png",
              width: 25,
              height: 25,
            ),
          ),
          centerTitle: true,
          title: Text(
            "Wallet",
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 12,
                color: TColor.lightWhite,
                width: double.maxFinite,
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Total balance",
                style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 16,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${AppContants.rupessSystem}",
                    style: TextStyle(
                      color: TColor.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "$totalAmount",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 0.5,
                color: TColor.lightGray,
                width: double.maxFinite,
              ),
              /*Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "WITHDRAW",
                        style: TextStyle(
                          color: TColor.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 0.5,
                    color: TColor.lightGray,
                    height: 55,
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        context.push(const AddMoneyView());
                      },
                      child: Text(
                        "ADD MONEY",
                        style: TextStyle(
                          color: TColor.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),*/
              Container(
                height: 12,
                color: TColor.lightWhite,
                width: double.maxFinite,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                color: TColor.lightWhite,
                width: double.maxFinite,
                child: Text(
                  "History",
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                itemBuilder:(context, index) {
                  var wObj = authController.walletResponseList[index];
                return WalletRow(wObj: wObj);
              } , separatorBuilder: (context, index) => const Divider(indent: 50,) , itemCount: authController.walletResponseList.length)
            ],
          ),
        ),
      );}
    );
  }
}
