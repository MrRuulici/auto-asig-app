import 'package:auto_asig/core/data/constants.dart';
import 'package:flutter/material.dart';

class AutoAsigButton extends StatelessWidget {
  final bool isActive;
  final void Function()? onPressed;
  final String text;
  final Widget? preTextIcon;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? inactiveTextColor;
  final Color? inactiveBackgroundColor;
  final Color? activeTextColor;
  final Color? activeBackgroundColor;
  final double? buttonWidth;
  final double? buttonHeight;
  final Widget? child;

  const AutoAsigButton({
    required this.onPressed,
    required this.text,
    this.preTextIcon,
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
    this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle finalTextStyle = textStyle ??
        // const TextStyle(
        //   fontSize: 16,
        //   fontWeight: FontWeight.bold,
        //   color: Colors.white,
        // );
        const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          fontSize: 20,
        );

    if (!isActive) {
      finalTextStyle = finalTextStyle.copyWith(
        color: inactiveTextColor ?? Colors.grey[500],
      );
    } else if (activeTextColor != null) {
      finalTextStyle = finalTextStyle.copyWith(color: activeTextColor);
    }

    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      width: buttonWidth ?? double.maxFinite,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: isActive ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive
              ? activeBackgroundColor ?? primaryBlue
              : inactiveBackgroundColor ?? Colors.grey,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
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
            child ??
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
