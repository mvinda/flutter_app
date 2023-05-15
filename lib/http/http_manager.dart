import 'package:dio/dio.dart';
import 'api.dart';

class HttpManager {
  late Dio _dio;
  static HttpManager? _instance;

  factory HttpManager.getInstance() {
    if (null == _instance) {
      _instance = new HttpManager._internal();
    }
    return _instance!;
  }

  //以 _ 开头的函数、变量无法在库外使用
  HttpManager._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: Api.baseUrl, //基础地址
      connectTimeout: const Duration(seconds: 5), //连接服务器超时时间，单位是毫秒
      receiveTimeout: const Duration(seconds: 3), //读取超时
    );
    _dio = Dio(options);
  }

  request(url, {data, String method = "get"}) async {
    try {
      Options option = Options(method: method);
      Response response = await _dio.request(url, data: data, options: option);
      print(response.headers);
      print(response.data);
      return response.data;
    } catch (e) {
      return null;
    }
  }

  Dio getDio() {
    return _dio;
  }

  post(url,postData) async {
    return await _dio.post(url, data:postData);
  }

  void clearCookie() {
    // _persistCookieJar.deleteAll();
  }
}
