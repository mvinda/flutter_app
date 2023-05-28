import 'package:flutter/material.dart';

// void main() => runApp(MainPage());

class MainPage extends StatelessWidget {
  Widget builder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("第一个页面"),
      ),
      body: FloatingActionButton(
        onPressed: () {

          Navigator.pushNamed(context, "page2");
        },
        child: const Text("跳转到第二个界面"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      routes: {
        "home":(_){return MainPage();},
        "page2":(_){return page2();}
      },
      title: "第一个页面",
      home: Builder(builder: builder),
    );
  }
}

class page2 extends StatelessWidget {
  page2() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("第二个页面"),
      ),
      body: FloatingActionButton(onPressed: (){
        Navigator.pop(context,"111");
      },child: const Text("返回"),),
    );
  }
}
