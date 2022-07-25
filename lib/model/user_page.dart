import 'package:face_detection/model/user_model.dart';

class SearchUserResponse {
  int totalCount;
  List<User> items;
  SearchUserResponse(this.totalCount, this.items);

  SearchUserResponse.fromJson(Map<String, dynamic> searchUserResponse) :
        totalCount = searchUserResponse['totalCount'],
        items = (searchUserResponse['items'] as List).map((e) =>
          User.fromJson(e)).toList();
}