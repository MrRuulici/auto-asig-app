import 'package:auto_asig/core/data/constants.dart';
import 'package:flutter/material.dart';

class AutoAsigButtonEmpty extends StatelessWidget {
  final bool isActive;
  final void Function()? onPressed;
  final String text;
  final Widget? preTextIcon;
  // final Widget? postTextIcon;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? inactiveTextColor;
  final Color? inactiveBackgroundColor;
  final Color? activeTextColor;
  final Color? activeBackgroundColor;
  final double? buttonWidth;
  final double? buttonHeight;

  const AutoAsigButtonEmpty({
    required this.onPressed,
    required this.text,
    this.preTextIcon,
    // this.postTextIcon,
    this.isActive = true,
    this.textStyle,
    this.padding,
    this.margin,
    this.inactiveTextColor,
    this.inactiveBackgroundColor,
    this.activeTextColor,
    this.activeBackgroundColor,
    this.buttonWidth,
    this.buttonHeight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Color? inactiveC = inactiveBackgroundColor ?? Colors.grey[500];

    TextStyle finalTextStyle = textStyle ??
        TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isActive ? logoBlue : inactiveC,
        );

    // if (!isActive) {
    //   finalTextStyle = finalTextStyle.copyWith(
    //     color: inactiveTextColor ?? Colors.grey[500],
    //   );
    // } else if (activeTextColor != null) {
    //   finalTextStyle = finalTextStyle.copyWith(color: activeTextColor);
    // }

    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      width: buttonWidth ?? double.maxFinite,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: isActive ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // Transparent background
          foregroundColor:
              isActive ? logoBlue : inactiveTextColor, // Text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50), // Rounded corners
            side: BorderSide(
              color: isActive ? logoBlue : inactiveTextColor!, // Border color
              width: 2.0, // Border width
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (preTextIcon != null) ...[
              preTextIcon!,
              const SizedBox(width: 10),
            ],
            Flexible(
              child: Text(
                text,
                style: finalTextStyle,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
