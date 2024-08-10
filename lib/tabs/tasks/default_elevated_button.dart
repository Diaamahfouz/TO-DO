import 'package:flutter/material.dart';
import 'package:todo/app_theme.dart';

class DefaultElevatedButton extends StatelessWidget {
  DefaultElevatedButton({
    required this.label,
    required this.onPressed,
  });
  String label;
  VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    TextStyle? titleMediumStyle = Theme.of(context).textTheme.titleMedium;
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: titleMediumStyle?.copyWith(
            fontWeight: FontWeight.w400, color: AppTheme.white),
      ),
      style: ElevatedButton.styleFrom(
          fixedSize: Size(MediaQuery.of(context).size.width, 52)),
    );
  }
}
