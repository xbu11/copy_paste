import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pua_copy_application/files_io/files_writing.dart';
import 'package:pua_copy_application/objects/person.dart';
import 'package:pua_copy_application/strings/emails_conversion.dart';
import 'package:pua_copy_application/support/enums.dart';
import 'package:pua_copy_application/support/texts.dart';
import 'package:pua_copy_application/support/validators.dart';
import 'package:pua_copy_application/widgets/alerts.dart';
import 'package:pua_copy_application/widgets/buttons.dart';

import 'text_field.dart';

class MainMenu extends StatefulWidget {
  MainMenu({
    Key key,
    this.personList,
    this.onCloseButtonPressed,
    this.workFile,
    this.workFileType,
  }): super(key: key);

  final List<Person> personList;
  final Function onCloseButtonPressed;
  final File workFile;
  final file_type workFileType;

  @override
  State<StatefulWidget> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  Person currentPerson;
  int currentPersonNumber;

  List<String> fullsDropdownValues;
  String currentFullsDropdownValue;

  List<String> linksDropdownValues;

  @override
  void initState() {
    super.initState();
    
    fullsDropdownValues = <String>[];
    widget.personList.forEach((person) {
      fullsDropdownValues.add('${person.number+1}. ${person.name.firstName}' + (person.name.middleName == null ? ' ' : ' ${person.name.middleName} ') + '${person.name.lastName}');
    });

    if (widget.workFileType == file_type.single) {
      currentPerson = widget.personList[0];
      currentPersonNumber = 0;
      currentFullsDropdownValue = fullsDropdownValues[0];
    }

    linksDropdownValues = Texts.links;
  }

  saveWorkFile() {
    String fullName;
    if (widget.workFileType == file_type.single) {
      fullName = (currentPerson.name.middleName == null) ? ('${currentPerson.name.firstName} ${currentPerson.name.lastName}') : ('${currentPerson.name.firstName} ${currentPerson.name.middleName} ${currentPerson.name.lastName}');
    }
    
    FilesWriting.saveWorkFile(widget.workFile, widget.workFileType, widget.personList, fullName);
  }

  deleteFromPersonList(Person person) {
    widget.personList.removeWhere((per) => per.number == person.number);
  }

  updatePersonList(Person person) {
    var index = widget.personList.indexWhere((per) => per.number == person.number);
    widget.personList[index] = person;
  }

  onFullDropdownButtChanged(dynamic newValue) {
    setState(() {
      currentFullsDropdownValue = newValue;
      currentPersonNumber = int.parse((newValue as String).substring(0, newValue.toString().indexOf('.')))-1;
      currentPerson = widget.personList.where((person) => person.number == currentPersonNumber).first;
    });
  }

  onLinksDropdownButtChanged(dynamic newValue) {
    Clipboard.setData(ClipboardData(text: newValue));
  } 

  onDeleteButtonPressed() {
    setState(() {
      currentFullsDropdownValue = null;
      deleteFromPersonList(currentPerson);
      fullsDropdownValues = <String>[];
      widget.personList.forEach((person) {
        fullsDropdownValues.add('${person.number+1}. ${person.name.firstName}' + (person.name.middleName == null ? ' ' : ' ${person.name.middleName} ') + '${person.name.lastName}');
      });
      currentPersonNumber = null;
      currentPerson = null;
    });
    saveWorkFile();
  }

  onTextFieldDialogSaveTap(String newTitle, person_data_types type) {
    setState(() {
      switch (type) {
        case person_data_types.first: currentPerson.name.firstName = newTitle; break;
        case person_data_types.middle: currentPerson.name.middleName = newTitle; break;
        case person_data_types.last :currentPerson.name.lastName = newTitle; break;
        case person_data_types.address: currentPerson.address.address = newTitle; break;
        case person_data_types.city: currentPerson.address.city = newTitle; break;
        case person_data_types.state: currentPerson.address.state = newTitle; break;
        case person_data_types.post: currentPerson.address.postCode = newTitle; break;
        case person_data_types.ssn: currentPerson.ssn = newTitle; break;
        case person_data_types.birth: currentPerson.birthDate = newTitle; break;
        case person_data_types.phone: currentPerson.phoneNumber = newTitle; break;
        case person_data_types.dl: currentPerson.driverLicense.number = newTitle; break;
        case person_data_types.iss: currentPerson.driverLicense.issDate = newTitle; break;
        case person_data_types.exp: currentPerson.driverLicense.expDate = newTitle; break;
        case person_data_types.company: currentPerson.job.company = newTitle; break;
        case person_data_types.job: currentPerson.job.jobTitle = newTitle; break;
        case person_data_types.sJob: currentPerson.job.startJob = newTitle; break;
        case person_data_types.eJob: currentPerson.job.endJob = newTitle; break;
        default: break;
        // case person_data_types.gLogin: currentPerson.emails.gmail.login = newTitle; break;
        // case person_data_types.gPass: currentPerson.emails.gmail.pass = newTitle; break;
        // case person_data_types.mLogin: currentPerson.emails.mailru.login = newTitle; break;
        // case person_data_types.mPass: currentPerson.emails.mailru.pass = newTitle; break;
        // case person_data_types.login: currentPerson.loginDetails.login = newTitle; break;
        // case person_data_types.pass: currentPerson.loginDetails.pass = newTitle; break;
      }
      if (type == person_data_types.middle) {
        currentFullsDropdownValue = null;
        fullsDropdownValues = <String>[];
        widget.personList.forEach((person) {
          fullsDropdownValues.add('${person.number+1}. ${person.name.firstName}' + (person.name.middleName == null ? ' ' : ' ${person.name.middleName} ') + '${person.name.lastName}');
        });
        currentFullsDropdownValue = fullsDropdownValues.firstWhere((value) => value.contains((currentPersonNumber+1).toString()));
      }
      updatePersonList(currentPerson);
    });
    saveWorkFile();
  }

  onTextFieldLongPress(String label, String title) {
    person_data_types type = PersonDataTypeValidator.getDataType(label);
    Dialogs.showChangeDataDialog(context, title, type, onTextFieldDialogSaveTap);
  }

  onDeleteEmailsButtonPressed() {
    setState(() {
      currentPerson.emails = null;
      currentPerson.loginDetails = null;
      updatePersonList(currentPerson);
    });
    saveWorkFile();
  }

  onAddEmailGoodTap(String emails) {
    var emailsForCreate = EmailsConversion.getEmails(emails);
    setState(() {
      currentPerson.addEmails(emailsForCreate);
      updatePersonList(currentPerson);
    });
    saveWorkFile();
  }

  onAddEmailsButtonPressed() {
    Dialogs.showAddEmailsDialog(context, onAddEmailGoodTap);
  }

  onSaveButtonPressed() {
    saveWorkFile();
  }

  onSaveAsButtonPressed() {
    String fullName = (currentPerson.name.middleName == null) ? ('${currentPerson.name.firstName} ${currentPerson.name.lastName}') : ('${currentPerson.name.firstName} ${currentPerson.name.middleName} ${currentPerson.name.lastName}');
    FilesWriting.saveFile(file_type.single, widget.personList, fullName);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 8.0,
              spreadRadius: 2.0
            )
          ]
        ),
        child: Container(
          width: 500,
          //height: 500,
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: EdgeInsets.only(top: 0.0, right: 8.0, left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // dropdowns and close
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DropdownButt(
                          globalKey: 'fulls',
                          values: fullsDropdownValues, 
                          hintTitle: 'Выберите фулку',
                          onChanged: onFullDropdownButtChanged,
                          value: currentFullsDropdownValue,
                        ),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.red),
                          ),
                          onPressed: () => onDeleteButtonPressed(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            child:  Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Roboto',
                                fontSize: 14.0
                              ),
                            ),
                          )
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DropdownButt(
                          globalKey: 'usefull',
                          values: linksDropdownValues,
                          hintTitle: 'Ссылки',
                          onChanged: onLinksDropdownButtChanged,
                        ),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.purple),
                          ),
                          onPressed: () => Dialogs.showMemoDialog(context),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            child:  Text(
                              'Proxy Memo',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Roboto',
                                fontSize: 14.0
                              ),
                            )
                          )
                        )
                      ],
                    ),
                    CloseButton(
                      color: Colors.purple,
                      onPressed: () => widget.onCloseButtonPressed()
                    )
                  ],
                ),// dropdowns and close

                // Full name

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MTextField(
                      label: 'First Name',
                      title: currentPerson == null 
                      ? '' 
                      : currentPerson.name.firstName,
                      onLongPress: onTextFieldLongPress,
                    ),
                    MTextField(
                      label: 'Middle Name',
                      title: currentPerson == null 
                      ? '' 
                      : currentPerson.name.middleName == null ? '' : currentPerson.name.middleName,
                      onLongPress: onTextFieldLongPress,
                    ),
                    MTextField(
                      label: 'Last Name',
                      title: currentPerson == null 
                      ? '' 
                      : currentPerson.name.lastName,
                      onLongPress: onTextFieldLongPress,
                    ),
                  ],
                ),

                // Address
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MTextField(
                      label: 'Address',
                      title: currentPerson == null 
                      ? '' 
                      : currentPerson.address.address,
                      onLongPress: onTextFieldLongPress,
                    ),
                    MTextField(
                      label: 'City',
                      title: currentPerson == null 
                      ? '' 
                      : currentPerson.address.city,
                      onLongPress: onTextFieldLongPress,
                    ),
                    MTextField(
                      label: 'State',
                      title: currentPerson == null 
                      ? '' 
                      : currentPerson.address.state,
                      onLongPress: onTextFieldLongPress,
                    ),
                    MTextField(
                      label: 'Post Code',
                      title: currentPerson == null 
                      ? '' 
                      : currentPerson.address.postCode,
                      onLongPress: onTextFieldLongPress,
                    ),
                  ],
                ),

                // Other

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MTextField(
                      label: 'SSN',
                      title: currentPerson == null 
                      ? '' 
                      : currentPerson.ssn,
                      onLongPress: onTextFieldLongPress,
                    ),
                    MTextField(
                      label: 'Birth Date',
                      title: currentPerson == null 
                      ? '' 
                      : currentPerson.birthDate,
                      onLongPress: onTextFieldLongPress,
                    ),
                    MTextField(
                      label: 'Phone Number',
                      title: currentPerson == null 
                      ? '' 
                      : currentPerson.phoneNumber == null ? '' : currentPerson.phoneNumber,
                      onLongPress: onTextFieldLongPress,
                    ),
                  ],
                ),

                // Driver License 

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MTextField(
                      label: 'DL/ID',
                      title: currentPerson == null 
                      ? '' 
                      : currentPerson.driverLicense.number == null ? '' : currentPerson.driverLicense.number,
                      onLongPress: onTextFieldLongPress,
                    ),
                    MTextField(
                      label: 'Issuance Date',
                      title: currentPerson == null 
                      ? '' 
                      : currentPerson.driverLicense.issDate == null ? '' : currentPerson.driverLicense.issDate,
                      onLongPress: onTextFieldLongPress,
                    ),
                    MTextField(
                      label: 'Expiration Date',
                      title: currentPerson == null 
                      ? '' 
                      : currentPerson.driverLicense.expDate == null ? '' : currentPerson.driverLicense.expDate,
                      onLongPress: onTextFieldLongPress,
                    ),
                  ],
                ),

                // Job

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MTextField(
                      label: 'Company',
                      title: currentPerson == null 
                      ? '' 
                      : currentPerson.job.company == null ? '' : currentPerson.job.company,
                      onLongPress: onTextFieldLongPress,
                    ),
                    MTextField(
                      label: 'Job Title',
                      title: currentPerson == null 
                      ? '' 
                      : currentPerson.job.jobTitle == null ? '' : currentPerson.job.jobTitle,
                      onLongPress: onTextFieldLongPress,
                    ),
                  ],
                ),

                // Job Dates

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MTextField(
                      label: 'Start of Job',
                      title: currentPerson == null 
                      ? '' 
                      : currentPerson.job.startJob == null ? '' : currentPerson.job.startJob,
                      onLongPress: onTextFieldLongPress,
                    ),
                    MTextField(
                      label: 'End of Job',
                      title: currentPerson == null 
                      ? '' 
                      : currentPerson.job.endJob == null ? '' : currentPerson.job.endJob,
                      onLongPress: onTextFieldLongPress,
                    ),
                  ],
                ),

                // Emails Button

                 Row (
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    // Delete Emails

                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: RawMaterialButton(
                        fillColor: Colors.red,
                        child: Text(
                          'Delete Emails & Details',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontFamily: 'Roboto'
                          ),
                        ), 
                        onPressed: () => onDeleteEmailsButtonPressed(),
                      ),
                    ),

                    // Add Emails

                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: RawMaterialButton(
                        fillColor: Colors.purple,
                        child: Text(
                          'Add Emails & Details',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontFamily: 'Roboto'
                          ),
                        ), 
                        onPressed: () => onAddEmailsButtonPressed(),
                      ),
                    )

                  ],
                ),

                // Gmail

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MTextField(
                      label: 'Gmail Login',
                      title: currentPerson == null 
                      ? '' 
                      : currentPerson.emails == null ? '' : currentPerson.emails.gmail.login
                    ),
                    MTextField(
                      label: 'Gmail Pass',
                      title: currentPerson == null
                      ? '' 
                      : currentPerson.emails == null ? '' : currentPerson.emails.gmail.pass
                    ),
                  ],
                ),

                // Mailru

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MTextField(
                      label: 'Mailru Login',
                      title: currentPerson == null 
                      ? '' 
                      : currentPerson.emails == null ? '' : currentPerson.emails.mailru.login
                    ),
                    MTextField(
                      label: 'Mailru Pass',
                      title: currentPerson == null 
                      ? '' 
                      : currentPerson.emails == null ? '' : currentPerson.emails.mailru.pass
                    ),
                  ],
                ),

                // Login Details

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MTextField(
                      label: 'Login',
                      title: currentPerson == null 
                      ? '' 
                      : currentPerson.loginDetails == null ? '' : currentPerson.loginDetails.login
                    ),
                    MTextField(
                      label: 'Pass',
                      title: currentPerson == null 
                      ? '' 
                      : currentPerson.loginDetails == null ? '' : currentPerson.loginDetails.pass
                    ),
                  ],
                ),

                // Buttons

                Row (
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    // Save

                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: RawMaterialButton(
                        fillColor: Colors.purple,
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontFamily: 'Roboto'
                          ),
                        ), 
                        onPressed: () => onSaveButtonPressed(),
                      ),
                    ),

                    // Save As

                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: RawMaterialButton(
                        fillColor: Colors.purple,
                        child: Text(
                          'Save As',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontFamily: 'Roboto'
                          ),
                        ), 
                        onPressed: () => onSaveAsButtonPressed(),
                      ),
                    )

                  ],
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}


// class MainMenu extends StatefulWidget {
//   MainMenu({Key key, this.data, this.closeThis}) : super(key: key);

//   final List<Person> data;
//   final Function closeThis;

//   @override
//   _MainMenuState createState() => _MainMenuState();
// }

// class _MainMenuState extends State<MainMenu> {
//   List<Data> data;
//   List<String> names = [];
//   String currentValue;
//   Data currentData;

//   @override
//   void initState() {
//     super.initState();
//     data = widget.data;

//     int c = 1;
//     for (Data data in data) {
//       names.add('$c. ${data.firstName} ${data.middleName} ${data.lastName}');
//       c++;
//     }
//   }

//   Future<void> changeDialog(String text, data_types type) async {
//     var controller = TextEditingController();
//     controller.text = text;

//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Введите новую строку'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 TextFormField(
//                   controller: controller,
//                   autofocus: true,
//                 )
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text(
//                 'Отмена',
//                 style: TextStyle(
//                   fontFamily: 'Roboto',
//                   fontWeight: FontWeight.bold
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text(
//                 'Сохранить',
//                 style: TextStyle(
//                   fontFamily: 'Roboto',
//                   //fontWeight: FontWeight.bold
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 setState(() {
//                   switch (type) {
//                     case data_types.first: currentData.firstName = controller.text; break;
//                     case data_types.middle: currentData.middleName = controller.text; break;
//                     case data_types.last: currentData.lastName = controller.text; break;
//                     case data_types.address: currentData.address = controller.text; break;
//                     case data_types.city: currentData.city = controller.text; break;
//                     case data_types.state: currentData.state = controller.text; break;
//                     case data_types.post: currentData.postCode = controller.text; break;
//                     case data_types.ssn: currentData.ssn = controller.text; break;
//                     case data_types.birth: currentData.birthDate = controller.text; break;
//                     case data_types.phone: currentData.phoneNumber = controller.text; break;
//                     case data_types.dl: currentData.dl = controller.text; break;
//                     case data_types.iss: currentData.issDate = controller.text; break;
//                     case data_types.exp: currentData.expDate = controller.text; break;
//                     case data_types.company: currentData.company = controller.text; break;
//                     case data_types.job: currentData.jobTitle = controller.text; break;
//                     case data_types.sJob: currentData.startJob = controller.text; break;
//                     case data_types.eJob: currentData.endJob = controller.text; break;
//                     case data_types.gLogin: currentData.gmailLogin = controller.text; break;
//                     case data_types.gPass: currentData.gmailPass = controller.text; break;
//                     case data_types.mLogin: currentData.mailruLogin = controller.text; break;
//                     case data_types.mPass: currentData.mailruPass = controller.text; break;
//                     case data_types.pLogin: currentData.puaLogin = controller.text; break;
//                     case data_types.pPass: currentData.puaPass = controller.text; break;
//                     case data_types.bLogin: currentData.bankLogin = controller.text; break;
//                     case data_types.bPass: currentData.bankPass = controller.text; break;
//                   }
//                   currentValue = currentValue[0] + currentValue[1] + ' ${currentData.firstName} ${currentData.middleName} ${currentData.lastName}';
//                   data[currentData.index] = currentData; 
//                 });
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget dropdownButton() {
//     return DropdownButton<String>(
//       key: GlobalKey(debugLabel: 'Main Dropdown'),
//       style: TextStyle(
//         color: Colors.purple,
//         fontFamily: 'Roboto-Regular',
//         fontWeight: FontWeight.bold,
//         fontSize: 16
//       ),
//       underline: Container(width: 0.0, decoration: BoxDecoration(border: Border.all(color: Colors.purple)),),
//       hint: Text(
//         'Выберите фулку',
//         style: TextStyle(
//           color: Colors.purple.shade200,
//           fontFamily: 'Roboto-Regular',
//           fontWeight: FontWeight.bold,
//           fontSize: 16
//         )
//       ),
//       iconSize: 32.0,
//       iconEnabledColor: Colors.purple,
//       focusColor: Colors.purple.shade400,
//       value: currentValue,
//       items: names.map((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//       onChanged: (newValue) {
//         setState(() {
//           currentValue = newValue;
//           currentData = data[names.indexWhere((element) => element == currentValue)];
//         });
//       },
//     );
//   }

  

//   Widget textField(String label, String text) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             color: Colors.grey,
//             fontFamily: 'Roboto-Regular',
//             fontWeight: FontWeight.normal,
//             fontSize: 14.0,
//           ),
//         ),
//         Container(
//           constraints: BoxConstraints(
//             minHeight: 55.0,
//             minWidth: 200,
//             maxHeight: 55.0,
//             maxWidth: 200
//           ),
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: Colors.purple,
//               width: 2.0
//             ),
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           child: Center(
//             child: TextButton(
//               onLongPress: () {
//                 data_types type = getDataType(label);
//                 changeDialog(text, type);
//               },
//               onPressed: () {
//                 Clipboard.setData(ClipboardData(text: text));
//               },
//               child: Container(
//                 width: double.infinity,
//                 height: double.infinity,
//                 child: Center(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//                     child: Text(
//                       text,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: Colors.purple,
//                         fontSize: 20.0,
//                         fontFamily: 'Roboto-Regular',
//                       ),
//                     ),
//                   )
//                 )
//               )
//             ),
//           )
//         )
//       ],
//     );
//   }

//   String getFileContent(Data data) {
//     String result = '';

//     result = result + 'Full Name: ${data.firstName} ${data.middleName} ${data.lastName}\n';
//     result = result + 'Address: ${data.address}\n';
//     result = result + 'City: ${data.city}\n';
//     result = result + 'State: ${data.state}\n';
//     result = result + 'Post Code: ${data.postCode}\n';
//     result = result + 'SSN: ${data.ssn}\n';
//     result = result + 'Birth Date: ${data.birthDate}\n';
//     result = result + 'Phone Number: ${data.phoneNumber}\n';
//     result = result + 'DL/ID: ${data.dl}\n';
//     result = result + 'Issuance Date: ${data.issDate}\n';
//     result = result + 'Expiration Date: ${data.expDate}\n';
//     result = result + 'Company: ${data.company}\n';
//     result = result + 'Job Title: ${data.jobTitle}\n';
//     result = result + 'Start of Job: ${data.startJob}\n';
//     result = result + 'End of job: ${data.endJob}\n';
//     result = result + 'Gmail: ${data.gmailLogin}:${data.gmailPass}\n';
//     result = result + 'Mailru: ${data.mailruLogin}:${data.mailruPass}\n';
//     result = result + 'PUA: ${data.puaLogin}:${data.puaPass}\n';
//     result = result + 'Bank: ${data.bankLogin}:${data.bankPass}';

//     return result;
//   }

//   String getAllFileContent(List<Data> datas) {
//     String result = '';

//     String emails = '';

//     for (Data data in datas) {
//       result = result + data.firstName + ' ' + data.middleName + ' ' + data.lastName + ':' + data.address + ':' + data.city + ':' + data.state + ':' + data.postCode + ':' + data.ssn + ':' + data.birthDate + '\n';
//       result = result + 'DL/ID: ' + data.dl + '\n';
//       result = result + 'Issuane Date: ' + data.issDate + '\n';
//       result = result + 'Expiration Date: ' + data.expDate + '\n';
//       result = result + 'Phone Number: ' + data.phoneNumber + '\n';
//       result = result + 'Company: ${data.company}\n';
//       result = result + 'Job Title: ${data.jobTitle}\n';
//       result = result + 'Start of Job: ${data.startJob}\n';
//       result = result + 'End of job: ${data.endJob}\n';
//       data.index == datas.length ? result = result + '\n' : result = result + '------ \n';

//       emails = emails + data.gmailLogin + ':' + data.gmailPass + ':' + data.mailruLogin + ':' + data.mailruPass + ':\n';
//     }

//     result = result + '______\n';
//     result = result + emails;
//     return result;
//   }

//   Widget memoButtons(String memoWord) {

//     List<Widget> buttons = [];
//     var c = 1;
//     memoWord.characters.forEach((element) {
//       buttons.add(
//         Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Text(c.toString()),
//             OutlinedButton(
//               onPressed: () {
//                 Clipboard.setData(ClipboardData(text: element));
//               },
//               child: Text(element),
//             )
//           ],
//         )
//       );
//       c++;
//     });

//     return Center(
//       child: Row(
//         children: buttons
//       ),
//     );
//   }

//   Future<void> showMemo(String memo) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Memo'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 memoButtons(memo)
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text(
//                 'Отмена',
//                 style: TextStyle(
//                   fontFamily: 'Roboto',
//                   fontWeight: FontWeight.bold
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget mainContainer() {
//     var linksAndOther = ['8medkcLmo8', 'http://truthfinder.com', 'https://trust.dot.state.wi.us/ecdl/home.do', 'http://beenverified.com','https://my.unemployment.wisconsin.gov/Claimant/Logon/TermsAndConditions', ];

//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 0, horizontal: 28),
//       padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
//       constraints: BoxConstraints(
//         minHeight: double.infinity,
//         minWidth: double.infinity,
//         maxHeight: double.infinity,
//         maxWidth: double.infinity
//       ),
//       child: ListView(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   dropdownButton(),
//                   DropdownButton<String>(
//                     key: GlobalKey(debugLabel: 'Help Dropdown'),
//                     style: TextStyle(
//                       color: Colors.purple,
//                       fontFamily: 'Roboto-Regular',
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16
//                     ),
//                     underline: Container(width: 0.0, decoration: BoxDecoration(border: Border.all(color: Colors.purple)),),
//                     hint: Text(
//                       'Ссылки и данные',
//                       style: TextStyle(
//                         color: Colors.purple.shade200,
//                         fontFamily: 'Roboto-Regular',
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16
//                       )
//                     ),
//                     iconSize: 32.0,
//                     iconEnabledColor: Colors.purple,
//                     focusColor: Colors.purple.shade400,
//                     value: null,
//                     items: linksAndOther.map((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                     onChanged: (newValue) {
//                       if (newValue == '8medkcLmo8') {
//                         showMemo(newValue);
//                       }
//                       Clipboard.setData(ClipboardData(text: newValue));
//                     },
//                   )
//                 ],
//               ),
//               // Names
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   textField('First Name', currentData == null ? '' : currentData.firstName),
//                   textField('Middle Name', currentData == null ? '' : currentData.middleName),
//                   textField('Last Name', currentData == null ? '' : currentData.lastName),
//                 ],
//               ),
//               // Address
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   textField('Address', currentData == null ? '' : currentData.address),
//                   textField('City', currentData == null ? '' : currentData.city),
//                   textField('State', currentData == null ? '' : currentData.state),
//                   textField('Post Code', currentData == null ? '' : currentData.postCode),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   // Ssn
//                   textField('SSN', currentData == null ? '' : currentData.ssn),
//                   // Year
//                   textField('Birth Date', currentData == null ? '' : currentData.birthDate),
//                   // Phone Number
//                   textField('Phone Number', currentData == null ? '' : currentData.phoneNumber),
//                   // DL/ID
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   textField('DL/ID', currentData == null ? '' : currentData.dl),
//                   textField('Issuance Date', currentData == null ? '' : currentData.issDate),
//                   textField('Expiration Date', currentData == null ? '' : currentData.expDate),
//                 ],
//               ),
//               // Work
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   textField('Company', currentData == null ? '' : currentData.company),
//                   textField('Job Title', currentData == null ? '' : currentData.jobTitle),
//                 ],
//               ),
//               // Dates
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   textField('Start of Job', currentData == null ? '' : currentData.startJob),
//                   textField('End of Job', currentData == null ? '' : currentData.endJob),
//                 ],
//               ),
//               // Gmails
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   textField('Gmail Login', currentData == null ? '' : currentData.gmailLogin),
//                   textField('Gmail Pass', currentData == null ? '' : currentData.gmailPass),
//                 ],
//               ),
//               // Mails
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   textField('Mail.ru Login', currentData == null ? '' : currentData.mailruLogin),
//                   textField('Mail.ru Pass', currentData == null ? '' : currentData.mailruPass),
//                 ],
//               ),
//               // PUA DATA
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   textField('PUA Login', currentData == null ? '' : currentData.puaLogin),
//                   textField('PUA Pass', currentData == null ? '' : currentData.puaPass),
//                 ],
//               ),
//               // Bank Data
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   textField('Bank Login', currentData == null ? '' : currentData.bankLogin),
//                   textField('Bank Pass', currentData == null ? '' : currentData.bankPass),
//                 ],
//               ),
//               // Save and Exit Button
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
                
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(right: 8.0),
//                     child: RawMaterialButton(
//                       fillColor: Colors.red,
//                       onPressed: (){
//                         setState(() {
//                           if (currentValue != null) {
//                             data.removeAt(currentData.index);
//                             currentValue = null;
//                             currentData = null;

//                             var c = 1;
//                             names = [];
//                             for (Data data in data) {
//                               data.index = c-1;
//                               names.add('$c. ${data.firstName} ${data.middleName} ${data.lastName}');
//                               c++;
//                             }
//                           }
//                         });
//                       },
//                       child: Text(
//                         'Delete This',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18.0,
//                           fontFamily: 'Roboto',
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(right: 8.0, left: 8.0),
//                     child: RawMaterialButton(
//                       fillColor: Colors.red,
//                       onPressed: (){
//                         widget.closeFunc();
//                       },
//                       child: Text(
//                         'Close',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18.0,
//                           fontFamily: 'Roboto',
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(left: 8.0, right: 8),
//                     child: RawMaterialButton(
//                       fillColor: Colors.purple,
//                       onPressed: (){
//                         String fileContent = getAllFileContent(data);
//                           var file = SaveFilePicker()
//                             ..fileName = 'work_data.txt'
//                             ..title = 'Сохранить файл'
//                             ..defaultExtension = 'txt'
//                             ..fileMustExist = true;

//                           var result = file.getFile();
//                           File(result.path).writeAsStringSync(fileContent);
//                       },
//                       child: Text(
//                         'Save All',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18.0,
//                           fontFamily: 'Roboto',
//                         ),
//                       ),
//                     )
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(left: 8.0),
//                     child: RawMaterialButton(
//                       fillColor: Colors.purple,
//                       onPressed: (){
//                         if (currentValue != null) {
//                           String fileContent = getFileContent(currentData);
//                           var file = SaveFilePicker()
//                             ..fileName = currentValue+'.txt'
//                             ..title = 'Сохранить файл'
//                             ..defaultExtension = 'txt'
//                             ..fileMustExist = true;

//                           var result = file.getFile();
//                           File(result.path).writeAsStringSync(fileContent);
//                         }
//                       },
//                       child: Text(
//                         'Save File',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18.0,
//                           fontFamily: 'Roboto',
//                         ),
//                       ),
//                     )
//                   )
//                 ],
//               )
//             ],
//           ),
//         ],
//       )
//     );

    
//   }

//   @override
//   Widget build(BuildContext context) {
//     return mainContainer();
//   }
// }