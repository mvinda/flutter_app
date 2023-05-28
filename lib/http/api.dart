import 'http_manager.dart';

typedef void OnResult(Map<String, dynamic> data);

class Api {
  static const String baseUrl = "https://www.wanandroid.com/";

  //首页文章列表 http://www.wanandroid.com/article/list/0/json
  static const String ARTICLE_LIST = "article/list/";

  static const String BANNER = "banner/json";

  //登录
  static const String LOGIN = 'user/login';

  //注册
  static const String REGISTER = "user/register";

  //退出
  static const String LOGOUT = "user/logout/json";

  //收藏
  static const String COLLECT = "lg/collect/list/";

  static const String COLLECT_ARTICLE_LIST = "lg/collect/list/";
  static const String COLLECT_WEBSITE_LIST = "lg/collect/usertools/json";

  static const String UNCOLLECT_INTERNAL_ARTICLE = "lg/uncollect_originId/";

  static const String COLLECT_INTERNAL_ARTICLE = "lg/collect/";

  static const String COLLECT_WEBSITE = "lg/collect/addtool/json";

  static getArticleList(int page) async {
    return HttpManager.getInstance().request('$ARTICLE_LIST$page/json');
  }

  static getBanner() async {
    return await HttpManager.getInstance().request(BANNER);
  }

  static clearCookie() {
    HttpManager.getInstance().clearCookie();
  }

  static login(String username, String password) async {
    var response = await HttpManager.getInstance().getDio().post(LOGIN,
        queryParameters: {'username': username, 'password': password});
    return response;
  }

  static register(String username, String password) async {
    ///必须使用form表单提交

    var response = await HttpManager.getInstance().getDio().post(REGISTER,
        queryParameters: {
          "username": username,
          "password": password,
          "repassword": password
        });
    print(response);
    return response;
  }

  static getCollects(int page) async {
    return await HttpManager.getInstance().request("$COLLECT/$page/json");
  }

  static getWebSiteCollects() async {
    return await HttpManager.getInstance().request(COLLECT_WEBSITE_LIST);
  }

  static getArticleCollects(int page) async {
    return await HttpManager.getInstance()
        .request("$COLLECT_ARTICLE_LIST/$page/json");
  }

  static unCollectWebsite(int id) async {
    var response = await HttpManager.getInstance()
        .getDio()
        .post(REGISTER, queryParameters: {"id": id});
    return response;
  }

  static unCollectArticle(int id) async {
    return await HttpManager.getInstance()
        .getDio()
        .post("$UNCOLLECT_INTERNAL_ARTICLE$id/json", queryParameters: {});
  }

  static collectArticle(int id) async {
    return await HttpManager.getInstance()
        .getDio()
        .post("$COLLECT_INTERNAL_ARTICLE$id/json", queryParameters: {});
  }

  static collectWebsite(String name, String link) async {
    return await HttpManager.getInstance()
        .getDio()
        .post(COLLECT_WEBSITE, queryParameters: {
      "name": name,
      "link": link,
    });
  }
}
