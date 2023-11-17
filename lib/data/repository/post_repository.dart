//v->p(전역 프로바이더,뷰모델)->r
import 'package:dio/dio.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';

import '../../_core/constants/http.dart';
import '../model/post.dart';

class PostRepository {
  Future<ResponseDTO> fetchPostList(String jwt) async {
    try {
      //1.통신
      final response = await dio.get("/post",
          options: Options(headers: {"Authorization": "${jwt}"}));
      //2.responseDTO파싱
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      //responseDTO.data = User.fromJson(responseDTO.data);

      //3.responseDTO파싱의 data파싱
      List<dynamic> mapList = responseDTO.data as List<dynamic>;
      List<dynamic> postList = mapList.map((e) => Post.fromJson(e)).toList();

      responseDTO.data = postList;
      return responseDTO;
    } catch (e) {
      //200이 아니면 catch로 감
      return ResponseDTO(-1, "중복되는 유저명입니다", null);
    }
  }
}
