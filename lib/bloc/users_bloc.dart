import 'package:bloc/bloc.dart';
import 'package:face_detection/repository/users_repository.dart';

import '../model/user_model.dart';
import '../model/user_page.dart';

abstract class UsersEvent {}

class SearchUsersEvent extends UsersEvent {
  final String query;
  SearchUsersEvent(this.query);
}

class NextUsersPageEvent extends UsersEvent {

}

enum StateStatus {
  success,
  error,
  loading,
  none
}
abstract class UsersState {}
class SearchUsersSuccessState extends UsersState {
  List<User> users = [];
  SearchUsersSuccessState({required this.users});
}
class SearchUsersErrorState extends UsersState {
  late String errorMessage;
  SearchUsersErrorState({required this.errorMessage});
}

class SearchUsersLoadingState extends UsersState {

}

class UserBloc extends Bloc<UsersEvent, UsersState> {
  final UsersRepository usersRepository = UsersRepository();
  late UsersEvent lastEvent;
  int currentPage = 0;
  int totalPages = 0;
  int pageSize = 10;
  String currentQuery="";
  List<User> users = [];
  UserBloc() : super(SearchUsersSuccessState(users: [])){
    on((SearchUsersEvent event, emit) async {
      try {
        currentPage = 0;
        currentQuery = event.query;
        users = [];
        lastEvent = event;
        emit(SearchUsersLoadingState());
        SearchUserResponse response = await usersRepository.searchUsers(currentQuery, currentPage, pageSize);
        totalPages=(response.totalCount/pageSize).floor();
        users.addAll(response.items);
        if(response.totalCount % pageSize != 0) ++totalPages;
        emit(SearchUsersSuccessState(users: users));
      }
      catch (ex){
        SearchUsersErrorState(errorMessage: ex.toString());
      }
    });
    on((NextUsersPageEvent event, emit) async {
      try {
        if(currentPage>=totalPages-1) return;
        lastEvent=event;
        SearchUserResponse response = await usersRepository.searchUsers(currentQuery, ++currentPage, pageSize);
        totalPages=(response.totalCount/pageSize).floor();
        users.addAll(response.items);
        if(response.totalCount % pageSize != 0) ++totalPages;
        emit(SearchUsersSuccessState(users: users));
      }
      catch (ex) {
        --currentPage;
        emit(SearchUsersErrorState(errorMessage: ex.toString()));
      }
    });
  }

}

