import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:githubapp/models/repos_model.dart';
import 'package:githubapp/modules/settings_screen.dart';
import 'package:githubapp/modules/trending_screen.dart';
import 'package:githubapp/shared/cubit/states.dart';
import 'package:githubapp/shared/network/dio_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialAppStates());

  static AppCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = [TrendingScreen(), SettingsScreen()];
  int currentIndex = 0;

  void changeBottomNav(index) {
    currentIndex = index;
    emit(ChangeBottomNavState());
  }

  ReposModel model;
  void getRepos() {
    emit(GetReposLoadingState());
    DioHelper.getData(url: "search/repositories", query: {
      "q": "created:>2017-10-22",
      "sort": "stars",
      "order": "desc",
    }).then((value) {
      model = ReposModel.fromJson(value.data);
      emit(GetReposSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetReposErrorState());
    });
  }
}
