class Conversation {
  final String id;
  final List<dynamic> users;
  final dynamic createdAt;
  final Map<String, dynamic> userDataMap;

  Conversation({this.id, this.users, this.createdAt, this.userDataMap});
}