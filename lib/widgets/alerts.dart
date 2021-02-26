import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pua_copy_application/support/enums.dart';

class Dialogs {
  static Future<void> showAddEmailsDialog(BuildContext buildContext, Function onGoodTap) async {
    String result;

    var controller = TextEditingController();

    return showDialog<void>(
      context: buildContext,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Emails'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: controller,
                  autofocus: true,
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Отмена',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.normal
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Хорошо',
                style: TextStyle(
                  fontFamily: 'Roboto',
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                result = controller.text;
                onGoodTap(result);
              },
            ),
          ],
        );
      },
    );
  }

  static Widget _memoButtons(String memoWord) {
    List<Widget> buttons = [];
    var c = 1;
    memoWord.characters.forEach((element) {
      buttons.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(c.toString()),
            OutlinedButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: element));
              },
              child: Text(element),
            )
          ],
        )
      );
      c++;
    });
    return Center(
      child: Row(
        children: buttons
      ),
    );
  }

  static Future<void> showMemoDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Memo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _memoButtons('8medkcLmo8')
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Отмена',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> showChangeDataDialog(BuildContext context, String title, person_data_types type, Function onSaveTap) async {
    var controller = TextEditingController();
    controller.text = title;

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Введите новую строку'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: controller,
                  autofocus: true,
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Отмена',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.normal
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Сохранить',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  //fontWeight: FontWeight.bold
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onSaveTap(controller.text, type);
              },
            ),
          ],
        );
      },
    );
  }
}


// Future<void> showCloseAlert() async {
//   return showDialog<void>(
//     context: context,
//     barrierDismissible: false, // user must tap button!
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Закрыть окно?'),
//         content: SingleChildScrollView(
//           child: ListBody(
//             children: <Widget>[
//               Text('Осторожно!'),
//               Text('Не сохраненные данные будут потеряны.'),
//             ],
//           ),
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: Text(
//               'Отмена',
//               style: TextStyle(
//                 fontFamily: 'Roboto',
//                 fontWeight: FontWeight.bold
//               ),
//             ),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//           TextButton(
//             child: Text(
//               'Хорошо',
//               style: TextStyle(
//                 fontFamily: 'Roboto',
//                 //fontWeight: FontWeight.bold
//               ),
//             ),
//             onPressed: () {
//               Navigator.of(context).pop();
              
//             },
//           ),
//         ],
//       );
//     },
//   );
// }