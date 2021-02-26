class Templates {
  static Map<String, String> onePersonTemplate = {
    'Full Name': null,
    'Address': null,
    'City': null,
    'State': null,
    'Post Code': null,
    'SSN': null,
    'Birth Date': null,
    'Phone Number': null,
    'DL/ID': null,
    'Issuance Date': null,
    'Expiration Date': null,
    'Company': null,
    'Job Title': null,
    'Start of Job': null,
    'End of job': null,
    'Gmail': null,
    'Mailru': null,
    'Login Details': null,
  };

  static Map<String, Map<String, String>> emailTemplate = {
    'Gmail': {
      'Login': null,
      'Pass': null,
    },
    'Mailru': {
      'Login': null,
      'Pass': null,
    },
  };

  static Map<String, String> fullNameTemplate = {
    'First Name': null,
    'Middle Name': null,
    'Last Name': null,
  };

  static Map<String, String> addressTemplate () {
    var result = <String, String>{};

    for (var i = 1; i < 5; i++) {
      result[onePersonTemplate.keys.elementAt(i)] = null;
    }

    return result;
  }

  static Map<String, String> driverLicenseTemplate () {
    var result = <String, String>{};

    for (var i = 8; i < 11; i++) {
      result[onePersonTemplate.keys.elementAt(i)] = null;
    }

    return result;
  }

  static Map<String, String> jobTemplate () {
    var result = <String, String>{};

    for (var i = 11; i < 15; i++) {
      result[onePersonTemplate.keys.elementAt(i)] = null;
    }

    return result;
  }
}