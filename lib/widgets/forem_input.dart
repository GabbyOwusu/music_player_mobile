import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  final Widget? title;
  final Widget child;
  final bool boldTitle;
  final EdgeInsets? margin;
  const FormInput({
    Key? key,
    required this.child,
    this.title,
    this.boldTitle = true,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            DefaultTextStyle(
              child: title!,
              style: DefaultTextStyle.of(context).style.copyWith(
                    fontSize: 16,
                    fontWeight: boldTitle ? FontWeight.w500 : FontWeight.normal,
                  ),
            ),
            SizedBox(height: 10),
          ],
          child,
        ],
      ),
    );
  }
}
