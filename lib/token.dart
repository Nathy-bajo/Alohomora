import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

const storage = FlutterSecureStorage();
Dio dio = Dio();

setAuthToken(token) {
  print(token + "toks");
  if (token.toString().length > 1) {
    dio.options.headers["Authorization"] = "Bearer: " + token;
  } else {
    !dio.options.headers["Authorization"];
  }
}

checkTokenValidity(token) {
  final exp = JwtDecoder.decode(token);

  if (exp != DateTime.now()) {
    token = "";
    storage.delete(key: "token");
  }

  setAuthToken(token);
  return token;
}

