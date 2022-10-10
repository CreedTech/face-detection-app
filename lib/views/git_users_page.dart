import 'package:face_detection/views/repositories_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../bloc/users_bloc.dart';

class GitUsersPage extends StatelessWidget {
  const GitUsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = context.read<UserBloc>();
    TextEditingController _textEditingController = TextEditingController();
    _textEditingController.text = userBloc.currentQuery;
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<UserBloc, UsersState>(
          builder: (context, state) {
            return Text(
                "Git Users (${userBloc.currentPage + 1}/${userBloc.totalPages})");
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 2, 10, 10),
                      // suffixIcon: Icon(Icons.visibility),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context
                        .read<UserBloc>()
                        .add(SearchUsersEvent(_textEditingController.text));
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<UserBloc, UsersState>(builder: (context, state) {
              return Builder(
                builder: (context) {
                  if (state is SearchUsersLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is SearchUsersErrorState) {
                    return Center(
                      child: Column(
                        children: [
                          Text(state.errorMessage),
                          ElevatedButton(
                            onPressed: () {
                              userBloc.add(userBloc.lastEvent);
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else if (state is SearchUsersSuccessState) {
                    return LazyLoadScrollView(
                      child: ListView.separated(
                        // controller: scrollController,
                        itemBuilder: (_, index) =>
                            // index>=state.users.length?CircularProgressIndicator():
                            ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GitRepositoriesPage(
                                          user: state.users[index].login,
                                        )));
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    child: CircleAvatar(
                                      radius: 28,
                                      backgroundImage: NetworkImage(
                                          state.users[index].avatarUrl),
                                    ),
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(state.users[index].login),
                                ],
                              ),
                              CircleAvatar(
                                child: Text("${state.users[index].score}"),
                              ),
                            ],
                          ),
                        ),
                        separatorBuilder: (_, __) {
                          return const Divider(
                            height: 1,
                            color: Colors.black38,
                          );
                        },
                        itemCount: state.users.length,
                      ),
                      onEndOfPage: () {
                        userBloc.add(NextUsersPageEvent());
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
