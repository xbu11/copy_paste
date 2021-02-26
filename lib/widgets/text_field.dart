import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MTextField extends StatelessWidget {
  MTextField({
    Key key,
    this.label,
    this.title,
    this.onLongPress
  }): super (key: key);

  final String label;
  final String title;
  final Function onLongPress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.normal,
            fontSize: 14.0,
          ),
        ),
        Container(
          constraints: BoxConstraints(
            minHeight: 55.0,
            minWidth: 200,
            maxHeight: 55.0,
            maxWidth: 200
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.purple,
              width: 2.0
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: TextButton(
              onLongPress: () => onLongPress == null ? {} : onLongPress(label, title),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: title));
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: 20.0,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  )
                )
              )
            ),
          )
        )
      ],
    );
  }
}
