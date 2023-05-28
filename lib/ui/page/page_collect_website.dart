import 'package:flutter/material.dart';
import 'package:app/http/api.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:toast/toast.dart';
import 'package:app/ui/page/website_add_page.dart';

class WebsiteCollectPage extends StatefulWidget {
  const WebsiteCollectPage({Key? key}) : super(key: key);

  @override
  State<WebsiteCollectPage> createState() => _WebsiteCollectPageState();
}

class _WebsiteCollectPageState extends State<WebsiteCollectPage>
    with AutomaticKeepAliveClientMixin {
  bool _isHidden = false;

  List _collects = [];

  @override
  void initState() {
    super.initState();
    _getCollects();
  }

  _getCollects() async {
    var result = await Api.getWebSiteCollects();
    if (result != null) {
      var data = result['data'];
      _collects.clear();
      _collects.addAll(data);
      _isHidden = true;
      setState(() {});
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Offstage(
          offstage: _isHidden,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        Offstage(
          ///不为空就隐藏
          offstage: _collects.isNotEmpty || !_isHidden,
          child: const Center(
            child: Text("(＞﹏＜) 你还没有收藏任何内容......"),
          ),
        ),
        Offstage(
            //為空就隱藏
            offstage: _collects.isEmpty,
            child: RefreshIndicator(
              onRefresh: () => _getCollects(),
              child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(22.0),
                  itemBuilder: (context, i) => _buildItem(context, i),
                  separatorBuilder: (context, i) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Divider(color: Colors.grey),
                    );
                  },
                  itemCount: _collects.length),
            )),

        /// 定位
        Positioned(
          bottom: 18.0,
          right: 18.0,
          //悬浮按钮
          child: FloatingActionButton(
            onPressed: _addCollect,
            child: const Icon(Icons.add),
          ),
        )
      ],
    );
  }

  _addCollect() async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (_) => const WebsiteAddPage()));
    if (result != null) {
      _collects.add(result);
    }
  }

  _buildItem(BuildContext context, int i) {
    var item = _collects[i];

    ///侧滑删除
    return Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              // An action can be bigger than the others.
              flex: 2,
              onPressed: (BuildContext context) => {
                _delCollect(item),
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.red,
              icon: Icons.delete,
              label: 'Archive',
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(item['name'], style: const TextStyle(fontSize: 22.0)),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                item['link'],
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ));
  }

  _delCollect(item) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    var result = await Api.unCollectWebsite(item['id']);
    Navigator.pop(context);
    if (result['errorCode'] != 0) {
      Toast.show(result['errorMsg']);
    } else {
      setState(() {
        _collects.remove(item);
      });
    }
  }
}
