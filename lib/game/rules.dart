import 'package:studio_core/core/arcade.dart';
import 'package:studio_core/core/level_plan.dart';
import 'package:studio_core/core/missions.dart';
import 'package:studio_core/core/stats.dart';
import 'shot_engine.dart';

class BowlingRules extends ArcadeRules<ShotLevel> {
  @override
  String get gameId => 'game-086-bowling-master';

  @override
  List<String> get optionalMechanics => const [];

  @override
  List<GameStat> get gameStats => const [
        GameStat('strikes', 'Strike', 'Strikes', scale: 100),
        GameStat('spares', 'Spare', 'Spares', scale: 100),
        GameStat('pins_knocked', 'Devrilen lobut', 'Pins knocked down', scale: 2000),
        GameStat('shots_taken', 'Yapılan atış', 'Shots taken', scale: 300),
      ];

  @override
  List<MissionTemplate> get missionTemplates => const [
        MissionTemplate('strikes', 'strikes', [25, 50, 100]),
        MissionTemplate('spares', 'spares', [12, 25, 50], coinReward: 80),
      ];

  @override
  ShotLevel generate(LevelSpec spec) => generateShot(ShotKind.bowling, spec);

  @override
  ArcadeMeta metaOf(ShotLevel l) => l.meta;

  @override
  ArcadeSim createSim(ShotLevel l) => ShotSim(l);

  @override
  ArcadeInput bot(ArcadeSim sim) => shotBot(sim);
}

ArcadeRules createRules() => BowlingRules();
