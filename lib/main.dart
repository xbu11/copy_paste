import 'dart:io';

import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pua_copy_application/enums.dart';

import 'data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'Pua Copy-Paste Application'),
    );
  }
}

Future<String> readTxt(File file) async {
  try {
    String content = await file.readAsString();

    return content;
  } catch (e) {
    print('File reading error!');
    return 'File reading error!';
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Data> mainData;
  bool showButton = true;
  bool fileIsDownloaded = false;
  BuildContext buttonContext;
  double buttonWidth;

  void initState() {
    super.initState();

    
    WidgetsBinding.instance
      .addPostFrameCallback((_) => buttonContext = context);
  }

  void fileDownloading() {
    buttonWidth = buttonContext.size.width;
    setState(() {
      showButton = false;
    });
  }

  void fileDownloaded(List<Data> datas) {
    setState(() {
      mainData = datas;
      fileIsDownloaded = true;
    });
  }

  String deleteOneStringEmail(String emails) {
    var result = emails;
    for (var i = 0; i < 8; i++) {
      var index = result.indexOf(':');
      result = result.substring(index+1, result.length);
    }

    var lastIndex = result.indexOf('\n');
    result = result.substring(lastIndex+1, result.length); 

    return result;
  }

  Map<String, Map<String, String>> getEmails(String emails) {
    var result = <String, Map<String, String>>{};
    //print(emails);
    var gmailLI = emails.indexOf(':');
    var gmailLogin = emails.substring(0, gmailLI);
    emails = emails.substring(gmailLI+1, emails.length);

    var gmailPI = emails.indexOf(':');
    var gmailPass = emails.substring(0, gmailPI);
    emails = emails.substring(gmailPI+1, emails.length);

    var mailruLI = emails.indexOf(':');
    var mailruLogin = emails.substring(0, mailruLI);
    emails = emails.substring(mailruLI+1, emails.length);

    var mailruPI = emails.indexOf(':');
    var mailruPass = emails.substring(0, mailruPI);
    emails = emails.substring(mailruPI+1, emails.length);

    result['Gmail'] = {gmailLogin: gmailPass};
    result['Mailru'] = {mailruLogin: mailruPass};

    return result;
  }

  List<Data> createData(String value, String emails) {
    List<Data> datas = <Data>[];
    List<String> peoples = <String>[];
    var allString = value;
    var nextTireIndex;
    var lastTireIndex;
    bool isLast = false;
    
    while(nextTireIndex != -1) {
      nextTireIndex = allString.indexOf('------');
      if (isLast) break;
      if (nextTireIndex == -1) {
        nextTireIndex = allString.length;
        isLast = true;
      }

      var oneMan = allString.substring(0, nextTireIndex);
      //print(oneMan);
      peoples.add(oneMan);

      lastTireIndex = allString.indexOf('- ');
      allString = allString.substring(lastTireIndex == -1 ? lastTireIndex+2 : lastTireIndex+1, allString.length);
    } 

    int dataIndex = 0;
    for (String string in peoples) {
      String names;
      Data data = new Data();
      data.index = dataIndex;
      var birthDate;

      // Names
      var nameDotsIndex = string.indexOf(RegExp(r':[0-9]|:[P][O]\ [B][O][X]|:[a-zA-z][0-9]'));
      if (nameDotsIndex == -1) break;
      names = string.substring(0, nameDotsIndex);
      string = string.substring(nameDotsIndex+1, string.length);
      names = names.replaceAll(':', ' ');
      names = names.replaceAll('\n', '');
      names = names.replaceAll(' JR', '');
      if (names.indexOf(' ') == 0) names = names.replaceFirst(' ', '');
      var regex = RegExp(r"[a-zA-Z]\w+|[a-zA-Z]");
      var matches = regex.allMatches(names);
      if (names.indexOf(' ') != names.lastIndexOf(' ')) {
        var c = 0;
        matches.forEach((element) {
          switch (c) {
            case 0: {
              data.firstName = element.group(0);
              break;
            }
            case 1: {
              data.middleName = element.group(0);
              break;
            }
            case 2: {
              data.lastName = element.group(0);
              break;
            }
          }
          c++;
          //if (c > 2) c = 0;
        });
      } else if (names.indexOf(' ') == names.lastIndexOf(' ')) {
          var c = 0;
          data.middleName = 'Empty';
          matches.forEach((element) {
          switch (c) {
            case 0: {
              data.firstName = element.group(0);
              break;
            }
            case 1: {
              data.lastName = element.group(0);
              break;
            }
          }
          c++;
          //if (c > 1) c = 0;
        });
      }

      // Address
      var addressDotsIndex = string.indexOf(':');
      data.address = string.substring(0, addressDotsIndex);
      string = string.substring(addressDotsIndex+1, string.length);

      // City
      var cityDotsIndex = string.indexOf(':');
      data.city = string.substring(0, cityDotsIndex);
      string = string.substring(cityDotsIndex+1, string.length);

      // State
      var stateDotsIndex = string.indexOf(':');
      data.state = string.substring(0, stateDotsIndex);
      string = string.substring(stateDotsIndex+1, string.length);

      // Post Code
      var postDotsIndex = string.indexOf(':');
      data.postCode = string.substring(0, postDotsIndex);
      string = string.substring(postDotsIndex+1, string.length);

      // SSN
      var ssnDotsIndex = string.indexOf(':');
      data.ssn = string.substring(0, ssnDotsIndex);
      string = string.substring(ssnDotsIndex+1, string.length);

      // Birth Date
      var birthDotsIndex = string.indexOf('\n');
      birthDate = string.substring(0, birthDotsIndex);
      data.birthDate = birthDate;
      string = string.substring(birthDotsIndex+1, string.length);

      //DL
      if (dlSwitchValue) {
        if (string.contains('DL/ID')) {
          var regex = RegExp(r"[A-Z]\d{3}-\d{4}-\d{4}-\d{2}");
          if (regex.hasMatch(string)) {
            data.dl = regex.stringMatch(string);
          } else {
            data.dl = 'NO DL';
          }
        } else data.dl = 'NO DL';

        //Iss and exp dates
        if (data.dl != 'NO DL') {
          var issDate = '';
          var expDate = '';
          var regex = RegExp(r"(0[1-9]|1[012])[- \/.](0[1-9]|[12][0-9]|3[01])[- \/.](19|20)\d\d");
          var i = 0;
          regex.allMatches(string).forEach((element) {
            switch (i) {
              case 0: {
                data.issDate = '${element.group(0)}';
                break;
              }
              case 1: {
                data.expDate = '${element.group(0)}';
                break;
              }
              default: {
                break;
              }
            }
            i++;
            
          });
        } else {
          data.issDate = 'NO DL';
          data.expDate = 'NO DL';
        }
      } else {
        data.dl = 'Empty';
        data.issDate = 'Empty';
        data.expDate = 'Empty';
      }
      
      //Phone number
      if (phoneSwitchValue) {
        var phoneReg = RegExp(r"\([2-9]\d{2}\) \d{3}-\d{4}");
        if (phoneReg.hasMatch(string)) {
          data.phoneNumber = phoneReg.stringMatch(string);
        } else {
          data.phoneNumber = 'No phone';
        }
      } else {
        data.phoneNumber = 'Empty';
      }
      
      datas.add(data);
      dataIndex++;
    }

    // Emails
    if (emailsSwitchValue) {
      
      for (Data data in datas) {
        if (!emails.isEmpty) {
          var email = getEmails(emails);
          //print(email);
          emails = deleteOneStringEmail(emails);

          var gmailLogin = email['Gmail'].keys.elementAt(0);
          data.gmailLogin = gmailLogin.substring(gmailLogin.indexOf(RegExp(r"[a-zA-Z]")), gmailLogin.length);//[email['Gmail'].keys.elementAt(0)];
          data.gmailPass = email['Gmail'].values.elementAt(0);//[email['Gmail'].keys.elementAt(1)];
          data.mailruLogin = email['Mailru'].keys.elementAt(0);//[email['Mailru'].keys.elementAt(0)];
          data.mailruPass = email['Mailru'].values.elementAt(0);//[email['Mailru'].keys.elementAt(1)];
        } else {
          data.gmailLogin = 'Empty';
          data.gmailPass = 'Empty';
          data.mailruLogin ='Empty';
          data.mailruPass = 'Empty';
        }
      }

      // PUAs and Banks
      for (Data data in datas) {
        var puaLogin;
        var puaPass;

        if(data.gmailLogin != 'Empty') {
          //print(data.gmailLogin);
          var puaLI = data.gmailLogin.indexOf('@');
          puaLogin = data.gmailLogin.substring(0, puaLI);
          
          puaPass = data.gmailPass;

          data.puaLogin = puaLogin;
          data.puaPass = puaPass;
          
          data.bankLogin = data.puaLogin;
          data.bankPass = data.puaPass;
        } else {
          data.puaLogin = 'Empty';
          data.puaPass = 'Empty';
          
          data.bankLogin = 'Empty';
          data.bankPass = 'Empty';
        }
        
      }
    } else {
      for (Data data in datas) {
        data.gmailLogin = 'Empty';
        data.gmailPass = 'Empty';
        data.mailruLogin = 'Empty';
        data.mailruPass = 'Empty';
        data.puaLogin = 'Empty';
        data.puaPass = 'Empty';
        data.bankLogin = 'Empty';
        data.bankPass = 'Empty';
      }
    }
    
    return datas;
  }

  Widget mainButton() {
    return RawMaterialButton(
      splashColor: Colors.purple.shade500,
      fillColor: Colors.purple,
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontFamily: 'Roboto-Regular',
        fontWeight: FontWeight.normal
      ),
      onPressed: () async {
        final file = OpenFilePicker()
          ..filterSpecification = {
            'Text Document (*.txt)': '*.txt'
          }
          ..defaultFilterIndex = 0
          ..defaultExtension = 'txt'
          ..title = 'Select a file';
        
        final result = file.getFile();
        fileDownloading();
        if(result != null) {
          File txtFile = File(result.path);
          var datas;
          readTxt(txtFile).then((value) {
            var newValue = value;
            if (!newValue.contains('------')){
              newValue = value.replaceAll('\n', '\n------ \n');
              newValue = newValue.replaceRange(newValue.lastIndexOf('\n') - 7, newValue.lastIndexOf('\n'), '\n');
            }

            String emails;
            var emailsIndex = value.lastIndexOf('____');
            emails = value.substring(emailsIndex+4, value.length);//.replaceAll('\n', '');
            print(emails);
            datas = createData(newValue, emails);
          }).whenComplete(() => fileDownloaded(datas));
        } else {
          setState(() {
            showButton = true;
          });
        }
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(38, 16, 38, 16),
        child: Text(
          'Загрузить фулки',
        ),
      )
    );
  }

  Future<void> showAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Закрыть окно?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Осторожно!'),
                Text('Не сохраненные данные будут потеряны.'),
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
            TextButton(
              child: Text(
                'Хорошо',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  //fontWeight: FontWeight.bold
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  fileIsDownloaded = false;
                  showButton = true;
                });
              },
            ),
          ],
        );
      },
    );
  }

  void closeFunc() {
    showAlert();
  }

  bool dlSwitchValue = false;
  bool phoneSwitchValue = false;
  bool emailsSwitchValue = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: fileIsDownloaded
      ? Fields(data: mainData, closeFunc: closeFunc,)
      : Center(
        child: showButton 
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            mainButton(),
            ConstrainedBox(
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
                    value: dlSwitchValue,
                    onChanged: (value) {
                      setState(() {
                        dlSwitchValue = value;
                      });
                    }
                  )
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 256,
                maxWidth: 256
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Есть номер телефона'
                  ),
                  Switch(
                    value: phoneSwitchValue,
                    onChanged: (value) {
                      setState(() {
                        phoneSwitchValue = value;
                      });
                    }
                  )
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 256,
                maxWidth: 256
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Есть почты'
                  ),
                  Switch(
                    value: emailsSwitchValue,
                    onChanged: (value) {
                      setState(() {
                        emailsSwitchValue = value;
                      });
                    }
                  )
                ],
              )
            )
          ],
        ) 
        : indicator()
        ),
      );
  }
}


Widget indicator() {
  return  CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
    backgroundColor: Colors.grey
  );
}


class Fields extends StatefulWidget {
  Fields({Key key, this.data, this.closeFunc}) : super(key: key);

  final List<Data> data;
  final Function closeFunc;

  @override
  _FieldsState createState() => _FieldsState();
}

class _FieldsState extends State<Fields> {
  List<Data> data;
  List<String> names = [];
  String currentValue;
  Data currentData;

  @override
  void initState() {
    super.initState();
    data = widget.data;

    int c = 1;
    for (Data data in data) {
      names.add('$c. ${data.firstName} ${data.middleName} ${data.lastName}');
      c++;
    }
  }

  Future<void> changeDialog(String text, data_types type) async {
    var controller = TextEditingController();
    controller.text = text;

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
                  fontWeight: FontWeight.bold
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
                setState(() {
                  switch (type) {
                    case data_types.first: currentData.firstName = controller.text; break;
                    case data_types.middle: currentData.middleName = controller.text; break;
                    case data_types.last: currentData.lastName = controller.text; break;
                    case data_types.address: currentData.address = controller.text; break;
                    case data_types.city: currentData.city = controller.text; break;
                    case data_types.state: currentData.state = controller.text; break;
                    case data_types.post: currentData.postCode = controller.text; break;
                    case data_types.ssn: currentData.ssn = controller.text; break;
                    case data_types.birth: currentData.birthDate = controller.text; break;
                    case data_types.phone: currentData.phoneNumber = controller.text; break;
                    case data_types.dl: currentData.dl = controller.text; break;
                    case data_types.iss: currentData.issDate = controller.text; break;
                    case data_types.exp: currentData.expDate = controller.text; break;
                    case data_types.company: currentData.company = controller.text; break;
                    case data_types.job: currentData.jobTitle = controller.text; break;
                    case data_types.sJob: currentData.startJob = controller.text; break;
                    case data_types.eJob: currentData.endJob = controller.text; break;
                    case data_types.gLogin: currentData.gmailLogin = controller.text; break;
                    case data_types.gPass: currentData.gmailPass = controller.text; break;
                    case data_types.mLogin: currentData.mailruLogin = controller.text; break;
                    case data_types.mPass: currentData.mailruPass = controller.text; break;
                    case data_types.pLogin: currentData.puaLogin = controller.text; break;
                    case data_types.pPass: currentData.puaPass = controller.text; break;
                    case data_types.bLogin: currentData.bankLogin = controller.text; break;
                    case data_types.bPass: currentData.bankPass = controller.text; break;
                  }
                  currentValue = currentValue[0] + currentValue[1] + ' ${currentData.firstName} ${currentData.middleName} ${currentData.lastName}';
                  data[currentData.index] = currentData; 
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget dropdownButton() {
    return DropdownButton<String>(
      key: GlobalKey(debugLabel: 'Main Dropdown'),
      style: TextStyle(
        color: Colors.purple,
        fontFamily: 'Roboto-Regular',
        fontWeight: FontWeight.bold,
        fontSize: 16
      ),
      underline: Container(width: 0.0, decoration: BoxDecoration(border: Border.all(color: Colors.purple)),),
      hint: Text(
        'Выберите фулку',
        style: TextStyle(
          color: Colors.purple.shade200,
          fontFamily: 'Roboto-Regular',
          fontWeight: FontWeight.bold,
          fontSize: 16
        )
      ),
      iconSize: 32.0,
      iconEnabledColor: Colors.purple,
      focusColor: Colors.purple.shade400,
      value: currentValue,
      items: names.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          currentValue = newValue;
          currentData = data[names.indexWhere((element) => element == currentValue)];
        });
      },
    );
  }

  data_types getDataType(String string) {
    data_types result;

    switch (string) {
      case 'First Name': result = data_types.first; break;
      case 'Middle Name': result = data_types.middle; break;
      case 'Last Name': result = data_types.last; break;
      case 'Address': result = data_types.address; break;
      case 'City': result = data_types.city; break;
      case 'State': result = data_types.state; break;
      case 'Post Code': result = data_types.post; break;
      case 'SSN': result = data_types.ssn; break;
      case 'Birth Date': result = data_types.birth; break;
      case 'Phone Number': result = data_types.phone; break;
      case 'DL/ID': result = data_types.dl; break;
      case 'Issuance Date': result = data_types.iss; break;
      case 'Expiration Date': result = data_types.exp; break;
      case 'Company': result = data_types.company; break;
      case 'Job Title': result = data_types.job; break;
      case 'Start of Job': result = data_types.sJob; break;
      case 'End of Job': result = data_types.eJob; break;
      case 'Gmail Login': result = data_types.gLogin; break;
      case 'Gmail Pass': result = data_types.gPass; break;
      case 'Mailru Login': result = data_types.mLogin; break;
      case 'Mailru Pass': result = data_types.mPass; break;
      case 'PUA Login': result = data_types.pLogin; break;
      case 'PUA Pass': result = data_types.pPass; break;
      case 'Bank Login': result = data_types.bLogin; break;
      case 'Bank Pass': result = data_types.bPass; break;
    }

    return result;
  }

  Widget textField(String label, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontFamily: 'Roboto-Regular',
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
              onLongPress: () {
                data_types type = getDataType(label);
                changeDialog(text, type);
              },
              onPressed: () {
                Clipboard.setData(ClipboardData(text: text));
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: 20.0,
                        fontFamily: 'Roboto-Regular',
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

  String getFileContent(Data data) {
    String result = '';

    result = result + 'Full Name: ${data.firstName} ${data.middleName} ${data.lastName}\n';
    result = result + 'Address: ${data.address}\n';
    result = result + 'City: ${data.city}\n';
    result = result + 'State: ${data.state}\n';
    result = result + 'Post Code: ${data.postCode}\n';
    result = result + 'SSN: ${data.ssn}\n';
    result = result + 'Birth Date: ${data.birthDate}\n';
    result = result + 'Phone Number: ${data.phoneNumber}\n';
    result = result + 'DL/ID: ${data.dl}\n';
    result = result + 'Issuance Date: ${data.issDate}\n';
    result = result + 'Expiration Date: ${data.expDate}\n';
    result = result + 'Company: ${data.company}\n';
    result = result + 'Job Title: ${data.jobTitle}\n';
    result = result + 'Start of Job: ${data.startJob}\n';
    result = result + 'End of job: ${data.endJob}\n';
    result = result + 'Gmail: ${data.gmailLogin}:${data.gmailPass}\n';
    result = result + 'Mailru: ${data.mailruLogin}:${data.mailruPass}\n';
    result = result + 'PUA: ${data.puaLogin}:${data.puaPass}\n';
    result = result + 'Bank: ${data.bankLogin}:${data.bankPass}';

    return result;
  }

  String getAllFileContent(List<Data> datas) {
    String result = '';

    String emails = '';

    for (Data data in datas) {
      result = result + data.firstName + ' ' + data.middleName + ' ' + data.lastName + ':' + data.address + ':' + data.city + ':' + data.state + ':' + data.postCode + ':' + data.ssn + ':' + data.birthDate + '\n';
      result = result + 'DL/ID: ' + data.dl + '\n';
      result = result + 'Issuane Date: ' + data.issDate + '\n';
      result = result + 'Expiration Date: ' + data.expDate + '\n';
      result = result + 'Phone Number: ' + data.phoneNumber + '\n';
      result = result + 'Company: ${data.company}\n';
      result = result + 'Job Title: ${data.jobTitle}\n';
      result = result + 'Start of Job: ${data.startJob}\n';
      result = result + 'End of job: ${data.endJob}\n';
      data.index == datas.length ? result = result + '\n' : result = result + '------ \n';

      emails = emails + data.gmailLogin + ':' + data.gmailPass + ':' + data.mailruLogin + ':' + data.mailruPass + ':\n';
    }

    result = result + '______\n';
    result = result + emails;
    return result;
  }

  Widget memoButtons(String memoWord) {

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

  Future<void> showMemo(String memo) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Memo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                memoButtons(memo)
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

  Widget mainContainer() {
    var linksAndOther = ['8medkcLmo8', 'http://truthfinder.com', 'https://trust.dot.state.wi.us/ecdl/home.do', 'http://beenverified.com','https://my.unemployment.wisconsin.gov/Claimant/Logon/TermsAndConditions', ];

    return Container(
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 28),
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
      constraints: BoxConstraints(
        minHeight: double.infinity,
        minWidth: double.infinity,
        maxHeight: double.infinity,
        maxWidth: double.infinity
      ),
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  dropdownButton(),
                  DropdownButton<String>(
                    key: GlobalKey(debugLabel: 'Help Dropdown'),
                    style: TextStyle(
                      color: Colors.purple,
                      fontFamily: 'Roboto-Regular',
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                    underline: Container(width: 0.0, decoration: BoxDecoration(border: Border.all(color: Colors.purple)),),
                    hint: Text(
                      'Ссылки и данные',
                      style: TextStyle(
                        color: Colors.purple.shade200,
                        fontFamily: 'Roboto-Regular',
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      )
                    ),
                    iconSize: 32.0,
                    iconEnabledColor: Colors.purple,
                    focusColor: Colors.purple.shade400,
                    value: null,
                    items: linksAndOther.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue == '8medkcLmo8') {
                        showMemo(newValue);
                      }
                      Clipboard.setData(ClipboardData(text: newValue));
                    },
                  )
                ],
              ),
              // Names
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  textField('First Name', currentData == null ? '' : currentData.firstName),
                  textField('Middle Name', currentData == null ? '' : currentData.middleName),
                  textField('Last Name', currentData == null ? '' : currentData.lastName),
                ],
              ),
              // Address
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  textField('Address', currentData == null ? '' : currentData.address),
                  textField('City', currentData == null ? '' : currentData.city),
                  textField('State', currentData == null ? '' : currentData.state),
                  textField('Post Code', currentData == null ? '' : currentData.postCode),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Ssn
                  textField('SSN', currentData == null ? '' : currentData.ssn),
                  // Year
                  textField('Birth Date', currentData == null ? '' : currentData.birthDate),
                  // Phone Number
                  textField('Phone Number', currentData == null ? '' : currentData.phoneNumber),
                  // DL/ID
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  textField('DL/ID', currentData == null ? '' : currentData.dl),
                  textField('Issuance Date', currentData == null ? '' : currentData.issDate),
                  textField('Expiration Date', currentData == null ? '' : currentData.expDate),
                ],
              ),
              // Work
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  textField('Company', currentData == null ? '' : currentData.company),
                  textField('Job Title', currentData == null ? '' : currentData.jobTitle),
                ],
              ),
              // Dates
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  textField('Start of Job', currentData == null ? '' : currentData.startJob),
                  textField('End of Job', currentData == null ? '' : currentData.endJob),
                ],
              ),
              // Gmails
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textField('Gmail Login', currentData == null ? '' : currentData.gmailLogin),
                  textField('Gmail Pass', currentData == null ? '' : currentData.gmailPass),
                ],
              ),
              // Mails
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textField('Mail.ru Login', currentData == null ? '' : currentData.mailruLogin),
                  textField('Mail.ru Pass', currentData == null ? '' : currentData.mailruPass),
                ],
              ),
              // PUA DATA
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textField('PUA Login', currentData == null ? '' : currentData.puaLogin),
                  textField('PUA Pass', currentData == null ? '' : currentData.puaPass),
                ],
              ),
              // Bank Data
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textField('Bank Login', currentData == null ? '' : currentData.bankLogin),
                  textField('Bank Pass', currentData == null ? '' : currentData.bankPass),
                ],
              ),
              // Save and Exit Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: RawMaterialButton(
                      fillColor: Colors.red,
                      onPressed: (){
                        setState(() {
                          if (currentValue != null) {
                            data.removeAt(currentData.index);
                            currentValue = null;
                            currentData = null;

                            var c = 1;
                            names = [];
                            for (Data data in data) {
                              data.index = c-1;
                              names.add('$c. ${data.firstName} ${data.middleName} ${data.lastName}');
                              c++;
                            }
                          }
                        });
                      },
                      child: Text(
                        'Delete This',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 8.0, left: 8.0),
                    child: RawMaterialButton(
                      fillColor: Colors.red,
                      onPressed: (){
                        widget.closeFunc();
                      },
                      child: Text(
                        'Close',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8),
                    child: RawMaterialButton(
                      fillColor: Colors.purple,
                      onPressed: (){
                        String fileContent = getAllFileContent(data);
                          var file = SaveFilePicker()
                            ..fileName = 'work_data.txt'
                            ..title = 'Сохранить файл'
                            ..defaultExtension = 'txt'
                            ..fileMustExist = true;

                          var result = file.getFile();
                          File(result.path).writeAsStringSync(fileContent);
                      },
                      child: Text(
                        'Save All',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: RawMaterialButton(
                      fillColor: Colors.purple,
                      onPressed: (){
                        if (currentValue != null) {
                          String fileContent = getFileContent(currentData);
                          var file = SaveFilePicker()
                            ..fileName = currentValue+'.txt'
                            ..title = 'Сохранить файл'
                            ..defaultExtension = 'txt'
                            ..fileMustExist = true;

                          var result = file.getFile();
                          File(result.path).writeAsStringSync(fileContent);
                        }
                      },
                      child: Text(
                        'Save File',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    )
                  )
                ],
              )
            ],
          ),
        ],
      )
    );

    
  }

  @override
  Widget build(BuildContext context) {
    return mainContainer();
  }
}
