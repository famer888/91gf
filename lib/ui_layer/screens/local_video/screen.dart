import 'package:flutter/material.dart';

import '../../../domain/model/video_detail_model.dart';
import '../common_widgets/video_player/shortv_mv_player.dart';

class LocalVideoScreen extends StatefulWidget {
  const LocalVideoScreen({super.key, required this.data});

  final VideoData data;

  @override
  State<LocalVideoScreen> createState() => _LocalVideoScreenState();
}

class _LocalVideoScreenState extends State<LocalVideoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            //预留状态栏
            height: MediaQuery.of(context).padding.top,
            color: Colors.black,
          ),
          Expanded(
            child: Container(
              color: Colors.black45,
              child: ShortvMvPlayer(
                info: widget.data,
                needCheckAspectRatio: true,
                isLocal: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
