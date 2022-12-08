import 'package:chat/src/models/typing_event.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/receipt/typing/typing_notification_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

import 'helpers.dart';

void main() {
  Connection? connection;
  RethinkDb r = RethinkDb();
  TypingNotificationService? sut;

  setUp(() async {
    connection = await r.connect(host: 'localhost', port: 28015);
    await createDb(r, connection!);
    sut = TypingNotificationService(r, connection!);
  });

  tearDown(() async {
    sut?.dispose();
    await cleanDb(r, connection!);
  });

  final user = User.fromJson({
    'id': '1234',
    'active': true,
    'lastSeen': DateTime.now(),
  });

  final user2 = User.fromJson({
    'id': '1111',
    'active': true,
    'lastSeen': DateTime.now(),
  });

  test('sent typing notification successfully', () async {
    TypingEvent typingEvent = TypingEvent(from: user2.id, to: user.id, event: Typing.start);

    final res = await sut?.send(event: typingEvent, to: user);
    expect(res, true);
  });

  test('successfully subscribe and receive events', () async {
    sut?.subscribe(user2, [user.id!]).listen(expectAsync1((event) {
          expect(event.from, user.id);
        }, count: 2));

    TypingEvent typing = TypingEvent(
        to: user2.id,
        from: user.id,
        event: Typing.start,
    );

    TypingEvent stopTyping = TypingEvent(
        to: user2.id,
        from: user.id,
        event: Typing.stop,
    );

    await sut?.send(event: typing, to: user2);
    await sut?.send(event: stopTyping, to: user2);
  });
}