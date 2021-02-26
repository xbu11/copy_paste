import 'package:flutter/material.dart';
import 'package:pua_copy_application/support/enums.dart';

class MainButton extends StatelessWidget {
  MainButton({
    Key key,
    //this.fileDownloading,
    //this.fileDownloaded,
    this.onPressed,
  }) : super(key: key);

  //final Function fileDownloading;
  //final Function fileDownloaded;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      splashColor: Colors.purple.shade500,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      constraints: const BoxConstraints(
        minHeight: 72.0,
        minWidth: 176.0
      ),
      fillColor: Colors.purple,
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.normal
      ),
      onPressed: () async {
        onPressed();
      },
      child: Center(
        child: Text(
          'Загрузить фулки',
        ),
      )
    );
  }
}

class SwitchButton extends StatelessWidget {
  SwitchButton({
    Key key,
    this.onPressed,
    this.value,
    this.title,
    this.backgroundColor,
    this.switchButtonType
  }) : super(key: key);

  final Function onPressed;
  final bool value;
  final String title;
  final Color backgroundColor;
  final switch_button_type switchButtonType;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(top: 12.0, left: 0.0, right: 0.0),
      child: OutlinedButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(134/3*2, 48)),
          backgroundColor: MaterialStateProperty.all(backgroundColor),
          side: MaterialStateProperty.all(BorderSide(color: value ? Colors.white : Colors.purple))
        ),
        onPressed: () => onPressed(switchButtonType, value),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Roboto',
            color: value ? Colors.white : Colors.purple
          ),
        ),
      ),
    );
  }
}

class DropdownButt extends StatelessWidget {
  DropdownButt({
    Key key,
    this.globalKey,
    this.values,
    this.hintTitle,
    this.onChanged,
    this.value
  
  }): super(key: key);

  final String globalKey;
  final List<String> values;
  final String hintTitle;
  final Function onChanged;
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      key: GlobalKey(debugLabel: '$globalKey'),
      style: TextStyle(
        color: Colors.purple,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.normal,
        fontSize: 16
      ),
      underline: Container(width: 0.0, decoration: BoxDecoration(border: Border.all(color: Colors.purple)),),
      hint: Text(
        hintTitle,
        style: TextStyle(
          color: Colors.purple.shade200,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.normal,
          fontSize: 16
        )
      ),
      iconSize: 32.0,
      iconEnabledColor: Colors.purple,
      focusColor: Colors.purple.shade400,
      items: values.map((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
              color: Colors.purple,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.normal,
              fontSize: 16
            ),
          ),
        );
      }).toList(),
      onChanged: (newValue) => onChanged(newValue),
      value: value,
    );
  }
}
