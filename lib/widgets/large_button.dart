import 'package:flutter/material.dart';

class LargeButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isFullWidth;
  final EdgeInsets? margin;
  final bool bottomSafeArea;
  final Color? backgroundColor;
  final Color? textColor;

  const LargeButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isFullWidth = true,
    this.bottomSafeArea = true,
    this.margin,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      bottom: bottomSafeArea,
      child: Container(
        margin: margin,
        width: isFullWidth ? double.infinity : null,
        child: MaterialButton(
          elevation: 0,
          highlightElevation: 0,
          onPressed: onPressed,
          disabledColor: theme.disabledColor,
          color: backgroundColor ?? theme.primaryColor,
          textColor: textColor ?? theme.backgroundColor,
          disabledTextColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 22),
          splashColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
