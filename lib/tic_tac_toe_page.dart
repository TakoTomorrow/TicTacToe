import 'package:flutter/material.dart';

import 'dtos/game_button_dto.dart';
import 'dtos/player_dto.dart';
import 'symbol_enum.dart';

/// 圈叉遊戲頁
class TicTacToePage extends StatefulWidget {
  /// Page標題
  final String title;

  /// 1號玩家
  final PlayerDto player1;

  /// 2號玩家
  final PlayerDto player2;

  /// Constructor
  const TicTacToePage(
      {super.key,
      required this.title,
      required this.player1,
      required this.player2});

  @override
  State<TicTacToePage> createState() => _TicTacToePageState();
}

/// 圈叉遊戲頁的狀態
class _TicTacToePageState extends State<TicTacToePage> {
  /// 按鈕清單
  List<GameButtonDto> buttons = GameButtonDto.getGameButtons(9);

  /// 是否回手
  bool _haveRepent = false;

  /// 當局遊戲按鈕追蹤
  List<String> _traceOfClick = [''];

  // 下一手輪到誰
  PlayerDto? nextPlayer;

  /// 最後一個被按的按鈕
  String get lastButtonId {
    return _traceOfClick.last;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            //mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  color: nextPlayer == null
                      ? Colors.blue
                      : nextPlayer == widget.player1
                          ? Colors.blue
                          : Colors.white10,
                  child: Text(
                    'P1 :  ${widget.player1.name}',
                    style: TextStyle(
                      color: nextPlayer == null
                          ? Colors.white
                          : nextPlayer == widget.player1
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  color: nextPlayer == widget.player2
                      ? Colors.blue
                      : Colors.white10,
                  child: Text(
                    'P2 :  ${widget.player2.name}',
                    style: TextStyle(
                      color: nextPlayer == null
                          ? Colors.black
                          : nextPlayer == widget.player1
                              ? Colors.black
                              : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                children: _getTextButtons(9),
              ),
              const SizedBox(height: 20,),
              Center(
                child: ElevatedButton(
                  onPressed: () => _restartGame(),
                  child: const Text('Restart Game!'),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  /// 初始化狀態
  void _initializeState() {
    buttons = GameButtonDto.getGameButtons(9);
    _haveRepent = false;
    _traceOfClick = [''];
    nextPlayer = widget.player1;
  }

  /// 點下棋盤上的按鈕
  void _clickGameButton(GameButtonDto thisButton) => setState(() {
        /// 按下按鈕的
        var currentPlayer = nextPlayer ?? widget.player1;

        /// 回手
        if (thisButton.id == lastButtonId && !_haveRepent) {
          thisButton.enabled = false;
          thisButton.symbol = SymbolEnum.noneplay;
          _haveRepent = true;

          nextPlayer = currentPlayer.name == widget.player1.name
              ? widget.player2
              : widget.player1;

          _traceOfClick.removeAt(_traceOfClick.length - 1);
        }

        /// 落子
        else if (lastButtonId == '' || !thisButton.enabled) {
          thisButton.enabled = true;
          thisButton.symbol = currentPlayer.symbol;
          _haveRepent = false;

          if (!_checkGameOver()) {
            nextPlayer = currentPlayer.name == widget.player1.name
                ? widget.player2
                : widget.player1;

            _traceOfClick.add(thisButton.id);
          }
        }
      });

  /// 確認遊戲是否結束
  bool _checkGameOver() {
    var currentGammer = nextPlayer;
    var isOver = _haveWinner();

    // 分出勝負
    if (isOver) {
      // 贏家勝場數 ＋1
      currentGammer?.name == widget.player1.name
          ? widget.player1.win++
          : widget.player2.win++;

      _showGameOverMessageFuture('${currentGammer?.name} WIN!');

      return true;
    }

    // 平手
    if (_traceOfClick.length == buttons.length) {
      _showGameOverMessageFuture('The game is over!');

      return true;
    }

    // 遊戲繼續
    return false;
  }

  /// 確認是否出現遊戲贏家
  bool _haveWinner() {
    var currentGammer = nextPlayer;

    if (buttons[0].symbol == currentGammer?.symbol &&
        buttons[0].symbol == buttons[1].symbol &&
        buttons[1].symbol == buttons[2].symbol) {
      return true;
    } else if (buttons[3].symbol == currentGammer?.symbol &&
        buttons[3].symbol == buttons[4].symbol &&
        buttons[4].symbol == buttons[5].symbol) {
      return true;
    } else if (buttons[6].symbol == currentGammer?.symbol &&
        buttons[6].symbol == buttons[7].symbol &&
        buttons[7].symbol == buttons[8].symbol) {
      return true;
    } else if (buttons[0].symbol == currentGammer?.symbol &&
        buttons[0].symbol == buttons[3].symbol &&
        buttons[3].symbol == buttons[6].symbol) {
      return true;
    } else if (buttons[1].symbol == currentGammer?.symbol &&
        buttons[1].symbol == buttons[4].symbol &&
        buttons[4].symbol == buttons[7].symbol) {
      return true;
    } else if (buttons[2].symbol == currentGammer?.symbol &&
        buttons[2].symbol == buttons[5].symbol &&
        buttons[5].symbol == buttons[8].symbol) {
      return true;
    } else if (buttons[0].symbol == currentGammer?.symbol &&
        buttons[0].symbol == buttons[4].symbol &&
        buttons[4].symbol == buttons[8].symbol) {
      return true;
    } else if (buttons[2].symbol == currentGammer?.symbol &&
        buttons[2].symbol == buttons[4].symbol &&
        buttons[4].symbol == buttons[6].symbol) {
      return true;
    }

    return false;
  }

  /// 重啟遊戲
  void _restartGame() => setState(() => {_initializeState()});

  /// 顯示遊戲結束訊息
  Future<void> _showGameOverMessageFuture(String message) async =>
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              message,
              textAlign: TextAlign.center,
            ),
          );
        },
      ).then((_) => _restartGame());

  /// 取得九宮格按鈕widgets清單
  List<Widget> _getTextButtons(int count) => List.generate(
      count,
      (index) => Container(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.grey),
              ),
              onPressed: () => _clickGameButton(buttons[index]),
              child: Text(
                buttons[index].enabled ? buttons[index].symbol.symbol : "",
                style: const TextStyle(
                  fontSize: 50.0,
                  color: Colors.white,
                ),
              ),
            ),
          ));
}
