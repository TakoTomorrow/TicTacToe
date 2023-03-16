import '../symbol_enum.dart';

/// 玩家
class PlayerDto {
  /// 名稱
  final String name;

  /// 字符
  final SymbolEnum symbol;

  /// 勝場數
  int win = 0;

  /// Constructor
  PlayerDto({required this.name, required this.symbol});
}
