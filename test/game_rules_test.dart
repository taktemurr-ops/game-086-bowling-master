import 'package:flutter_test/flutter_test.dart';
import 'package:game_086_bowling_master/core/arcade.dart';
import 'package:game_086_bowling_master/core/level_plan.dart';
import 'package:game_086_bowling_master/game/rules.dart';
import 'package:game_086_bowling_master/game/shot_engine.dart';

void main() {
  final rules = BowlingRules();
  final planner = LevelPlanner(gameId: rules.gameId, optionalMechanics: rules.optionalMechanics);

  ShotSim fresh([int n = 1]) => ShotSim(rules.build(planner.spec(n)).puzzle);

  test('drag and release fires a shot, a tiny tap does not', () {
    final s = fresh();
    if (s.usesReticle) {
      s.tick(const ArcadeInput(down: true, x: 500, y: 650));
      s.tick(const ArcadeInput(down: false, x: 500, y: 650));
      expect(s.shots, 0, reason: 'too short a hold');
      for (var i = 0; i < 10; i++) {
        s.tick(const ArcadeInput(down: true, x: 500, y: 650));
      }
      s.tick(const ArcadeInput(down: false, x: 500, y: 650));
      expect(s.shots, 1);
    } else {
      s.tick(const ArcadeInput(down: true, x: 500, y: 800));
      s.tick(const ArcadeInput(down: true, x: 503, y: 805));
      s.tick(const ArcadeInput(down: false, x: 503, y: 805));
      expect(s.shots, 0, reason: 'too short a drag');
      s.tick(const ArcadeInput(down: true, x: 500, y: 800));
      s.tick(const ArcadeInput(down: true, x: 500, y: 1000));
      s.tick(const ArcadeInput(down: false, x: 500, y: 1000));
      expect(s.shots, 1);
      expect(s.phase, 1);
    }
  });

  test('failing a round costs a life and restarts the same layout', () {
    final s = fresh(3);
    final before = s.goalText;
    s.roundFailed();
    expect(s.lives, 2);
    expect(s.goalText, before);
    expect(s.over, isFalse);
  });

  test('autopilot clears the first ten levels without losing a life', () {
    for (var n = 1; n <= 10; n++) {
      final s = fresh(n);
      final r = runBot(s, rules.bot, 60 * 60 * 6);
      expect(r.won, isTrue, reason: 'level $n');
      expect(s.stars, greaterThanOrEqualTo(1));
    }
  });

  test('bowling: scoring follows the standard rules', () {
    expect(BowlingSim.scoreOf(List.filled(12, 10), 10), 300);
    expect(BowlingSim.scoreOf(List.filled(21, 5), 10), 150);
    expect(BowlingSim.scoreOf([9, 0, 9, 0, 9, 0], 3), 27);
    expect(BowlingSim.scoreOf([10, 3, 4], 2), 24);
  });

  test('bowling: a fast roll at the pocket knocks most pins down', () {
    final pins = rackPins();
    final ball = Disc(515, kFoulY, kBowlR, 5, 0)..vy = -30;
    var gutter = false;
    for (var i = 0; i < 500; i++) {
      if (!BowlingSim.stepLane(ball, pins, () => gutter, () => gutter = true)) break;
    }
    expect(BowlingSim.countDown(pins), greaterThanOrEqualTo(6));
  });
}
