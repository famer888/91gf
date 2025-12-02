import 'package:flutter/material.dart';
import 'package:jygf/domain/model/game/game_section/game_section_model.dart';
import 'package:jygf/ui_layer/screens/common_widgets/game/card/block_card.dart';
import 'card/ad_card.dart';

class GameSectionCard extends StatelessWidget {
  const GameSectionCard({super.key, required this.model});
  final GameSectionModel model;
  @override
  Widget build(BuildContext context) {
    return model.map(
      game: (game) => GameBlockCard(data: game),
      ad: (ad) => GameAdCard(ad: ad),
    );
  }
}
