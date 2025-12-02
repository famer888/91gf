import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../notifiers/user_notifier.dart';

class RefreshByMemberChangedWrapper extends StatelessWidget {
  const RefreshByMemberChangedWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final uuid = context
        .select<UserNotifier, String>((value) => value.member.uuid ?? '');
    return SizedBox(
      key: ValueKey(uuid),
      child: child,
    );
  }
}
