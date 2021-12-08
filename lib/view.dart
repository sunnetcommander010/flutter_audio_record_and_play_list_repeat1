import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'audio_recorder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Recorder extends StatefulWidget {
  final Function save;

  const Recorder({Key? key, required this.save}) : super(key: key);
  @override
  _RecorderState createState() => _RecorderState();
}

class _RecorderState extends State<Recorder> {
  IconData _recordIcon = Icons.mic_none;
  MaterialColor colo = Colors.orange;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  bool stop = false;
  Recording? _current;
  // Recorder properties
  late FlutterAudioRecorder? audioRecorder;

  String dropdownvalue = 'Iron 8';
  var items =  ['Iron 8','Iron 9','Iron Wedge','Iron 10','Iron 1','golf wedge'];
  String recordname = '';

  @override
  void initState() {
    super.initState();
    checkPermission();
  }
  checkPermission()async{

    if (await Permission.contacts.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
    }

// You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.storage,
    ].request();
    print(statuses[Permission.microphone]);
    print(statuses[Permission.storage]);
    //bool hasPermission = await FlutterAudioRecorder.hasPermissions ?? false;
    if (statuses[Permission.microphone]==PermissionStatus.granted) {
      _currentStatus = RecordingStatus.Initialized;
      _recordIcon = Icons.mic;
    }else
    {

    }
  }

  @override
  void dispose() {
    _currentStatus = RecordingStatus.Unset;
    audioRecorder = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            SizedBox(height: 20,),
            Text(
              (_current==null)?"0:0:0:0":(_current!.duration.toString().substring(0,_current!.duration.toString().indexOf('.'))),
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            SizedBox(height: 20,),
            stop == false
                ? RaisedButton(
              color: Colors.orange,
              onPressed: () async {
                Directory? appDir = await getExternalStorageDirectory();
                if (await Directory("${appDir!.path}/Audiorecords").exists()) {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupDialog(context),
                  );
                }else {
                  _onRecordButtonPressed();
                  setState(() {});
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    child: Icon(
                      _recordIcon,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Write Dailry",style: TextStyle(color: Colors.white),),
                  )
                ],
              ),
            )
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RaisedButton(
                    color: colo,
                    onPressed: () async {
                      await _onRecordButtonPressed();
                      setState(() {});
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      width: 80,
                      height: 80,
                      child: Icon(
                        _recordIcon,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.orange,
                    onPressed: _currentStatus != RecordingStatus.Unset
                        ? _stop : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      width: 80,
                      height: 80,
                      child: Icon(
                        Icons.stop,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ],
    );
  }

  Future<void> _onRecordButtonPressed() async {
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          _recordo();
          break;
        }
      case RecordingStatus.Recording:
        {
          _pause();
          break;
        }
      case RecordingStatus.Paused:
        {
          _resume();
          break;
        }
      case RecordingStatus.Stopped:
        {
          _recordo();
          break;
        }
      default:
        break;
    }
  }

  // @override
  // Widget _buildPopupStateful() {
  //   return StatefulBuilder(builder: (context, setState) {
  //     _buildPopupDialog(context);
  //   }
  // }

  @override
  Widget _buildPopupDialog(BuildContext context) {
    return StatefulBuilder(builder: (context, setState)
    {
      return AlertDialog(
        // title: const Text('save record'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Text("Hello"),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'input record name',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onChanged: (value) {
                recordname = value.toString();
                print(recordname);
              },
            ),
            DropdownButton(
              value: dropdownvalue,
              icon: Icon(Icons.keyboard_arrow_down),
              items: items.map((String items) {
                return DropdownMenuItem(
                    value: items,
                    child: Text(items)
                );
              }
              ).toList(),

              onChanged: (value) {
                setState(() {
                  dropdownvalue = value.toString();
                  print('value: ' + value.toString() + dropdownvalue);
                });
              },
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              _onRecordButtonPressed();
              setState(() {});
              Navigator.of(context).pop();
            },
            textColor: Theme
                .of(context)
                .primaryColor,
            child: const Text('ok'),
          ),
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            textColor: Theme
                .of(context)
                .primaryColor,
            child: const Text('Close'),
          ),
        ],
      );
    });
  }

  _initial() async {
    Directory? appDir = await getExternalStorageDirectory();
    String jrecord = 'Audiorecords';
    String dato = "${DateTime.now().millisecondsSinceEpoch?.toString()}.wav";
    print(recordname);
    dato = dropdownvalue + '_' + recordname + '#' + dato;
    Directory appDirec = Directory("${appDir!.path}/$jrecord/");
    if (await appDirec.exists()) {
      String patho = "${appDirec.path}$dato";
      print("path for file11 ${patho}");
      audioRecorder = FlutterAudioRecorder(patho, audioFormat: AudioFormat.WAV);
      await audioRecorder!.initialized;
    } else {
      appDirec.create(recursive: true);
      Fluttertoast.showToast(msg: "Start Recording , Press Start");
      String patho = "${appDirec.path}$dato";
      print("path for file22 ${patho}");
      audioRecorder = FlutterAudioRecorder(patho, audioFormat: AudioFormat.WAV);
      await audioRecorder!.initialized;
    }
  }

  _start() async {
    await audioRecorder!.start();
    var recording = await audioRecorder!.current(channel: 0);
    setState(() {
      _current = recording!;
    });

    const tick = const Duration(milliseconds: 50);
    new Timer.periodic(tick, (Timer t) async {
      if (_currentStatus == RecordingStatus.Stopped) {
        // _current!.duration = tick;
        t.cancel();
      }

      var current = await audioRecorder!.current(channel: 0);
      setState(() {
        _current = current!;
        _currentStatus = _current!.status!;
      });
    });
  }

  _resume() async {
    await audioRecorder!.resume();
    Fluttertoast.showToast(msg: "Resume Recording");
    setState(() {
      _recordIcon = Icons.pause;
      colo = Colors.red;
    });
  }

  _pause() async {
    await audioRecorder!.pause();
    Fluttertoast.showToast(msg: "Pause Recording");
    setState(() {
      _recordIcon = Icons.mic;
      colo = Colors.green;
    });
  }

  _stop() async {
    print('_stop()');
    var result = await audioRecorder!.stop();
    Fluttertoast.showToast(msg: "Stop Recording , File Saved");
    widget.save();
    setState(() {
      _current = result!;
      _currentStatus = _current!.status!;
      // _current!.duration = tick;
      _recordIcon = Icons.mic;
      stop = false;
    });
  }

  Future<void> _recordo() async {

    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.storage,
    ].request();
    print(statuses[Permission.microphone]);
    print(statuses[Permission.storage]);
    //bool hasPermission = await FlutterAudioRecorder.hasPermissions ?? false;
    if (statuses[Permission.microphone]==PermissionStatus.granted) {

      /* }
    bool hasPermission = await FlutterAudioRecorder.hasPermissions ?? false;

    if (hasPermission) {*/
      await _initial();
      await _start();
      Fluttertoast.showToast(msg: "Start Recording");
      setState(() {
        _currentStatus = RecordingStatus.Recording;
        _recordIcon = Icons.pause;
        colo = Colors.red;
        stop = true;
      });
    } else {
      Fluttertoast.showToast(msg: "Allow App To Use Mic");
    }
  }
}