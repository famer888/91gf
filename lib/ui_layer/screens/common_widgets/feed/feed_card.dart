import 'package:flutter/widgets.dart';

import '../../../../domain/model/feed/feed_model.dart';
import 'card/ad_card.dart';
import 'card/video_card.dart';

class FeedCard extends StatelessWidget {
  const FeedCard({super.key, required this.feed});
  static const aspectRatio = 163 / 158;
  final FeedModel feed;
  @override
  Widget build(BuildContext context) {
    return feed.map(
      video: (video) => VideoCard(data: video),
      ad: (ad) => AdCard(ad: ad),
    );
  }
}
