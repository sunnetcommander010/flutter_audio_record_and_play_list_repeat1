import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:path_provider/path_provider.dart';
import 'list.dart';
import 'view.dart';
import 'package:flutter/services.dart';
import 'package:google_speech/google_speech.dart';

class HomePage extends StatefulWidget {
  final String _appTitle;


  const HomePage({Key? key, required String title})
      : assert(title != null),
        _appTitle = title,
        super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // recognizing google speech service
  bool recognizing = false;
  bool recognizeFinished = false;
  String text = '';

  String dropdownvalue = 'All';
  var items =  ['All','Iron 8','Iron 9','Iron Wedge','Iron 10','Iron 1','golf wedge'];
  late Directory? appDir;
  late List<String>? records;
  static late List<String>? globalrecords;
  String searchval = '';

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    records = [];
    getExternalStorageDirectory().then((value) {
      appDir = value!;
      Directory appDirec = Directory("${appDir!.path}/Audiorecords/");
      print(Directory('path'));
      appDir = appDirec;

      appDir!.list().listen((onData) {
        print('onData');
        print(onData);
        records!.add(onData.path);
      }).onDone(() {
        records = records!.reversed.toList();
        setState(() {
          this.records = records;
          globalrecords = records;
        });
      });
    });
  }

  void search(String category, String searchStr) {
    if (category == 'All') {
      category = '';
    }
    print(category);
    print(searchStr);
    records = globalrecords;
    for(int i = 0; i < globalrecords!.length; i++ ) {
      print('searchStr');
      print(globalrecords!.elementAt(i).indexOf(searchStr));
      print(globalrecords!.elementAt(i).indexOf(category));
      if (globalrecords!.elementAt(i).indexOf(searchStr) == -1 || globalrecords!.elementAt(i).indexOf(category) == -1){
        records!.remove(globalrecords!.elementAt(i));
      }
    }
  }

  // @override
  // void dispose() {
  //   appDir = null;
  //   records = null;
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child:  InkWell(child: Icon(Icons.mic),onTap: (){

          show(context);},),
      ),
      appBar: AppBar(
          actions: <Widget>[
            // IconButton(
            //   onPressed: (){
            //     _searchPressed();
            //     // showSearch(context: context, delegate: Search());
            //   },
            //   icon: Icon(Icons.search),
            // )
          ],
          centerTitle: true,
          backgroundColor: Colors.lightBlue,
          title: Text('Recording sound'),
          // widget._appTitle,
          // style: TextStyle(color: Colors.white),
      ),
      body:
        Column(
          children: [
            // new Container(
            //   decoration: new BoxDecoration(
            //     image: new DecorationImage(image: new AssetImage("assets/images/images.jfif"), fit: BoxFit.cover,),
            //   ),
            // ),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: <Widget>[
            //     // if (recognizeFinished)
            //     //   _RecognizeContent(
            //     //     text: text,
            //     //   ),
            //     // SizedBox(
            //     //   height: 10.0,
            //     // ),
            //     // RaisedButton(
            //     //   onPressed: recognizing ? () {} : streamingRecognize,
            //     //   child: recognizing
            //     //       ? CircularProgressIndicator()
            //     //       : Text('Test with streaming recognize'),
            //     // ),
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(0),
                  child:SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 50,
                    child:TextField(
                      decoration: InputDecoration(
                      labelText: 'search',
                        focusColor: Colors.lightBlue,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.lightBlue),
                          borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: Colors.lightBlue),
                        borderRadius: BorderRadius.circular(10),
                      )),
                      onChanged: (value){
                        initRecords(dropdownvalue, value.toString());
                        setState((){
                          searchval = value.toString();
                        });
                      },
                      onTap: (){
                        print('sss');
                        recognizing ? () {} : streamingRecognize();
                        CircularProgressIndicator();
                      },
                      // onEditingComplete: () {
                      //   print('ddd');
                      // },
                    ),
                  )
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child:SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 50,
                    child:Container(
                        padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                            border: Border.all(
                              color: Colors.lightBlue,
                              width: 3,
                            ),
                        ),
                        child: DropdownButtonFormField(
                          focusColor:Colors.white,
                          isExpanded: true,
                          // itemHeight: 50.0,
                          value: dropdownvalue,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                          icon: Icon(Icons.arrow_drop_down_sharp),
                          items:items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items,style:TextStyle(color:Colors.black),),
                            );
                          }
                          ).toList(),

                          onChanged: (value){
                            initRecords(value.toString(), searchval);
                            setState(() {
                              dropdownvalue = value.toString();
                            });
                          },
                        )
                    )

                  ),
                ),

              ]
            ),
            Expanded(
              flex: 2,
              child: Records(
                records: records!,
              ),
            ),

          ],
        ),
    );
  }

  void _getNames() async {

    setState(() {

    });
  }

  void _searchPressed() {

  }

  _onFinish() {
    dropdownvalue = 'All';
    records!.clear();
    print(records!.length.toString());
    appDir!.list().listen((onData) {
      records!.add(onData.path);
    }).onDone(() {
      records!.sort();
      records = records!.reversed.toList();
      setState(() {});
    });
  }

  void show(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white70,
          child: Recorder(
            save: _onFinish,
          ),
        );
      },
    );
  }

  void initRecords(String category, String searchStr) {
    if (category == 'All') category = '';
    records!.clear();
    print(records!.length.toString());
    appDir!.list().listen((onData) {
      if(onData.path.substring(onData.path.lastIndexOf('_') + 1, onData.path.lastIndexOf('#')).indexOf(searchStr) != -1 && onData.path.substring(onData.path.lastIndexOf('/') + 1, onData.path.lastIndexOf('_')).indexOf(category) != -1) {
        records!.add(onData.path);
      }
    }).onDone(() {
      records!.sort();
      records = records!.reversed.toList();
      setState(() {});
    });
  }


  @override
  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Popup example'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Hello"),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }


  void recognize() async {
    setState(() {
      recognizing = true;
    });
    final serviceAccount = ServiceAccount.fromString(
        '${(await rootBundle.loadString('assets/test_service_account.json'))}');
    final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
    final config = _getConfig();
    final audio = await _getAudioContent('test.wav');

    await speechToText.recognize(config, audio).then((value) {
      setState(() {
        text = value.results
            .map((e) => e.alternatives.first.transcript)
            .join('\n');
      });
    }).whenComplete(() =>
        setState(() {
          recognizeFinished = true;
          recognizing = false;
        }));
  }

  void streamingRecognize() async {
    setState(() {
      recognizing = true;
    });
    final serviceAccount = ServiceAccount.fromString(
        '${(await rootBundle.loadString('assets/test_service_account.json'))}');
    final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
    final config = _getConfig();

    final responseStream = speechToText.streamingRecognize(
        StreamingRecognitionConfig(config: config, interimResults: true),
        await _getAudioStream('test.wav'));

    responseStream.listen((data) {
      setState(() {
        text =
            data.results.map((e) => e.alternatives.first.transcript).join('\n');
        recognizeFinished = true;
      });
    }, onDone: () {
      setState(() {
        recognizing = false;
      });
    });
  }

  RecognitionConfig _getConfig() =>
      RecognitionConfig(
          encoding: AudioEncoding.LINEAR16,
          model: RecognitionModel.basic,
          enableAutomaticPunctuation: true,
          sampleRateHertz: 16000,
          languageCode: 'en-US');

  Future<void> _copyFileFromAssets(String name) async {
    var data = await rootBundle.load('assets/$name');
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path + '/$name';
    await File(path).writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<List<int>> _getAudioContent(String name) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path + '/$name';
    if (!File(path).existsSync()) {
      await _copyFileFromAssets(name);
    }
    return File(path).readAsBytesSync().toList();
  }

  Future<Stream<List<int>>> _getAudioStream(String name) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path + '/$name';
    if (!File(path).existsSync()) {
      await _copyFileFromAssets(name);
    }
    return File(path).openRead();
  }
}

class _RecognizeContent extends StatelessWidget {
  final String text;

  const _RecognizeContent({ Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text(
            'The text recognized by the Google Speech Api:',
          ),
          SizedBox(
            height: 16.0,
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}