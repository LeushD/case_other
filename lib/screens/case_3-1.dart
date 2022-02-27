import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

final List<String> _timeName = ['Утро', 'День', 'Вечер', 'Ночь'];
final Map<int,String> _timeMap = {0:'Доброе утро', 1:'Добрый день', 2:'Добрый вечер', 3:'Доброй ночи'};

class DataStorage {
  Future<String> get _localPath async{
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    return File('$path/data.txt');
  }

  Future<String> readData() async {
    try {
      final file = await _localFile;

      //Read the file
      final contents = await file.readAsString();

      return contents;
    } catch(e) {
      //If encountering an error? return 0
      return 'Дмитрий';
    }
  }

  Future<File> writeData(String data) async {
    final file = await _localFile;

    //Write the file
    return file.writeAsString('$data');
  }
}

class SharedPrefScreen extends StatelessWidget {
  const SharedPrefScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shared preferences & Path provider',
      home: MyHomePage(storage: DataStorage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.storage}) : super(key: key);

  final DataStorage storage;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _timeIndex = 0;
  String _userName = 'User';
  TextEditingController textController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    _loadData();
    widget.storage.readData().then((String value) {
      setState(() {
        _userName = value;
        textController.text = value;
      });
    });
    //textController.text=_userName;
  }

  Future<File> _changeName(String val) {
    setState(() {
      _userName = val;
    });

    // Write the variable as a string ti th file.
    //  print('userName changed to $_userName');
    return widget.storage.writeData(_userName);
  }

  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _timeIndex = (prefs.getInt('timeIndex') ?? 0);
      //    print('timeIndex loaded = $_timeIndex');
    });
  }

  void _changeData(int? value) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _timeIndex = value!;
      prefs.setInt('timeIndex', _timeIndex);
      //    print('timeIndex changed to $_timeIndex');
    });
  }

  // void _onTimeChanged(int? value) {
  //   setState(() {
  //     _timeIndex = value!;
  //   });
  // }
  //
  // void _onNameChanged(String? value) {
  //   setState(() {
  //     _userName = value!;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shared preferences & Path provider'), centerTitle: true,),
      body: SingleChildScrollView(
        child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text('${_timeMap.values.elementAt(_timeIndex)}, $_userName!',
                  style: GoogleFonts.pushster(fontSize: 26),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text('Ваше имя:', style: Theme.of(context).textTheme.headline6,),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  textAlign: TextAlign.center,
                  onChanged: (val) {_changeName(val);},
                  controller: textController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text('Время суток:', style: Theme.of(context).textTheme.headline6,),
              ),
              RadioListTile(
                  title: Text(_timeName[0]),
                  value: 0,
                  groupValue: _timeIndex,
                  onChanged: _changeData
              ),
              RadioListTile(
                title: Text(_timeName[1]),
                value: 1,
                groupValue: _timeIndex,
                onChanged: _changeData,
              ),
              RadioListTile(
                title: Text(_timeName[2]),
                value: 2,
                groupValue: _timeIndex,
                onChanged: _changeData,
              ),
              RadioListTile(
                title: Text(_timeName[3]),
                value: 3,
                groupValue: _timeIndex,
                onChanged: _changeData,
              ),
            ]
        ),
      ),

    );
  }
}