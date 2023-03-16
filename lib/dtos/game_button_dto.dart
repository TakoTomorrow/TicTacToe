import '../symbol_enum.dart';

/// 遊戲按鈕
class GameButtonDto {
  final id;

  /// 按鈕顯示子字符
  SymbolEnum symbol;

  /// 是否顯示
  bool enabled;

  /// Constructor
  GameButtonDto(
      {this.id, this.symbol = SymbolEnum.noneplay, this.enabled = false});

  /// 取得遊戲按鈕清單
  static List<GameButtonDto> getGameButtons(int count) => List.generate(
      9, (index) => GameButtonDto(id: 'button${index.toString()}'));
}
