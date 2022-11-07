import 'package:flutter/material.dart';

/// Button with the primary app color
class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.text,
    required this.onPressedAction,
    this.showLoader = false,
    this.color,
    this.elevation = 0,
    super.key,
    this.height,
    this.width,
  });

  /// The text to display on the button
  final String text;

  /// The action to perform when the button is pressed
  final Function() onPressedAction;

  /// Replace the button text for a loader
  final bool showLoader;

  /// Elevation of the button.
  final double elevation;

  final Color? color;

  final double? height;

  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width,
      height: height ?? 56,
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(elevation),
          backgroundColor: MaterialStateProperty.all(
            color ?? Colors.black,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                50,
              ),
            ),
          ),
        ),
        onPressed: showLoader ? () {} : onPressedAction,
        child: showLoader
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                text,
                style: const TextStyle(color: Colors.white),
              ),
      ),
    );
  }
}
