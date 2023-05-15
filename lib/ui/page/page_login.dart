import 'package:app/event/events.dart';
import 'package:app/http/api.dart';
import 'package:app/manager/app_manager.dart';
import 'package:app/ui/widget/page_register.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _pwdNode = FocusNode();

  String _username = "", _password = "";
  bool _isObscure = true;
  Color? _pwdIconColor;

  @override
  void dispose() {
    _pwdNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("登录"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          children: <Widget>[
            _buildUserName(),
            _buildPwd(),
            _buildLogin(),
            _buildRegister(),
          ],
        ),
      ),
    );
  }

  Widget _buildRegister() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        ///孩子居中对齐
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('没有账号？'),
          GestureDetector(
            child: const Text(
              '点击注册',
              style: TextStyle(color: Colors.green),
            ),
            onTap: () async {
              ///进入注册
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return RegisterPage();
              }));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogin() {
    return Container(
      height: 45.0,
      margin: const EdgeInsets.only(top: 18.0, left: 8.0, right: 8.0),
      child: FilledButton(
        onPressed: _doLogin,
        child: const Text(
          '登录',
          style: TextStyle(fontSize: 18.0, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildPwd() {
    return TextFormField(
      focusNode: _pwdNode,
      obscureText: _isObscure,
      validator: (value) {
        if (value!.isEmpty) {
          return '请输入密码';
        }
        _password = value;
      },
      textInputAction: TextInputAction.done,
      onEditingComplete: _doLogin,
      decoration: const InputDecoration(
        labelText: '密码',
        suffixIcon: Icon(Icons.remove_red_eye),
      ),
    );
  }

  Widget _buildUserName() {
    return TextFormField(
        decoration: const InputDecoration(
          labelText: '用户名',
        ),
        initialValue: _username,

        ///设置键盘回车为下一步
        textInputAction: TextInputAction.next,
        onEditingComplete: () {
          ///点击下一步
          FocusScope.of(context).requestFocus(_pwdNode);
        },
        validator: (value) {
          if (value!.isEmpty) {
            return '请输入用户名';
          }
          _username = value!;
        });
  }

  void _doLogin() async {
    _pwdNode.unfocus();
    if (_formKey.currentState!.validate()) {
    var  result = await Api.login(_username, _password);

      if ((result.data['errorCode']) == -1) {
        Toast.show(result.data['errorMsg'], duration: Toast.center, gravity: Toast.bottom);
      } else {
        AppManager.eventBus.fire(LoginEvent(_username));
        Navigator.pop(context);
      }
    }
  }
}
