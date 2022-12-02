import 'dart:async';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

import 'dio_protocol.dart';

enum RequestType { get, post, formData, put }

/// 未知错误
const int unknownErrorCode = -100000;
const String unknownErrorMsg = "request failed";

/// 自定义Dio错误码
Map<DioErrorType, int> dioErrorCode = {
  DioErrorType.connectTimeout: -5,
  DioErrorType.receiveTimeout: -6,
  DioErrorType.sendTimeout: -7,
  DioErrorType.cancel: -8,
};

Map<DioErrorType, String> dioErrorMsg = {
  DioErrorType.other: "connection failed",
  DioErrorType.connectTimeout: "connection timeout",
  DioErrorType.receiveTimeout: "receive a timeout",
  DioErrorType.sendTimeout: "send timeout",
  DioErrorType.cancel: "the request to cancel",
  DioErrorType.response: "server response, but with a incorrect status,",
};

const int _kReceiveTimeout = 30000;
const int _kConnectTimeout = 30000;
const int _kSendTimeout = 30000;

class WDError {
  bool hasErrResponse;
  Response? errResponse;
  int errorCode;
  String errorMsg;

  WDError(
      {this.hasErrResponse = false,
      this.errResponse,
      this.errorCode = unknownErrorCode,
      this.errorMsg = unknownErrorMsg});
}

class BaseHttp with DioProtocol {
  factory BaseHttp() => _getInstance();
  static BaseHttp? _instance;

  static BaseHttp get instance => _getInstance();

  static BaseHttp _getInstance() {
    _instance ??= BaseHttp._internal();
    return _instance!;
  }

  Future init() async {
    if (dio.httpClientAdapter is DefaultHttpClientAdapter) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        /// 全局信任https证书
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      };
    }
    return null;
  }

  BaseHttp._internal() {
    dio = Dio(
      BaseOptions(
        connectTimeout: _kConnectTimeout,
        receiveTimeout: _kReceiveTimeout,
        sendTimeout: _kSendTimeout,
        responseType: ResponseType.json,
        headers: baseHeader,
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
      ),
    );
  }

  static Map<String, dynamic> baseHeader = {
    "content-type": "application/json;charset=UTF-8",
    "accept": "*/*",
  };

  Future<dynamic> open(String path,
      {RequestType method = RequestType.get,
      Map<String, dynamic>? arguments,
      CancelToken? cancelToken,
      FormData? formData,
      Map<String, dynamic>? headers}) async {
    dynamic result;
    try {
      if (method == RequestType.get) {
        result = await get(
          path,
          arguments: arguments,
          cancelToken: cancelToken,
          headers: headers,
        );
      } else if (method == RequestType.post) {
        result = await post(
          path,
          arguments: arguments,
          formData: formData,
          cancelToken: cancelToken,
          headers: headers,
        );
      }
    } catch (e) {
      WDError error =
          WDError(errorCode: unknownErrorCode, errorMsg: unknownErrorMsg);
      if (e is DioError) {
        if (e.type == DioErrorType.response) {
          /// 若后台有自定义code, 可优先解析e.response.data获取相关错误信息
          if (null != e.response?.data) {
            error.hasErrResponse = true;
            error.errResponse = e.response!;
          }
          if (null != e.response?.statusCode) {
            error.errorCode = e.response!.statusCode!;
          }
          if (null != e.response?.statusMessage) {
            error.errorMsg = e.response!.statusMessage!;
          } else {
            error.errorMsg = dioErrorMsg[e.type]!;
          }
        } else if (e.type == DioErrorType.other) {
          if (null != e.error) {
            error.errorMsg = e.error.toString();
          }
        } else {
          error.errorCode = dioErrorCode[e.type]!;
          error.errorMsg = dioErrorMsg[e.type]!;
        }
      }
      result = error;
    }
    return result;
  }

  void parseErrorFromResponse(Response response) {}

  void configBaseUrl(String baseUrl) {
    dio.options.baseUrl = baseUrl;
  }

  void configHeader(Map<String, dynamic> header) {
    if (header.length <= 0) return;
    dio.options.headers.addAll(header);
  }
}
