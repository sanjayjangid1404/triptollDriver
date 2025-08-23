import 'package:flutter/material.dart';
import 'package:taxi_driver/common/appContants.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/model/wallet_response.dart';

class WalletRow extends StatelessWidget {
  final WalletResponse wObj;
  const WalletRow({super.key, required this.wObj});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Image.asset( "assets/img/wallet_add.png" , width: 35, height: 35, ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wObj.remark??"",
                  style: TextStyle(color: TColor.primaryText, fontSize: 12),
                ),
                Text(
                  wObj.addDate??"",
                  style: TextStyle(color: TColor.secondaryText, fontSize: 15),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            (wObj.trnType?.toLowerCase() == "debit" ?"-":"+") + AppContants.rupessSystem+( (wObj.walletAmount??"0")),
            style: TextStyle(color: TColor.primaryText, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
