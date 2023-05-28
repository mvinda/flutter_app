import 'package:app/http/api.dart';
import 'package:app/ui/page/page_collect_article.dart';
import 'package:app/ui/page/page_collect_website.dart';
import 'package:flutter/material.dart';

class CollectPage extends StatefulWidget {
  const CollectPage({Key? key}) : super(key: key);

  @override
  State<CollectPage> createState() => _CollectPageState();
}

class _CollectPageState extends State<CollectPage> {
  final tabs = ["文章", "网站"];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("我的收藏"),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  Icons.article,
                  size: 32.0,
                ),
              ),
              Tab(
                icon: Icon(Icons.web, size: 32.0),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            ArticleCollectPage(),
            WebsiteCollectPage(),
          ],
        ),
      ),
    );
  }
}
