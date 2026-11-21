import 'package:flutter/material.dart';

import 'package:studio_core/app/arcade_stage.dart';
import 'package:studio_core/app/game_api.dart';
import 'package:studio_core/core/game_rules.dart';
import 'shot_engine.dart';
import 'shot_view.dart';
import 'rules.dart';

final gameConfig = GameConfig(
  gameId: 'game-086-bowling-master',
  title: const ['Bowling Ustası', 'Bowling Master', 'Bowling-Meister', 'Maestro del Bowling', 'Maître du Bowling'],
  tagline: const ['Strike üstüne strike!', 'Strike after strike!', 'Strike um Strike!', '¡Strike tras strike!', 'Strike après strike !'],
  seedColor: const Color(0xFF3A0CA3),
  icon: Icons.sports_cricket,
  rules: BowlingRules(),
  buildPlay: (ctx) => ArcadeStage(
    ctx: ctx,
    create: () => ShotSim((ctx.generated as GeneratedLevel<ShotLevel>).puzzle),
    paint: paintShot,
    sound: shotSound,
    boosterIcon: Icons.border_outer,
    boosterLabel: (l) => l == 'tr' ? 'Bariyer' : 'Bumpers',
    howTo: const ['Alt şeride dokunup kaydır: topun konumu. Sonra yukarıda bas, geri çek ve bırak: yön ve güç.', 'Touch the bottom strip to position the ball. Then press above, pull back and release to bowl.', 'Unten positionieren, dann zurückziehen und loslassen.', 'Coloca abajo, luego tira y suelta.', 'Placez en bas, puis tirez et relâchez.'],
  ),
  tutorial: const [
    TutorialStep(Icons.swap_horiz, ['Alt şeritte topu konumlandır.', 'Position the ball on the bottom strip.', 'Ball positionieren.', 'Coloca la bola.', 'Placez la boule.']),
    TutorialStep(Icons.open_with, ['Geri çek ve bırak.', 'Pull back and release.', 'Zurückziehen und loslassen.', 'Tira y suelta.', 'Tirez et relâchez.']),
    TutorialStep(Icons.looks_one, ['Baş lobutun hemen yanını (cep) hedefle.', 'Aim just beside the head pin (the pocket).', 'Auf die Tasche zielen.', 'Apunta al bolsillo.', 'Visez la poche.']),
  ],
);
