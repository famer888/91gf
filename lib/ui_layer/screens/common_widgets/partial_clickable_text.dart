import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PartialClickableText extends StatelessWidget {
  final String prefixText;
  final String afterFixText;
  final TextStyle? prefixTextStyle;
  final TextStyle? afterTextStyle;
  final VoidCallback onTap;

  const PartialClickableText({super.key, required this.prefixText, required this.afterFixText, this.prefixTextStyle, this.afterTextStyle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: prefixText,
            // '*如提【交易失败】【账户风险】等，可重新发起订单，或在15分钟后重试支付。如有任何问题，',
            style: prefixTextStyle ?? const TextStyle(color: Colors.white, fontSize: 16),
          ),
          TextSpan(
            text: afterFixText,
            // '在线客服',
            style: afterTextStyle ?? const TextStyle(color: Colors.blue, fontSize: 16, decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
              ..onTap = onTap,
          ),
        ],
      ),
    );
  }
}
