import 'package:app/http/api.dart';
import 'package:flutter/material.dart';

class CollectPage extends StatefulWidget {
  const CollectPage({Key? key}) : super(key: key);

  @override
  State<CollectPage> createState() => _CollectPageState();
}

class _CollectPageState extends State<CollectPage> {
  final int _curPage = 0;
  bool _isHidden = false;

  late List _collects;

  @override
  void initState() {
    super.initState();
    _getCollects();
  }

  void _getCollects() async {
    var data = await Api.getCollects(_curPage);
    _isHidden = true;
    _collects = data['datas'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("我的收藏"),
      ),
      body: Stack(
        children: <Widget>[
          Offstage(
            offstage: _isHidden,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          Offstage(
            offstage: _collects?.isNotEmpty ?? !_isHidden,
            child: const Center(
              child: Text("(＞﹏＜) 你还没有收藏任何内容......"),
            ),
          )
        ],
      ),
    );
  }
}
