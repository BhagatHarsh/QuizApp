// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';
import 'package:html/parser.dart';

//https://github.com/jgoralcz/trivia
Future<List<Map<String, dynamic>>> getQuestion() async {
  HttpClient client = HttpClient();
  HttpClientRequest request = await client.getUrl(
      Uri.parse("https://beta-trivia.bongo.best/?type=boolean&limit=5"));
  HttpClientResponse response = await request.close();
  String responseBody = await response.transform(utf8.decoder).join();
  return List<Map<String, dynamic>>.from(jsonDecode(responseBody));
}

class QuizBrain {
  int _questionNumber = -1;
  List<Map<String, dynamic>> _questionBank = [];

  int getQuestionNumber() {
    return _questionNumber;
  }

  void nextQuestion() async {
    _questionNumber++;
    List<Map<String, dynamic>> question = await getQuestion();
    for (int i = 0; i < question.length; i++) {
      _questionBank.add(question[i]);
    }
  }

  String getQuestionText() {
    return parse(_questionBank[_questionNumber]['question']).body.text;
  }

  String getQuestionOfASpecificNumber(int number) {
    return parse(_questionBank[number]['question']).body.text;
  }

  bool getCorrectAnswer() {
    return _questionBank[_questionNumber]['correct_answer'] == 'True';
  }

  bool isFinished() {
    if (_questionNumber >= _questionBank.length - 1) {
      print("At the End");
      return true;
    } else
      return false;
  }

  void reset() {
    _questionNumber = 0;
    _questionBank = [];
  }
}

// void main() async {
//   QuizBrain quizBrain = QuizBrain();
//   await quizBrain.nextQuestion();
//   print(quizBrain.getQuestionText());
//   print(quizBrain.getCorrectAnswer());
// }
