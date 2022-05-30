import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

const storage = FlutterSecureStorage();
Dio dio = Dio();

setAuthToken(token) {
  if (token) {
    dio.options.headers["Authorization"] = "Bearer " + token;
  } else {
    !dio.options.headers["Authorization"];
  }
}
checkTokenValidity(token) {
  // Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
  final decodedToken = JwtDecoder.decode(token);

   if (decodedToken != DateTime.now()) {
    token = null;
    storage.delete(key: 'token');
  }

  setAuthToken(token);
  // ignore: void_checks
  return token;
}

// void storeToken() async {
//   await storage.write(key: "token", value: getToken());
// }

// getToken() async {
  
//   return await storage.read(key: "token");
  
// }

// class Api {
//   Dio api = Dio();
//   String? token;

//   final _storage = const FlutterSecureStorage();

//   Api() {
//     api.interceptors
//         .add(QueuedInterceptorsWrapper(onRequest: (options, handler) async {
//       if (!options.path.contains('http')) {
//         options.path = 'http://192.168.100.204:8080' + options.path;
//       }
//       options.headers['Authorization'] = "Bearer " + token!;
//       return handler.next(options);
//     }, onError: (DioError error, handler) async {
//       if ((error.response?.statusCode == 401 &&
//           error.response?.data['message'] == "Invalid JWT")) {
//         if (await _storage.containsKey(key: 'refreshToken')) {
//           await refreshToken();
//           // return handler.resolve(await _retry(error.requestOptions));
//         }
//       }
//       return handler.next(error);
//     }));
//   }

//   // Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
//   //   final options = Options(
//   //     method: requestOptions.method,
//   //     headers: requestOptions.headers,
//   //   );
//   //   return api.request<dynamic>(requestOptions.path,
//   //       data: requestOptions.data,
//   //       queryParameters: requestOptions.queryParameters,
//   //       options: options);
//   // }

//   Future<void> refreshToken() async {
//     final refreshToken = await _storage.read(key: 'refreshToken');
//     final response =
//         await api.post('/auth/refresh', data: {'refreshToken': refreshToken});

//     if (response.statusCode == 201) {
//       token = response.data;
//     } else {
//       token = null;
//       _storage.deleteAll();
//     }
//   }
// }
