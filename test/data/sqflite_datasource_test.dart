import 'package:chat/chat.dart';
import 'package:community_portal_chat_app/data/datasource/sqflite_datasource.dart';
import 'package:community_portal_chat_app/models/chat.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqlite_api.dart';

class MockSqfliteDatabase extends Mock implements Database {}

class MockBatch extends Mock implements Batch {}

void main() {

  SqfliteDatasource? sut;
  MockSqfliteDatabase? database;
  MockBatch batch;

  setUp(() {
    database = MockSqfliteDatabase();
    batch = MockBatch();
    sut = SqfliteDatasource(database!);
  });

  final message = Message.fromJson({
    'from': '1111',
    'to': '222',
    'contents': 'hey',
    'timestamp': DateTime.parse('2022-12-09'),
    'id': '4444'
  });

  test('should perform insert of chat to the database', () async {
    //arrange
    final chat = Chat('1234');
    when(database?.insert('chats', chat.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .thenAnswer((_) async => 1);

    //act
    await sut?.addChat(chat);

    //assert
    verify(database?.insert('chats', chat.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .called(1);
  });
}
