import 'enums.dart';

class PersonDataTypeValidator {
 static person_data_types getDataType(String string) {
    person_data_types result;

    switch (string) {
      case 'First Name': result = person_data_types.first; break;
      case 'Middle Name': result = person_data_types.middle; break;
      case 'Last Name': result = person_data_types.last; break;
      case 'Address': result = person_data_types.address; break;
      case 'City': result = person_data_types.city; break;
      case 'State': result = person_data_types.state; break;
      case 'Post Code': result = person_data_types.post; break;
      case 'SSN': result = person_data_types.ssn; break;
      case 'Birth Date': result = person_data_types.birth; break;
      case 'Phone Number': result = person_data_types.phone; break;
      case 'DL/ID': result = person_data_types.dl; break;
      case 'Issuance Date': result = person_data_types.iss; break;
      case 'Expiration Date': result = person_data_types.exp; break;
      case 'Company': result = person_data_types.company; break;
      case 'Job Title': result = person_data_types.job; break;
      case 'Start of Job': result = person_data_types.sJob; break;
      case 'End of Job': result = person_data_types.eJob; break;
      case 'Gmail Login': result = person_data_types.gLogin; break;
      case 'Gmail Pass': result = person_data_types.gPass; break;
      case 'Mailru Login': result = person_data_types.mLogin; break;
      case 'Mailru Pass': result = person_data_types.mPass; break;
      case 'Login': result = person_data_types.login; break;
      case 'Pass': result = person_data_types.pass; break;
    }

    return result;
  }
}

class EmailTypeValidator {
  static email_type getEmailType(String string) {
    email_type result;

    switch (string) {
      case 'Gmail': result = email_type.gmail; break;
      case 'Mailru': result = email_type.mailru; break;
    }

    return result;
  }
}