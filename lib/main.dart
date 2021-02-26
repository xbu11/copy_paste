import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pua_copy_application/files_io/files_reading.dart';
import 'package:pua_copy_application/files_io/files_writing.dart';
import 'package:pua_copy_application/strings/fulls_conversion.dart';
import 'package:pua_copy_application/support/enums.dart';
import 'package:pua_copy_application/widgets/main_menu.dart';

import 'objects/person.dart';
import 'widgets/buttons.dart';
import 'widgets/indicator.dart';

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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Person> personList;
  File workFile;
  file_type workFileType;

  bool showIndicator;
  bool fileIsDownloaded;
  bool sourceSwitchButtonValue;
  bool multiSwitchButtonValue;
  bool singleSwitchButtonValue;

  file_type fileType;

  @override
  initState() {
    super.initState();

    showIndicator = false;
    fileIsDownloaded = false;
    fileType = file_type.source;
    sourceSwitchButtonValue = true;
    multiSwitchButtonValue = false;
    singleSwitchButtonValue = false;
  }

  fileNotDownloaded() {
    setState(() {
      showIndicator = false;
    });
  }

  fileDownloading() {
    setState(() {
      showIndicator = true;
    });
  }

  fileDownloaded(List<Person> personList, File workFile, file_type workFileType) {
    setState(() {
      if(fileType == file_type.source) {
        FilesWriting.saveWorkFile(workFile, fileType, personList, null);
        workFile = File(workFile.path.substring(0, workFile.path.lastIndexOf('\\')+1) + 'WORK.txt');
        workFileType = file_type.multi;
      }
      this.personList = personList;
      this.workFile = workFile;
      this.workFileType = workFileType;
      fileIsDownloaded = true;
    });
  }

  closeMenu() {
    setState(() {
      fileIsDownloaded = false;
      showIndicator = false;
    });
  }

  mainButtonOnPressed() {
    var pickedFile = FilesReading.pickFile();

    fileDownloading();

    if(pickedFile != null) {
      var conversionedFileContent; 
      var personList;
      FilesReading.readFile(pickedFile.path)
        .then((fileContent) {
          conversionedFileContent = FullsConversion.getFulls(fileContent, fileType);
          personList = Person.createPersons(conversionedFileContent, null);
        })
        .whenComplete(() {
          
          fileDownloaded(personList, pickedFile, fileType);
        });
    } else {
      fileNotDownloaded();
    }
  }

  switchButtonOnPressed(switch_button_type type, bool state) {
    if (!state) {
      setState(() {
        switch (type) {
          case switch_button_type.source:
            sourceSwitchButtonValue = true;
            multiSwitchButtonValue = false;
            singleSwitchButtonValue = false;
            fileType = file_type.source;
          break;
          case switch_button_type.multi:
            sourceSwitchButtonValue = false;
            multiSwitchButtonValue = true;
            singleSwitchButtonValue = false;
            fileType = file_type.multi;
          break;
          case switch_button_type.single:
            sourceSwitchButtonValue = false;
            multiSwitchButtonValue = false;
            singleSwitchButtonValue = true;
            fileType = file_type.single;
        }
      });
    }
  }

  onCloseButtonPressed() {
    setState(() {
      fileIsDownloaded = false;
      showIndicator = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Color(0xFFa7a6ba),
      body: fileIsDownloaded
      ? MainMenu(
        personList: personList,
        onCloseButtonPressed: onCloseButtonPressed,
        workFile: workFile,
        workFileType: fileType,
      )
      : Center(
        child: showIndicator 
        ? Indicator()
        : Container(
          constraints: BoxConstraints(
            minHeight: 284,
            minWidth: 512,
            maxHeight: 284,
            maxWidth: 512
          ),
          padding: EdgeInsets.symmetric(horizontal: 128),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 8.0,
                spreadRadius: 2.0
              )
            ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              MainButton(
                onPressed: mainButtonOnPressed,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SwitchButton(
                    title: 'Source',
                    switchButtonType: switch_button_type.source,
                    value: sourceSwitchButtonValue, 
                    backgroundColor: sourceSwitchButtonValue ? Colors.purple : Colors.white, 
                    onPressed: switchButtonOnPressed,
                  ),
                  SwitchButton(
                    title: 'Multi',
                    switchButtonType: switch_button_type.multi,
                    value: multiSwitchButtonValue,
                    backgroundColor:  multiSwitchButtonValue ? Colors.purple : Colors.white,
                    onPressed: switchButtonOnPressed,
                  ),
                  SwitchButton(
                    title: 'Single',
                    switchButtonType: switch_button_type.single,
                    value: singleSwitchButtonValue,
                    backgroundColor:  singleSwitchButtonValue ? Colors.purple : Colors.white,
                    onPressed: switchButtonOnPressed,
                  )
                ],
              )
            ]
        ),
      
        //switch(права)
        //switch(nomer)
        //switch(emails)
        ) 
      ),
    );
  }
}
