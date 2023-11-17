import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/_core/constants/move.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/dto/user_request.dart';
import 'package:flutter_blog/data/model/user.dart';
import 'package:flutter_blog/data/repository/user_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. 창고 데이터
class SessionUser {
  // 1-1. 화면 context에 접근하는 방법 (근거: main에서 전역적으로 선언)
  final mContext = navigatorKey.currentContext;

  User? user; // 로그인을 안했을 때 null
  String? jwt; // 로그인을 안했을 때 null
  bool isLogin; //isLogin으로 로그인 체크(유효한 토큰)

  SessionUser({this.user, this.jwt, this.isLogin = false});

  Future<void> join(JoinReqDTO joinReqDTO) async {
    // 1. 통신코드
    ResponseDTO responseDTO = await UserRepository().fetchJoin(joinReqDTO);

    // 2. 비즈니스 로직
    if (responseDTO.code == 1) {
      Navigator.pushNamed(mContext!, Move.loginPage);
    } else {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(
          content: Text(responseDTO.msg),
        ),
      );
    }
  }

  Future<void> login(LoginReqDTO loginReqDTO) async {
    // 1. 통신코드
    ResponseDTO responseDTO = await UserRepository().fetchLogin(loginReqDTO);

    // 2. 비즈니스 로직
    if (responseDTO.code == 1) {
      // 2-1. 세션값 갱신
      this.user = responseDTO.data as User;
      this.jwt = responseDTO.token;
      this.isLogin = true;

      // 2-2. 디바이스에 JWT 저장
      await secureStorage.write(key: "jwt", value: responseDTO.token);

      Navigator.pushNamed(mContext!, Move.postListPage);
    } else {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(
          content: Text(responseDTO.msg),
        ),
      );
    }
  }

  Future<void> logout() async {
    // 1. 통신코드

    // 2. 비즈니스 로직
  }
}

// 2. 창고 관리자
final sessionProvider = Provider<SessionUser>((ref) {
  return SessionUser();
});
