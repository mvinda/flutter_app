import 'package:app/event/events.dart';
import 'package:app/http/api.dart';
import 'package:app/manager/app_manager.dart';
import 'package:app/ui/page/page_login.dart';
import 'package:app/ui/page/page_conllect.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String? _username;

  @override
  void initState() {
    super.initState();

    AppManager.eventBus.on<LoginEvent>().listen((event) {
      setState(() {
        _username = event.username;
        //sp sharedprefrence
        AppManager.prefs?.setString(AppManager.ACCOUNT, _username!);
      });
    });
    _username = AppManager.prefs!.getString(AppManager.ACCOUNT);
  }

  void _itemClick(Widget? page) {
    //如果未登录 则进入登陆界面
    var dstPage =
        (_username == null || _username!.isEmpty) ? const LoginPage() : page;
    //如果page为null，则跳转
    if (dstPage != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return dstPage;
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget userHeader = DrawerHeader(
        decoration: const BoxDecoration(
          color: Colors.blue,
        ),
        child: InkWell(
            onTap: () => _itemClick(null),
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(bottom: 18.0),
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/images/logo.png"),
                    radius: 38.0,
                  ),
                ),
                Text(
                  _username ?? "请先登录",
                  style: const TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ],
            )));

    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        userHeader,
        InkWell(
          onTap: () => _itemClick(const CollectPage()),
          child: const ListTile(
            leading: Icon(Icons.favorite),
            title: Text(
              "收藏列表",
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 0.0),
          child: Divider(
            color: Colors.grey,
          ),
        ),
        Offstage(
          offstage: _username == null || _username!.isEmpty,
          child: InkWell(
              onTap: () => {
                    setState(() {
                      AppManager.prefs?.setString(AppManager.ACCOUNT, "");
                      Api.clearCookie();
                      _username = "";
                    })
                  },
              child: const ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text(
                  "退出登录",
                  style: TextStyle(fontSize: 16.0),
                ),
              )),
        ),
      ],
    );
  }
}
