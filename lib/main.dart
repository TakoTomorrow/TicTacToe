import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dtos/player_dto.dart';
import 'home_page.dart';
import 'symbol_enum.dart';
import 'tic_tac_toe_page.dart';
import 'global_state.dart';

/// Run App
void main() => runApp(const Startup());

class Startup extends StatelessWidget {
  const Startup({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GlobalState(),
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

            return TicTacToePage(
              title: 'Tic Tac Toe Page',
              player1: PlayerDto(
                name: arguments['player1'],
                symbol: SymbolEnum.player1,
              ),
              player2: PlayerDto(
                name: arguments['player2'],
                symbol: SymbolEnum.player2,
              ),
            );
          },
        },
      ),
    );
  }
}
