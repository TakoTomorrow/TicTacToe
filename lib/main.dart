import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToe());
}

class TicTacToe extends StatelessWidget {
  const TicTacToe({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TicTacToePage(title: 'Tic Tac Toe Page'),
    );
  }
}

class TicTacToePage extends StatefulWidget {
  const TicTacToePage({super.key, required this.title});
  final String title;

  @override
  State<TicTacToePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  String nextGammer = 'O';

  bool haveRepent = false;
  
  List<String> clickTrace = [''];

  List<GameButton> buttons = GameButton.getGameButtons(9);

  String get currentButtonId {
    return clickTrace.last;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            children: List.generate(
              9,
              _getGameButton,
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () => _clickStartGame(),
              child: const Text('Start Game!'),
            ),
          )
        ],
      ),
    );
  }

  void _initializeState() {
    buttons = GameButton.getGameButtons(9);
    clickTrace = [''];
    nextGammer = 'O';
  }

  void _clickGameButton(GameButton thisButton) => setState(() {
        var currentGammer = nextGammer;

        if (currentButtonId == '' || !thisButton.enabled) {
          thisButton.enabled = !thisButton.enabled;
          thisButton.text = currentGammer;
          haveRepent = false;
          _checkWinner();
          nextGammer = currentGammer == 'O' ? 'X' : 'O';
          clickTrace.add(thisButton.id);
        } else if (thisButton.id == currentButtonId && !haveRepent) {
          thisButton.enabled = !thisButton.enabled;
          haveRepent = true;
          nextGammer = thisButton.text = currentGammer == 'O' ? 'X' : 'O';
          clickTrace.removeAt(clickTrace.length - 1);
        }
      });

  void _checkWinner() {
    var currentGammer = nextGammer;
    var isOver = false;

    if (buttons[0].text == currentGammer && buttons[0].text == buttons[1].text && buttons[1].text == buttons[2].text) isOver = true;
    else if (buttons[3].text == currentGammer && buttons[3].text == buttons[4].text && buttons[4].text == buttons[5].text) isOver = true;
    else if (buttons[6].text == currentGammer && buttons[6].text == buttons[7].text && buttons[7].text == buttons[8].text) isOver = true;
    else if (buttons[0].text == currentGammer && buttons[0].text == buttons[3].text && buttons[3].text == buttons[6].text) isOver = true;
    else if (buttons[1].text == currentGammer && buttons[1].text == buttons[4].text && buttons[4].text == buttons[7].text) isOver = true;
    else if (buttons[2].text == currentGammer && buttons[2].text == buttons[5].text && buttons[5].text == buttons[8].text) isOver = true;
    else if (buttons[0].text == currentGammer && buttons[0].text == buttons[4].text && buttons[4].text == buttons[8].text) isOver = true;
    else if (buttons[2].text == currentGammer && buttons[2].text == buttons[4].text && buttons[4].text == buttons[6].text) isOver = true;

    if(isOver){
      showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(content: Text('$currentGammer WIN!'));
            });
      
      _initializeState();
    }
  }

  void _clickStartGame() => setState(() {
        _initializeState();
      });

  Container _getGameButton(int index) {
    var thisButton = buttons[index];

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.grey),
        ),
        onPressed: () => _clickGameButton(thisButton),
        child: Text(
          thisButton.enabled ? thisButton.text : "",
          style: const TextStyle(
            fontSize: 50.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class GameButton {
  final id;
  String text;
  bool enabled;

  GameButton({this.id, this.text = '', this.enabled = false});

  static List<GameButton> getGameButtons(int count) {
    var result = <GameButton>[];
    for (int index = 1; index <= count; index++) {
      result.add(GameButton(id: 'button${index.toString()}'));
    }
    return result;
  }
}
