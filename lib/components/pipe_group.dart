import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy_bird/components/configuration.dart';
import 'package:flappy_bird/components/pipe.dart';
import 'package:flappy_bird/game/assets.dart';
import 'package:flappy_bird/game/flappy_bird_game.dart';
import 'package:flappy_bird/game/pipe_position.dart';

class PipeGroup extends PositionComponent with HasGameRef<FlappyBirdGame> {
  PipeGroup();

  final _random = Random();

  @override
  Future<void> onLoad() async {
    // 画面の右端にパイプを生成
    position.x = gameRef.size.x;

    // 画面の高さから地面の高さを引いた範囲でパイプを生成
    final heightMinusGround = gameRef.size.y - Config.groundHeight;
    // パイプの間隔をランダムに設定
    final spacing = 100 + _random.nextDouble() * (heightMinusGround / 4);
    // パイプの中心位置をランダムに設定
    final centerY =
        spacing + _random.nextDouble() * (heightMinusGround - spacing);

    addAll([
      // 上側のパイプ
      Pipe(
        pipePosition: PipePosition.top,
        height: centerY - spacing / 2,
      ),
      // 下側のパイプ
      Pipe(
        pipePosition: PipePosition.bottom,
        height: heightMinusGround - (centerY + spacing / 2),
      ),
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // パイプを左に移動
    position.x -= Config.gameSpeed * dt;
    // 画面外に出たら削除
    if (position.x < -10) {
      removeFromParent();
      updateScore();
    }
    // 衝突したら削除
    if (gameRef.isHit) {
      removeFromParent();
      gameRef.isHit = false;
    }
  }

  // スコアを更新
  void updateScore() {
    gameRef.bird.score += 1;
    FlameAudio.play(Assets.point);
  }
}
