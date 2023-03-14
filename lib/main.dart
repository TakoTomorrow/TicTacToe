import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/// Run App
void main() => runApp(const TicTacToe());

class TicTacToe extends StatelessWidget {
  const TicTacToe({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TicTacToeState(),
      child: MaterialApp(
        title: 'Tic Tac Toe',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
        routes: {
          '/tictactoe': (_) {
            // 從ＭodalRoute 提取參數
            var arguments = ModalRoute.of(_)?.settings.arguments as Map;

            var player1 = Player(
              name: arguments['player1'],
              symbol: Symbols.player1,
            );
            var player2 = Player(
              name: arguments['player2'],
              symbol: Symbols.player2,
            );

            return TicTacToePage(
              title: 'Tic Tac Toe Page',
              player1: player1,
              player2: player2,
            );
          },
        },
      ),
    );
  }
}

class TicTacToeState extends ChangeNotifier {
  TextEditingController player1Controller = TextEditingController();

  TextEditingController player2Controller = TextEditingController();
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var state = context.watch<TicTacToeState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Regist Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              width: 200,
              child: Center(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Enter Play1 Name',
                  ),
                  controller: state.player1Controller,                  
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              width: 200,
              child: Center(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Enter Play2 Name',
                  ),
                  controller: state.player2Controller,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                if (state.player1Controller.text == '') {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          content: Text('Player1 is null!'),
                        );
                      });
                  
                  return;
                }
                if (state.player2Controller.text == '') {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          content: Text('Player2 is null!'),
                        );
                      });

                  return;
                }

                var players = {
                  'player1': state.player1Controller.text,
                  'player2': state.player2Controller.text,
                };

                Navigator.of(context)
                    .pushNamed('/tictactoe', arguments: players);
              },
              child: const Text('Start Game'),
            )
          ],
        ),
      ),
    );
  }
}

class TicTacToePage extends StatefulWidget {
  final String title;

  final Player player1;

  final Player player2;

  const TicTacToePage(
      {super.key,
      required this.title,
      required this.player1,
      required this.player2});

  @override
  _TicTacToePageState createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  List<GameButton> buttons = GameButton.getGameButtons(9);

  bool haveRepent = false;

  List<String> _clickTrace = [''];

  Player? nextPlayer;

  String get lastButtonId {
    return _clickTrace.last;
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
    _clickTrace = [''];
    nextPlayer = widget.player1;
  }

  void _clickGameButton(GameButton thisButton) {
    setState(() {
      var currentPlayer = nextPlayer ?? widget.player1;

      if (thisButton.id == lastButtonId && !haveRepent) {
        thisButton.enabled = false;
        thisButton.symbol = Symbols.noneplay;
        haveRepent = true;
        nextPlayer = currentPlayer.name == widget.player1.name
            ? widget.player2
            : widget.player1;
        _clickTrace.removeAt(_clickTrace.length - 1);
      } else if (lastButtonId == '' || !thisButton.enabled) {
        thisButton.enabled = true;
        thisButton.symbol = currentPlayer.symbol;
        haveRepent = false;
        _checkWinner();
        nextPlayer = currentPlayer.name == widget.player1.name
            ? widget.player2
            : widget.player1;
        _clickTrace.add(thisButton.id);
      }
    });
  }

  void _checkWinner() {
    var currentGammer = nextPlayer;
    var isOver = false;

    if (buttons[0].symbol == currentGammer?.symbol &&
        buttons[0].symbol == buttons[1].symbol &&
        buttons[1].symbol == buttons[2].symbol)
      isOver = true;
    else if (buttons[3].symbol == currentGammer?.symbol &&
        buttons[3].symbol == buttons[4].symbol &&
        buttons[4].symbol == buttons[5].symbol)
      isOver = true;
    else if (buttons[6].symbol == currentGammer?.symbol &&
        buttons[6].symbol == buttons[7].symbol &&
        buttons[7].symbol == buttons[8].symbol)
      isOver = true;
    else if (buttons[0].symbol == currentGammer?.symbol &&
        buttons[0].symbol == buttons[3].symbol &&
        buttons[3].symbol == buttons[6].symbol)
      isOver = true;
    else if (buttons[1].symbol == currentGammer?.symbol &&
        buttons[1].symbol == buttons[4].symbol &&
        buttons[4].symbol == buttons[7].symbol)
      isOver = true;
    else if (buttons[2].symbol == currentGammer?.symbol &&
        buttons[2].symbol == buttons[5].symbol &&
        buttons[5].symbol == buttons[8].symbol)
      isOver = true;
    else if (buttons[0].symbol == currentGammer?.symbol &&
        buttons[0].symbol == buttons[4].symbol &&
        buttons[4].symbol == buttons[8].symbol)
      isOver = true;
    else if (buttons[2].symbol == currentGammer?.symbol &&
        buttons[2].symbol == buttons[4].symbol &&
        buttons[4].symbol == buttons[6].symbol) isOver = true;

    if (isOver) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('${currentGammer?.name} WIN!'),
            );
          });

      _clickStartGame();
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
          thisButton.enabled ? thisButton.symbol.symbol : "",
          style: const TextStyle(
            fontSize: 50.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// 遊戲按鈕
class GameButton {
  final id;

  /// 按鈕顯示子字串
  Symbols symbol;

  bool enabled;

  GameButton({this.id, this.symbol = Symbols.noneplay, this.enabled = false});

  /// 取得遊戲按鈕清單
  static List<GameButton> getGameButtons(int count) =>
      List.generate(9, (index) => GameButton(id: 'button${index.toString()}'));
}

class Player {
  final String name;

  final Symbols symbol;

  const Player({required this.name, required this.symbol});
}

enum Symbols {
  noneplay(''),
  player1('O'),
  player2('X');

  final String symbol;

  const Symbols(this.symbol);
}
