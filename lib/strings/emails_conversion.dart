import 'package:pua_copy_application/support/templates.dart';

class EmailsConversion {

  static Map<String, String> createLoginDetails(Map<String, String> gmail) {
    var result = gmail;

    var index = result.values.elementAt(0).indexOf('@');
    result[result.keys.elementAt(0)] = result.values.elementAt(0).substring(0, index);

    return result;
  }

  static Map<String, Map<String, String>> _prepareEmails(String emails) {
    var result = Templates.emailTemplate;

    var start = 0;
    var end = emails.indexOf(':');

    result.keys.forEach((emailKey) {
      result[emailKey].keys.forEach((detailsKey) {
        var value = emails.substring(start, end);
        start = end+1;
        end = emails.indexOf(':', start);
                  
        result[emailKey][detailsKey] = value;
      });
    });

    return result;
  }

  static Map<String, Map<String, String>> getEmails(String emails) {
    return _prepareEmails(emails);
  }
}