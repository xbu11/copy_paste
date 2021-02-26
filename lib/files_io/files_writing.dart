import 'dart:io';

import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:pua_copy_application/objects/person.dart';
import 'package:pua_copy_application/support/enums.dart';
import 'package:pua_copy_application/support/templates.dart';
import 'package:pua_copy_application/support/validators.dart';

class FilesWriting {

  static File _pickFile(file_type fileType, String fullName) {
    final saveFilePicker = SaveFilePicker()
      ..defaultExtension = 'txt'
      ..title = 'Сохраните файл';
    
    switch (fileType) {
      case file_type.single:
        saveFilePicker.fileName = '$fullName.txt';
        break;
      case file_type.source:break;
      case file_type.multi:
        saveFilePicker.fileName = 'work_data.txt';
        break;
    }

    return saveFilePicker.getFile();
  }

  static String _prepareFileContent(List<Person> personList) {
    var result = '';

    for (var person in personList) {
      var personTemplate = Templates.onePersonTemplate;
      personTemplate['Full Name'] = (person.name.middleName == null) ? ('${person.name.firstName} ${person.name.lastName}') : ('${person.name.firstName} ${person.name.middleName} ${person.name.lastName}');
      personTemplate['Address'] = person.address == null ? 'NULL' : '${person.address.address}';
      personTemplate['City'] = person.address == null ? 'NULL' : '${person.address.city}';
      personTemplate['State'] = person.address == null ? 'NULL' : '${person.address.state}';
      personTemplate['Post Code'] = person.address == null ? 'NULL' : '${person.address.postCode}';
      personTemplate['SSN'] = person.ssn == null ? 'NULL' : '${person.ssn}';
      personTemplate['Birth Date'] = person.birthDate == null ? 'NULL' : '${person.birthDate}';
      personTemplate['Phone Number'] = person.phoneNumber == null ? 'NULL' : '${person.phoneNumber}';
      personTemplate['DL/ID'] = person.driverLicense.number == null ? 'NULL' : '${person.driverLicense.number}';
      personTemplate['Issuance Date'] = person.driverLicense.issDate == null ? 'NULL' : '${person.driverLicense.issDate}';
      personTemplate['Expiration Date'] = person.driverLicense.expDate == null ? 'NULL' : '${person.driverLicense.expDate}';
      personTemplate['Company'] = person.job.company == null ? 'NULL' : '${person.job.company}';
      personTemplate['Job Title'] = person.job.jobTitle == null ? 'NULL' : '${person.job.jobTitle}';
      personTemplate['Start of Job'] = person.job.startJob == null ? 'NULL' : '${person.job.startJob}';
      personTemplate['End of job'] = person.job.endJob == null ? 'NULL' : '${person.job.endJob}';
      personTemplate['Gmail'] = person.emails == null ? 'NULL' : '${person.emails.gmail.login}:${person.emails.gmail.pass}';
      personTemplate['Mailru'] = person.emails == null ? 'NULL' : '${person.emails.mailru.login}:${person.emails.mailru.pass}';
      personTemplate['Login Details'] = person.loginDetails == null ? 'NULL' : '${person.loginDetails.login}:${person.loginDetails.pass}';
      
      personTemplate.forEach((key, value) {
        result = result + '$key: $value\n';
      });

      result = result + '------\n';
      
    }

    return result;
  }

  static saveFile(file_type fileType, List<Person> personList, String fullName) {
    var file = _pickFile(fileType, fullName);
    var filePath = file == null ? null : file.path;

    if (filePath != null) {
      File file = File(filePath);

      try {
        var fileContent;
        if (fullName == null) {
          fileContent = _prepareFileContent(personList);
        } else {
          var per = personList.firstWhere((pers) {
            var persFullName = (pers.name.middleName == null) ? ('${pers.name.firstName} ${pers.name.lastName}') : ('${pers.name.firstName} ${pers.name.middleName} ${pers.name.lastName}');
            if (fullName == persFullName) {
              return true;
            } else {
              return false;
            }
          });
          var forPrepare = <Person>[per];
          fileContent = _prepareFileContent(forPrepare);
        }
        file.writeAsString(fileContent);
      } catch(e) {}
    }
  }

  static saveWorkFile(File file, file_type fileType, List<Person> personList, String fullName) async {
    var filePath = file.path;

    try {
      var fileContent;
      if (fileType == file_type.multi) {
        fileContent = _prepareFileContent(personList);
      } else if (fileType == file_type.single){
        var per = personList.firstWhere((pers) {
          var persFullName = (pers.name.middleName == null) ? ('${pers.name.firstName} ${pers.name.lastName}') : ('${pers.name.firstName} ${pers.name.middleName} ${pers.name.lastName}');
          if (fullName == persFullName) {
            return true;
          } else {
            return false;
          }
        });
        var forPrepare = <Person>[per];
        fileContent = _prepareFileContent(forPrepare);
      } else if (fileType == file_type.source) {
        fileContent = _prepareFileContent(personList);
      }

      if (fileType == file_type.source) {
        file = File(filePath.substring(0, filePath.lastIndexOf('\\')+1,) + 'WORK.txt');
      }

      file.writeAsString(fileContent);
    } catch(e) {}
  }
}