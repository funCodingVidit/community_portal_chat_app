import 'package:chat/chat.dart';

class LocalMessage {
  String? chatId;
  String? get id => _id;
  String? _id;
  Message? message;
  ReceiptStatus? receipt;

  LocalMessage(this.chatId, this.message, this.receipt);

  Map<String, dynamic> toMap() => {
        'chat_id': chatId,
        'id': message?.id,
        ...message?.toJson(),
        'receipt': receipt?.value()
      };

  factory LocalMessage.fromMap(Map<String, dynamic> json) {
    final message = Message(
        from: json['from'],
        to: json['to'],
        timestamp: json['timestamp'],
        contents: json['contents']);

    final localMessage =
        LocalMessage(json['chat_id'], message, json['receipt']);
    localMessage._id = json['id'];

    return localMessage;
  }
}
