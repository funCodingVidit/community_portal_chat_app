import 'package:chat/chat.dart';
import 'package:community_portal_chat_app/state_management/message/message_bloc.dart';
import 'package:community_portal_chat_app/state_management/receipt/receipt_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';


class FakeReceiptService extends Mock implements IReceiptService {}

void main() {
  ReceiptBloc? sut;
  IReceiptService? receiptService;
  User? user;

  setUp(() {
    receiptService = FakeReceiptService();
    user = User(
      username: 'test',
      photoUrl: '',
      active: true,
      lastseen: DateTime.now()
    );
    sut = ReceiptBloc(receiptService!);
  });

  tearDown(() => sut?.close());

  test('should emit only initial without subscriptions', () {
    expect(sut?.state, ReceiptInitial());
  });

  test('should emit receipt sent state when receipt is sent', () {
    final receipt = Receipt(
      recipient: '123',
      messageId: '456',
      timestamp: DateTime.now(),
      status: ReceiptStatus.delivered,
    );

    when(receiptService?.send(receipt)).thenAnswer((_) async => true);
    sut?.add(ReceiptEvent.onReceiptEvent(receipt));
    expectLater(sut?.stream, emits(ReceiptState.sent(receipt)));
  });

  test('should emit receipts received from the service', () {
    final receipt = Receipt(
      recipient: '123',
      messageId: '456',
      timestamp: DateTime.now(),
      status: ReceiptStatus.delivered,
    );

    when(receiptService?.receipts(user))
    .thenAnswer((_) => Stream.fromIterable([receipt]));

    sut?.add(ReceiptEvent.onSubscribed(user));
    expectLater(sut?.stream, emitsInOrder([ReceiptReceivedSuccess(receipt)]));
  });
}