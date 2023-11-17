//v->p(전역 프로바이더,뷰모델)->r
import 'package:flutter_blog/data/dto/response_dto.dart';

import '../../_core/constants/http.dart';
import '../dto/user_request.dart';
import '../model/user.dart';

class UserRepository {
  Future<ResponseDTO> fetchJoin(JoinReqDTO requestDTO) async {
    try {
      final response = await dio.post("/join", data: requestDTO.toJson());
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      responseDTO.data = User.fromJson(responseDTO.data);
      return responseDTO;
    } catch (e) {
      //200이 아니면 catch로 감
      return ResponseDTO(-1, "중복되는 유저명입니다", null);
    }
  }

  Future<ResponseDTO> fetchLogin(LoginReqDTO requestDTO) async {
    // Dio 는 내부적으로 터질수 있기때문에 TryCatch로 묶어야 한다. - 통신 실패 때문임
    try {
      final response = await dio.post(
        "/Login",
        data: requestDTO.toJson(),
      );
      // response => header + body [json]
      // response.data - body

      // 2. DTO 파싱
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      responseDTO.data = User.fromJson(responseDTO.data);

      // 3. 토큰 받기
      final authorization = response.headers["authorization"];
      if (authorization != null) {
        responseDTO.token = authorization.first;
      }
      return responseDTO;
    } catch (e) {
      // 200이 아니면 catch로 감
      return ResponseDTO(-1, "유저네임 혹은 비밀번호가 틀렸습니다.", null);
    }
  }
}
