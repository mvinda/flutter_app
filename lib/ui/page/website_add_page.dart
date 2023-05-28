import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:app/http/api.dart';

class WebsiteAddPage extends StatefulWidget {
  const WebsiteAddPage({Key? key}) : super(key: key);

  @override
  State<WebsiteAddPage> createState() => _WebsiteAddPageState();
}

class _WebsiteAddPageState extends State<WebsiteAddPage> {
  String _name = "";
  String _link = "";

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("收藏网址"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22.0, 18.0, 22.0, 0.0),
          children: <Widget>[
            TextFormField(
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: '名称',
                ),
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return '请输入收藏网址名';
                  }
                  _name = value!;
                }),
            TextFormField(
              initialValue: "http://",
              decoration: const InputDecoration(labelText: '地址'),
              keyboardType: TextInputType.url,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return '请输入收藏网站地址';
                }
                _link = value!;
              },
            ),
            Container(
                height: 45.0,
                margin: const EdgeInsets.only(top: 18.0, left: 8.0, right: 8.0),
                child: FilledButton(
                  onPressed: () => {
                    _doAdd(context),
                },
                  child: const Text(
                    '收藏',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  void _doAdd(context) async {
    if (_formKey.currentState!.validate()) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
    }

    var result = await Api.collectWebsite(_name, _link);

    print("result: $result");

    Navigator.of(context).pop();
  }
}
