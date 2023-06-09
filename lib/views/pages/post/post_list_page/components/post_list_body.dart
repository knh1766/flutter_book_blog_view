import 'package:flutter/material.dart';
import 'package:flutter_blog_2/views/pages/post/post_list_page/components/post_list_item.dart';

class PostListBody extends StatelessWidget {
  const PostListBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListView.separated(
      itemCount: 5,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
          },
          child: PostListItem(),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
    );
  }
}
