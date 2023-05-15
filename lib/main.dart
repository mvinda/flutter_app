import 'package:app/manager/app_manager.dart';
import 'package:app/ui/widget/main_drawer.dart';
import 'package:flutter/material.dart';
import 'ui/page_article.dart';



void main() => runApp(const ArticleApp());

class ArticleApp extends StatelessWidget {
  const ArticleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppManager.initApp();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            '文章',
            style: TextStyle(color: Colors.white),
          ),
        ),
       drawer: const Drawer(
          child: MainDrawer(),
        ),
        body: const ArticlePage(),
      ),
    );
  }
}
