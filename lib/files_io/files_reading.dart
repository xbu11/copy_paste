import 'dart:io';

import 'package:filepicker_windows/filepicker_windows.dart';

class FilesReading {
  static File pickFile() {
    final openFilePicker = OpenFilePicker()
          ..filterSpecification = {
            'Text Document (*.txt)': '*.txt'
          }
          ..defaultFilterIndex = 0
          ..defaultExtension = 'txt'
          ..title = 'Select a file';
    
    return openFilePicker.getFile();
  }

  static Future<String> readFile(String filePath) async {
    File file = File(filePath);
    try {
      String content = await file.readAsString();

      return content.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
    } catch (e) {
      print('File reading error!');
      return 'File reading error!';
    }
  }
}