import 'package:flutter/widgets.dart';
import 'package:jygf/domain/model/chat/chat_list_model.dart';
import 'package:jygf/domain/model/home_data_model.dart';
import 'package:jygf/ui_layer/screens/common_widgets/chat/list_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/ad_view.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({super.key, required this.data});
  static const aspectRatio = 163 / 128;
  final ChatListModel data;
  
  @override
  Widget build(BuildContext context) {
    return data.map(
      chat: (chat) => ChatListCard(data: chat),
      ad: (ad) => AdCardView(ad: AdModel.fromJson(ad.toJson())),
    );
  }
}
