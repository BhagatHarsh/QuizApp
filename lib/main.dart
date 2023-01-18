import 'package:flutter/material.dart';
import 'Tick.dart';
import 'quiz_bank.dart';
import 'package:shared_preferences/shared_preferences.dart';

int highScore = 0;
QuizBrain quizBrain = QuizBrain();

void initiateQuestion() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  highScore = await prefs.getInt('highScore') ?? 0;
  await quizBrain.nextQuestion();
}

void updateHighscore(int green, int red) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int currentScore = green - red;
  if (highScore < currentScore) {
    highScore = currentScore;
    prefs.setInt('highScore', highScore);
  }
}

void printHighscore() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  highScore = prefs.getInt('highScore');
  print(highScore);
}

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: HomeScreen(),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color _hoverChange = Colors.teal;
  Color _backGroundColor = Colors.grey.shade900;

  @override
  void initState() {
    printHighscore();
    initiateQuestion();
    super.initState();
  }

  void getHighscore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    highScore = await prefs.getInt('highScore') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backGroundColor,
      appBar: AppBar(
        title: Center(
          child: Text("Quiz App",
              style: TextStyle(
                fontSize: 20,
                color: _backGroundColor,
              )),
        ),
        backgroundColor: _hoverChange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 60),
            Text(
              "High Score: $highScore " + (highScore != 0 ? "!" : ""),
              style: TextStyle(
                fontSize: 20,
                color: _hoverChange,
              ),
            ),
            SizedBox(height: 60),
            TextButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Start Quiz",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    )),
              ),
              style: TextButton.styleFrom(
                backgroundColor: _hoverChange,
              ),
              onHover: (isHovering) {
                if (isHovering) {
                  setState(() {
                    _hoverChange = Colors.green;
                    _backGroundColor = Colors.black;
                    getHighscore();
                  });
                } else {
                  setState(() {
                    _hoverChange = Colors.teal;
                    _backGroundColor = Colors.grey.shade900;
                    getHighscore();
                  });
                }
              },
              onPressed: () {
                // Navigate to the quiz screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SafeArea(child: QuizPage()),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Widget> scoreKeeper = [];
  int _greenTicks = 0;
  int _redTicks = 0;

  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer = quizBrain.getCorrectAnswer();

    setState(() {
      if (userPickedAnswer == correctAnswer) {
        _greenTicks++;
        scoreKeeper.add(
          getTick(
            context,
            quizBrain.getQuestionNumber(),
            quizBrain.getQuestionText(),
            correctAnswer,
            Colors.green,
            Icons.check,
          ),
        );
      } else {
        _redTicks++;
        scoreKeeper.add(
          getTick(
            context,
            quizBrain.getQuestionNumber(),
            quizBrain.getQuestionText(),
            correctAnswer,
            Colors.red,
            Icons.close,
          ),
        );
      }
      updateHighscore(_greenTicks, _redTicks);
      initiateQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      'Score: ${_greenTicks - _redTicks}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25.0,
                        color: changeScoreColor(_greenTicks - _redTicks),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    //The user picked true.
                    updateHighscore(_greenTicks, _redTicks);
                    Navigator.pop(context);
                    _greenTicks = 0;
                    _redTicks = 0;
                    scoreKeeper = [];
                    quizBrain.reset();
                    initiateQuestion();
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                //The user picked true.
                checkAnswer(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                //The user picked false.
                checkAnswer(false);
              },
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: scoreKeeper,
          ),
        )
      ],
    );
  }
}

class SpecificQuestion extends StatefulWidget {
  const SpecificQuestion({Key key}) : super(key: key);

  @override
  State<SpecificQuestion> createState() => _SpecificQuestionState();
}

class _SpecificQuestionState extends State<SpecificQuestion> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Color changeScoreColor(int score) {
  if (score > 0) {
    return Colors.green;
  } else if (score < 0) {
    return Colors.red;
  } else {
    return Colors.white;
  }
}
