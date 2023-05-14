import 'package:app/ui/widget/article_item.dart';
import 'package:flutter/material.dart';
import 'package:custom_banners/src/ui/custom_banners_base.dart';
import 'package:custom_banners/src/model/banner_model.dart';
import '../http/api.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({Key? key}) : super(key: key);

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  ///滑动控制器
  final ScrollController _controller = ScrollController();
  bool _isHide = true;

  ///请求到的文章数据
  List articles = [];

  List<BannerModel> banners = [];

  var totalCount = 0;

  var currentPage = 0;

  ///分页加载，当前页码
  var curPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;

      ///获得当前位置的像素值
      var pixels = _controller.position.pixels;

      if (maxScroll == pixels && curPage < totalCount) {
        ///加载更多
        _getArticleList();
      }
    });

    /// 因为这一个方法就是去请求文章列表与banner图，下拉刷新需要重新请求
    /// 然而初始化数据也是请求相同的数据，所以在initState初始化数据的时候手动请求一次！
    _pullToRefresh();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _getArticleList([bool update = true]) async {
    var data = await Api.getArticleList(curPage);
    print("curPage:$curPage");
    if (data != null) {
      var map = data['data'];
      var datas = map['datas'];
      totalCount = map["pageCount"];
      if (curPage == 0) {
        articles.clear();
      }
      curPage++;
      articles.addAll(datas);
      if (update) {
        setState(() {});
      }
    }
  }

  _getBanner([bool update = true]) async {
    var data = await Api.getBanner();

    if (data != null) {
      banners.clear();

      data['data'].forEach((v) {
        print("data "+v['imagePath']);
        var banner=BannerModel();
        banner.image=v['imagePath'];
        banner.link=v['url'];
        banners.add(banner);
      });

      // banners.addAll(data['data']);
      if (update) {
        setState(() {});
      }
    }
  }

  Future<void> _pullToRefresh() async {
    print("pullToRefresh");
    curPage = 0;
    Iterable<Future> future = [_getArticleList(), _getBanner()];
    await Future.wait(future);
    _isHide = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ///正在加载
        Offstage(
          offstage: !_isHide, //是否隐藏
          child: const Center(child: CircularProgressIndicator()),
        ),

        Offstage(
          offstage: _isHide,
          child: RefreshIndicator(
              onRefresh: _pullToRefresh,
              child: ListView.builder(
                //条目数 +1代表了banner的条目
                itemCount: articles.length + 1,
                //adapter条目item 视图生成方法
                itemBuilder: (context, i) => _buildItem(i),
                controller: _controller,
              )),
        )
      ],
    );
  }

  Widget _buildItem(int i) {
    if (i == 0) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.3,
        child: _bannerView(),
      );
    }
    var itemData = articles[i-1];
    return ArticleItem(itemData);
  }

  Widget _bannerView() {
    return SingleChildScrollView(
        child: Column(children: [
        CustomBannersBase(
        radius: 0,
        listBanners: banners,
    )
    ]));
  }
}
