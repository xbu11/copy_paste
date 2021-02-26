import 'package:pua_copy_application/objects/emails.dart';
import 'package:pua_copy_application/strings/emails_conversion.dart';
import 'package:pua_copy_application/support/enums.dart';
import 'package:pua_copy_application/support/templates.dart';
import 'package:pua_copy_application/support/validators.dart';

class Person {
  Person({
    this.number,
    this.name,
    this.address,
    this.ssn,
    this.birthDate,
    this.phoneNumber,
    this.driverLicense,
    this.job,
    this.emails,
    this.loginDetails
  });

  int number;
  _Name name;
  _Address address;
  String ssn;
  String birthDate;
  String phoneNumber;
  _DriverLicense driverLicense;
  _Job job;
  Emails emails;
  _LoginDetails loginDetails;

  static _LoginDetails _getDetails(Emails emails) {
    var details = EmailsConversion.createLoginDetails(<String, String>{'Login': emails.gmail.login, 'Pass': emails.gmail.pass});
    return _LoginDetails(login: details['Login'], pass: details['Pass']); 
  }

  addEmails(Map<String, Map<String, String>> email) {
    this.emails = Emails.createEmails(email);
    this.loginDetails = _getDetails(emails);
  }

  static List<Person> createPersons(Map<int, Map<String, String>> full, Map<String, Map<String, String>> email) {
    var result = <Person>[];
    full.forEach((key, value) {
      var number = key;
      var name = _Name.createName(full[key].values.elementAt(0));
      var address = _Address.createAddress(full[key]);
      var ssn = full[key].values.elementAt(5);
      var birthDate = full[key].values.elementAt(6);
      var phoneNumber = full[key].values.elementAt(7);
      var driverLicense = _DriverLicense.createDriverLicense(full[key]);
      var job = _Job.createJob(full[key]);
      var emails;
      var loginDetails;

      value.forEach((personKey, personValue) {
        
      });
      if (value['Gmail'] == null) {
        if (email == null) {
          emails = null;
          loginDetails = null;
        } else {
          emails = Emails.createEmails(email);
          loginDetails = _getDetails(emails);
        }
      } else {
        var entri = <String, String>{};
        entri.addEntries(full[key].entries.where((element) => element.key == 'Gmail' || element.key == 'Mailru'));
        emails = Emails.createEmailsFromFull(entri);
        loginDetails =  _LoginDetails.createLoginDetails(full[key].values.elementAt(value.length-1));
      }

      result.add(
        Person(
          number: number,
          name: name,
          address: address,
          ssn: ssn,
          birthDate: birthDate,
          phoneNumber: phoneNumber,
          driverLicense: driverLicense,
          job: job,
          emails: emails,
          loginDetails: loginDetails
        )
      );
    });
    
    return result;
  }
}

class _Name {
  _Name({
    this.firstName,
    this.middleName,
    this.lastName
  });

  String firstName;
  String middleName;
  String lastName;

  static Map<String, String> _prepareNames(String fullName) {
    var result = Templates.fullNameTemplate;
    var _fullName = fullName.replaceAll(':', ' ');
    var condition = _fullName.indexOf(' ') != _fullName.lastIndexOf(' ');

    var start = 0;
    var end = _fullName.indexOf(' ');
    result.keys.forEach((key) {
      if (condition ? (true) : (key != result.keys.elementAt(1))) {
        result[key] = _fullName.substring(start, end != -1 ? end : _fullName.length);
        start = end+1;
        end = _fullName.indexOf(' ', start);
      } else result[key] = null;
    });

    return result;
  }

  static _Name createName(String fullName) {
    _Name result = _Name();
    
    var names = _prepareNames(fullName);
    names.forEach((key, value) {
      var type = PersonDataTypeValidator.getDataType(key);
      switch (type) {
        case person_data_types.first: result.firstName = value; break;
        case person_data_types.middle: result.middleName = value; break;
        case person_data_types.last: result.lastName = value; break;
        default: break;
      }
    });

    return result;
  }
}

class _Address {
  _Address({
    this.address,
    this.city,
    this.state,
    this.postCode
  });

  String address;
  String city;
  String state;
  String postCode;

  static _Address createAddress(Map<String, String> address) {
    _Address result = _Address();

    address.forEach((key, value) {
      var type = PersonDataTypeValidator.getDataType(key);
      switch (type) {
        case person_data_types.address: result.address = value; break;
        case person_data_types.city: result.city = value; break;
        case person_data_types.state: result.state = value; break;
        case person_data_types.post: result.postCode = value; break;
        default: break;
      }
    });

    return result;
  }
}

class _DriverLicense {
  _DriverLicense({
    this.number,
    this.issDate,
    this.expDate
  });

  String number;
  String issDate;
  String expDate;

  static _DriverLicense createDriverLicense(Map<String, String> driverLicense) {
    _DriverLicense result = _DriverLicense();

    driverLicense.forEach((key, value) {
      var type = PersonDataTypeValidator.getDataType(key);
      switch (type) {
        case person_data_types.dl: result.number = value; break;
        case person_data_types.iss: result.issDate = value; break;
        case person_data_types.exp: result.expDate = value; break;
        default: break;
      }
    });

    return result;
  }
}

class _Job {
  _Job({
    this.company,
    this.jobTitle,
    this.startJob,
    this.endJob
  });

  String company;
  String jobTitle;

  String startJob;
  String endJob;

  static _Job createJob(Map<String, String> job) {
    _Job result = _Job();

    job.forEach((key, value) {
      var type = PersonDataTypeValidator.getDataType(key);
      switch (type) {
        case person_data_types.company: result.company = value; break;
        case person_data_types.job: result.jobTitle = value; break;
        case person_data_types.sJob: result.startJob = value; break;
        case person_data_types.eJob: result.endJob = value; break;
        default: break;
      }
    });

    return result;
  }
}

class _LoginDetails {
  _LoginDetails({
    this.login,
    this.pass
  });

  String login;
  String pass;

  static Map<String, String> _prepareLoginDetails(String loginDetails) {
    var result = <String, String>{
      'Login': null,
      'Pass': null,
    };

    var start = 0;
    var end = loginDetails.indexOf(':');
    result.keys.forEach((key) {
      result[key] = loginDetails.substring(start, end);
      start = end+1;
      end = loginDetails.length;
    });


    return result;
  }

  static _LoginDetails createLoginDetails(String loginDetails) {
    _LoginDetails result = _LoginDetails();
    print(loginDetails);
    _prepareLoginDetails(loginDetails).forEach((key, value) {
      var type = PersonDataTypeValidator.getDataType(key);
      switch (type) {
        case person_data_types.login: result.login = value; break;
        case person_data_types.pass: result.pass = value; break;
        default: break;
      }
    });

    return result;
  }
}



