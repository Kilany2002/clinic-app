class Message {

  final String message;
final String id;
  Message(this.id, {required this.message});
  factory Message.fromJson( json) {
    return Message(json['id'],
      
      message: json['text'],
    );
  }

}