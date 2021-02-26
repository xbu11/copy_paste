import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwitchWithText extends StatelessWidget {
  SwitchWithText({
    Key key,
    this.text,
    this.value,
    this.onChanged
  }) : super(key: key);

  final String text;
  final bool value;
  Function onChanged;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 256,
        maxWidth: 256
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Есть права'
          ),
          Switch(
            value: value,
            onChanged: (newValue) {
              onChanged(newValue);
              // setState(() {
              //   dlSwitchValue = text;
              // });
            }
          )
        ],
      ),
    );
  }
}
