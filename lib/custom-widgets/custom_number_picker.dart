import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class CustomNumberPicker extends StatefulWidget {
  const CustomNumberPicker({
    Key key,
    @required this.update,
    this.initialValue,
  }) : super(key: key);

  final Function update;
  final int initialValue;

  @override
  _CustomNumberPickerState createState() => _CustomNumberPickerState();
}

class _CustomNumberPickerState extends State<CustomNumberPicker> {

  int currentNumber = 0;
  bool init = true;

  @override
  Widget build(BuildContext context) {

    if (init && widget.initialValue != null) {
      currentNumber = widget.initialValue;
     init = !init;
    }

    return NumberPicker(
      axis: Axis.horizontal,
      value: currentNumber,
      minValue: 0,
      maxValue: 999,
      onChanged: (value) => {
        setState(() => currentNumber = value),
        widget.update(currentNumber),
      }
    );
  }
}