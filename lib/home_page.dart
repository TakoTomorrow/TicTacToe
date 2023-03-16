import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'global_state.dart';

/// 首頁
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var state = context.watch<GlobalState>();

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
