import 'package:injectable/injectable.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

@singleton
class SpeechService{

  bool speechAvailable = false;
  stt.SpeechToText speech = stt.SpeechToText();

  /// Initialization function called when the app is first opened
  void initializeSpeechService() async {
    speechAvailable = await speech.initialize( onStatus: (status) {
      print('Speech to text status: '+ status);
    }, onError: (errorNotification) {
      print('Speech to text error: '+ errorNotification.errorMsg);
    }, );
  }

  /// Start listening for user input
  /// resultCallback is specified by the caller
  void startListening(Function(SpeechRecognitionResult result) resultCallback){
    speech.listen(onResult: resultCallback,);
  }

  /// Stop listening to user input and free up the audio stream
  Future<void> stopListening() async {
    await speech.stop();
  }

}