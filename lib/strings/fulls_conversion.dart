import 'package:pua_copy_application/support/enums.dart';
import 'package:pua_copy_application/support/templates.dart';

class FullsConversion {

  static Map<String, String> _prepareSingle(String content) {
    print('Content: ' + content);
    var result = Templates.onePersonTemplate;
    var end = content.indexOf('\n');
    result.keys.forEach((key) {
      var start = content.indexOf('$key: ') + '$key: '.length;
      var value = content.substring(start,  end != -1 ? end : content.length-1);
      result[key] = value == 'NULL' ? null : value;
      end = content.indexOf('\n', end+1);
    });

    return result;
  }

  static List<String> _getLines(String content) {
    var result = <String>[];

    var start = 0;
    var end = content.indexOf('\n');
    do {
      var line = content.substring(start, end);
      result.add(line);
      start = end+1;
      if (start != content.length + 1) {
        end = content.indexOf('\n', start) == -1 ? content.length : content.indexOf('\n', start);
      }
    } while(start != content.length+1);

    return result;
  }

  static Map<int, Map<String, String>> _prepareSource(String content) {
    var result = <int, Map<String, String>>{};
    var lines = _getLines(content);

    var birthDateIndex = Templates.onePersonTemplate.keys.toList().indexWhere((key) => key == 'Birth Date');
    var keyIndex = birthDateIndex;

    var fullIndex = 0;
  
    lines.forEach((line) { 
      var full = Templates.onePersonTemplate;
      var start = line.lastIndexOf(':');
      var end = line.length;

      do {
        full[full.keys.elementAt(keyIndex)] = line.substring(keyIndex == 0 ? start : start+1, end);
        if (keyIndex == 0) break;
        end = start;
        start = keyIndex != 1 ? line.lastIndexOf(':', end-1) : 0;
        keyIndex--;
      } while(keyIndex != -1);

      keyIndex = birthDateIndex;
      result[fullIndex] = <String, String>{};
      result[fullIndex].addAll(full);
      fullIndex++;
    });

    return result; 
  }

  static Map<int, Map<String, String>> _prepareMulti(String content) {
    var result = <int, Map<String, String>>{};

    var len = '------\n'.length;
    var fullIndex = 0;
    var start = 0;
    var end = content.indexOf('------\n');
    do {
      var single = content.substring(start, end);
      print(single);
      start = content.indexOf('------\n', end-1) + '------\n'.length;
      //start = start == -1+'------\n'.length ? end + '------\n'.length : start;
      end = content.indexOf('------\n', start);
      //end = end == -1 ? content.length : end;
      result[fullIndex] = <String, String>{};
      result[fullIndex].addAll(_prepareSingle(single));
      fullIndex++;
    } while(end != -1);

    print(result[fullIndex]);

    return result;
  }


  static Map<int, Map<String, String>> getFulls(String fileContent, file_type type) {
    var result = <int, Map<String, String>>{};

    switch (type) {
      case file_type.single: 
        result[0] = _prepareSingle(fileContent);
        break;
      case file_type.source:
        result = _prepareSource(fileContent);
        break;
      case file_type.multi:
        result = _prepareMulti(fileContent);
        break;
    }

    return result;
  }
}