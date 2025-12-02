import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class PlayerBarrageWidget extends StatefulWidget {
  final List<CommentItemModel> dataList;
  final bool isOpen;
  final GlobalKey<BarrageState> globalKey;
  const PlayerBarrageWidget(
      {super.key, this.dataList = const [], this.isOpen = false, required this.globalKey});

  @override
  State createState() => _PlayerBarrageWidgetState();
}

class _PlayerBarrageWidgetState extends State<PlayerBarrageWidget> {
  int mills = 500; // 执行间隔
  int showCount = 2; //显示行数
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.isOpen) startBarrage();
  }

  @override
  void didUpdateWidget(covariant PlayerBarrageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen != oldWidget.isOpen) {
      widget.isOpen ? startBarrage() : _timer?.cancel();
    }
  }

  void startBarrage() {
    if (_timer?.isActive ?? false) return;
    _timer?.cancel(); // cancle
    var destList = widget.dataList.where((e) => (e.comment?.isNotEmpty ?? false)).toList();
    if (destList.isEmpty) return;
    _timer = Timer.periodic(Duration(milliseconds: mills), (timer) {
      if (destList.isEmpty) return timer.cancel();
      widget.globalKey.currentState?.addTask(destList.removeAt(0));
    });
  }

  @override
  Widget build(BuildContext context) {
    // return const SizedBox(width: double.infinity, height: 80);
    var destList = widget.dataList.where((e) => (e.comment?.isNotEmpty ?? false)).toList();
    if (destList.isEmpty || !widget.isOpen) return const SizedBox();
    Widget child = Barrage(key: widget.globalKey, showCount: showCount);
    return SizedBox(width: double.infinity, height: 80, child: child);
  }
}

///
/// des: 弹幕平移
///
class BarrageTransition extends StatefulWidget {
  const BarrageTransition({super.key,
    required this.child,
    required this.duration,
    required this.onComplete,
    this.direction = TransitionDirection.rtl,
  });

  final Widget child;

  ///
  /// 平移时间（秒）
  ///
  final Duration duration;

  ///
  /// 平移方向，默认从左到右
  ///
  final TransitionDirection direction;
  final ValueChanged onComplete;

  getComplete() {}

  @override
  State createState() => BarrageTransitionState();
}

class BarrageTransitionState extends State<BarrageTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  bool get isComplete => _animationController.isCompleted;

  @override
  void initState() {
    _animationController =
        AnimationController(duration: widget.duration, vsync: this)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) widget.onComplete('');
          });
    var begin = const Offset(-1.0, .0);
    var end = const Offset(1.0, .0);
    switch (widget.direction) {
      case TransitionDirection.ltr:
        begin = const Offset(-1.0, .0);
        end = const Offset(1.0, .0);
        break;
      case TransitionDirection.rtl:
        begin = const Offset(1.0, .0);
        end = const Offset(-1.0, .0);
        break;
      case TransitionDirection.ttb:
        begin = const Offset(.0, .0);
        end = const Offset(.0, 2.0);
        break;
      case TransitionDirection.btt:
        begin = const Offset(.0, 2.0);
        end = const Offset(.0, .0);
        break;
    }
    _animation = Tween(begin: begin, end: end).animate(_animationController);
    //开始动画
    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: _animation, child: widget.child);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

enum TransitionDirection {
  ///
  /// 从左到右
  ///
  ltr,

  ///
  /// 从右到左
  ///
  rtl,

  ///
  /// 从上到下
  ///
  ttb,

  ///
  /// 从下到上
  ///
  btt
}

///
/// des:
///
const Duration _kDuration = Duration(seconds: 10);

class Barrage extends StatefulWidget {
  const Barrage({
    super.key,
    this.showCount = 10,
    this.padding = 5,
    this.randomOffset = 0,
  });

  ///
  /// 显示的行数
  ///
  final int showCount;

  ///
  /// 水平弹幕：表示top、bottom的padding
  /// 垂直弹幕：表示left、right的padding
  ///
  final double padding;

  ///
  /// 随机偏移量
  ///
  final int randomOffset;

  @override
  State createState() => BarrageState();
}

class BarrageState extends State<Barrage> {
  ///
  /// 同时执行任务
  ///
  late List<bool> barTask;

  ///
  /// 等待任务列表
  ///
  final List<CommentItemModel> waitTask = [];

  ///
  /// 弹幕列表
  ///
  final List<_BarrageTransitionItem> _barrageList = [];

  ///
  /// 定时清除弹幕
  ///
  Timer? _timer;
  final Random _random = Random();
  double _height = 0;
  int barrageIndex = 0;

  addTask(CommentItemModel item) {
    waitTask.add(item);
    runNextTask();
  }

  runNextTask() {
    if (waitTask.isEmpty) return; // 无任务
    int idx =
        barTask.asMap().keys.firstWhere((i) => !barTask[i], orElse: () => -1);
    if (idx == -1) return; // 无空闲线路执行任务

    var task = waitTask.first;
    waitTask.remove(task);
    if (task.comment?.isNotEmpty ?? false) {
      var child = initTaskWidget(idx, task.comment ?? '');
      barTask[idx] = true; //
      if (mounted) setState(() => _barrageList.add(child));
    }
  }

  // ignore: library_private_types_in_public_api
  _BarrageTransitionItem initTaskWidget(int idx, String text,
      {Duration duration = _kDuration}) {
    double perRowHeight = (_height - 2 * widget.padding) / widget.showCount;
    var top = _computeTop(idx, perRowHeight);
    var bottom = _height - top - perRowHeight;
    Widget child = BarrageStyle.normal(text);
    return _BarrageTransitionItem(
      id: idx.toString(),
      top: top,
      bottom: bottom,
      onComplete: _onComplete,
      duration: duration,
      child: child,
    );
  }

  ///
  /// 添加弹幕
  ///
  addBarrage(Widget child, {Duration duration = _kDuration}) {
    double perRowHeight = (_height - 2 * widget.padding) / widget.showCount;
    // 计算距离顶部的偏移，
    // 不直接使用_barrageList.length的原因：弹幕结束会删除列表中此项，如果
    // 此时正好有一个弹幕来，会造成此弹幕和上一个弹幕同行
    var index = 0;
    if (_barrageList.isEmpty) {
      //屏幕中没有弹幕，从顶部开始
      index = 0;
      barrageIndex++;
    } else {
      index = barrageIndex++;
    }
    var top = _computeTop(index, perRowHeight);
    if (barrageIndex > 100000) {
      // 避免弹幕数量一直累加超过int的最大值
      barrageIndex = 0;
    }
    var bottom = _height - top - perRowHeight;
    //给每一项生成一个唯一id，用于删除
    String id = '${DateTime.now().toIso8601String()}:${_random.nextInt(1000)}';
    var item = _BarrageTransitionItem(
      id: id,
      top: top,
      bottom: bottom,
      onComplete: _onComplete,
      duration: duration,
      child: child,
    );
    _barrageList.add(item);
    if (mounted) setState(() {});
  }

  ///
  /// 动画执行完毕删除
  ///
  _onComplete(id) {
    _barrageList.removeWhere((f) => f.id == id);
    int? idx = int.tryParse(id.toString());
    if (idx != null) {
      barTask[idx] = false;
      runNextTask();
    } else {
      debugPrint('barrage error ---> $id');
      runNextTask();
    }
  }

  @override
  void initState() {
    super.initState();
    // 最大执行任务
    barTask = List.filled(widget.showCount * 2 - 1, false);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraintType) {
        // _width = constraintType.maxWidth;
        _height = constraintType.maxHeight;

        return ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: Stack(children: [..._barrageList]),
        );
      },
    );
  }

  _computeTop(int index, double perRowHeight) {
    int idx = index % (widget.showCount * 2 - 1); // -1 防越界
    // 基数轮 弹幕
    double top = (idx % widget.showCount) * perRowHeight + widget.padding;
    // 偶数轮 弹幕
    top = top + (idx / widget.showCount).floor() * perRowHeight / 2;
    // 浮点数 弹幕 未调整(三方)
    if (widget.randomOffset != 0 && top > widget.randomOffset) {
      top += _random.nextInt(widget.randomOffset) * 2 - widget.randomOffset;
    }
    return top;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _barrageList.clear();
    super.dispose();
  }
}

class _BarrageTransitionItem extends StatelessWidget {
  _BarrageTransitionItem({
    this.id,
    this.top,
    this.bottom,
    required this.child,
    this.onComplete,
    required this.duration,
  });

  final String? id;
  final double? top;
  final double? bottom;
  final Widget child;
  final ValueChanged? onComplete;
  final Duration duration;
  final _key = GlobalKey<BarrageTransitionState>();

  bool get isComplete => _key.currentState?.isComplete ?? true;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      top: top,
      bottom: bottom,
      child: BarrageTransition(
        key: _key,
        onComplete: (v) => onComplete?.call(id),
        duration: duration,
        child: child,
      ),
    );
  }
}

///
/// des: 弹幕样式
///
class BarrageStyle {
  static Widget normal(String text) {
    return Text(text, style: const TextStyle(color: Colors.white, fontSize: 16));
  }

  static Widget level_1(String text) {
    return Text(
      text,
      style: const TextStyle(color: Color(0xFFE9A33A)),
    );
  }

  static Widget level_2(String text) {
    return Center(
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(.8),
          borderRadius: BorderRadius.circular(50),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  static Widget level_3(String text, int count) {
    return Center(
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(.8),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
          // Image.asset('assets/images/timg.jpeg',height: 30,width: 30,),
          Text(
            'x $count',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ]),
      ),
    );
  }
}

class CommentItemModel {
  String? comment;
  CommentItemModel({
    this.comment,
  });
}