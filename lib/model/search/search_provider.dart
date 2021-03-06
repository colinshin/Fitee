
import 'package:fitee/config/config.dart';
import 'package:fitee/model/search/search_repos.dart';
import 'package:fitee/model/user/user.dart';
import 'package:fitee/services/search_services.dart';
import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {

  String keyTxt;

  String reposStatus = AppConfig.NORMAL_STATE;
  String userStatus = AppConfig.NORMAL_STATE;

  bool loading = true;
  List<SearchRepos> reposResult;
  List<User> userResult;

  int currentReposPage = 1;
  int currentUserPage = 1;

  setKeyTxt({@required String keyTxt}) async {
    this.keyTxt = keyTxt;
    reposResult = new List<SearchRepos>();
    await fetchRepos();
    userResult = new List<User>();
    await fetchUsers();
    loading = false;
    notifyListeners();
  }

  setReposPage({int page = 1}) async{
    if(page == 1) {
      reposStatus = AppConfig.NORMAL_STATE;
    }
    currentReposPage = page;
    await fetchRepos();
    loading = false;
    notifyListeners();
  }

  fetchRepos({String language, String sort, int page}) async {
    try {
      List<SearchRepos> res = await SearchApi.fetchRepos(keyTxt, page: page ?? currentReposPage, language: language, sort: sort);
      if (currentReposPage == 1) {
        reposResult = res;
      } else {
        reposResult.addAll(res);
      }
      if(reposResult.length == 0){
        reposStatus = AppConfig.EMPTY_STATE;
      }else {
        if(res.length == 0){
          reposStatus = AppConfig.NO_MORE_STATE;
        }
      }
    } catch (e) {
      reposResult = new List<SearchRepos>();
      reposStatus = AppConfig.ERROR_STATE;
      print(e.toString());
    }
    notifyListeners();
    return reposResult;
  }


  setUsersPage({int page = 1}) async{
    if(page == 1) {
      userStatus = AppConfig.NORMAL_STATE;
    }
    currentUserPage = page;
    await fetchUsers();
    loading = false;
    notifyListeners();
  }

  fetchUsers() async {
    try {
      List<User> res = await SearchApi.fetchUsers(keyTxt, page: currentUserPage);
      if (currentUserPage == 1) {
        userResult = res;
      } else {
        userResult.addAll(res);
      }
      if(userResult.length == 0){
        userStatus = AppConfig.EMPTY_STATE;
      }else {
        if(res.length == 0){
          userStatus = AppConfig.NO_MORE_STATE;
        }
      }
    } catch (e) {
      userResult = new List<User>();
      userStatus = AppConfig.ERROR_STATE;
      print(e.toString());
    }
    notifyListeners();
    return userResult;
  }
}