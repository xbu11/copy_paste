import 'package:pua_copy_application/support/templates.dart';

class Emails {
  Emails({
    this.gmail,
    this.mailru
  });

  _Gmail gmail;
  _Mailru mailru;


  static Map<String, String> _prepareEmailsFromFull(String logPass) {
    var result = <String, String>{};
    result['Login'] = logPass.substring(0, logPass.indexOf(':'));
    result['Pass'] = logPass.substring(logPass.indexOf(':')+1, logPass.length);

    return result;
  }

  static Emails createEmailsFromFull(Map<String, String> emails) {
    return Emails(
      gmail: _Gmail.createGmail(_prepareEmailsFromFull(emails['Gmail'])),
      mailru: _Mailru.createMailru(_prepareEmailsFromFull(emails['Mailru']))
     );
  }

  static Emails createEmails(Map<String, Map<String, String>> emails) {
    Emails result = Emails();

    emails.forEach((key, value) {
      switch (key) {
        case 'Gmail': result.gmail = _Gmail.createGmail(value); break;
        case 'Mailru': result.mailru = _Mailru.createMailru(value); break;
      }
    });

    return result;
  }
}

class _Gmail {
  String login;
  String pass;

  static _Gmail createGmail(Map<String, String> gmail) {
    _Gmail result = _Gmail();

    gmail.forEach((key, value) {
      switch (key) {
        case 'Login': result.login = value; break;
        case 'Pass': result.pass = value; break; 
      }
    });

    return result;
  }
}

class _Mailru {
  String login;
  String pass;

  static _Mailru createMailru(Map<String, String> mailru) {
    _Mailru result = _Mailru();

    mailru.forEach((key, value) {
      switch (key) {
        case 'Login': result.login = value; break;
        case 'Pass': result.pass = value; break; 
      }
    });

    return result;
  }
}