
class MessageModel {
  String type;
  String message;
  String time;
  String path;
  String URL;
  MessageModel(
      {
        required this.message,
        required this.type,
        required this.time,
        required this.path,
        required this.URL
      });


  // Phương thức chuyển đối tượng thành Map để mã hóa thành JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'type': type,
      'time': time,
    };
  }

  // Phương thức chuyển từ JSON thành đối tượng MessageModel
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      message: json['message'],
      type: json['type'],
      time: json['time'],
      path: json['path'],
      URL: json['image']
    );
  }
}