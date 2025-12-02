import 'package:flutter/material.dart';
import 'package:jygf/domain/model/cartoon/cartoon_section_model.dart';
import 'package:jygf/ui_layer/screens/common_widgets/cartoon/card/video_block_card.dart';
import 'card/ad_card.dart';

class CartoonSectionCard extends StatelessWidget {
  const CartoonSectionCard({super.key, required this.model});
  final CartoonSectionModel model;
  @override
  Widget build(BuildContext context) {
    return model.map(
      video: (video) => CartoonVideoBlockCard(data: video),
      ad: (ad) => CartoonAdCard(ad: ad),
    );
  }
}
