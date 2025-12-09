import 'package:event_bus/event_bus.dart';

final EventBus eventBus = EventBus();

class MyEvent {
  final String message;
  final Map? param;
  MyEvent(this.message, {this.param});
}