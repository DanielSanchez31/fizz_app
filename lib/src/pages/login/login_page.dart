import 'package:fizz_app/src/pages/login/login_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fizz_app/src/utils/colors.dart';

class LoginPage extends StatefulWidget  {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isHiddenPassword = true;

  LoginController _controller = new LoginController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.init(context);
    });
  }

  @override
  Widget build(BuildContext context){
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      key: _controller.key,
      backgroundColor: Color.fromRGBO(220, 0, 29, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: WaveClipperTwo(),
              child: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height * 0.35,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      'assets/img/FizzApp_Logo_Rojo.png',
                      width: 240,
                      height: 120,
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(height: 20),
                Text(
                  'Inicia Sesión',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 30),
                Container(
                  width: 300,
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _controller.emailController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            //border: OutlineInputBorder(),
                            labelText: 'Email',
                            labelStyle: new TextStyle(color: Colors.white)
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _controller.passwordController,
                        obscureText: isHiddenPassword,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              isHiddenPassword = !isHiddenPassword;
                            },
                            child: Icon(
                              isHiddenPassword
                              ? Icons.visibility
                              : Icons.visibility_off
                            ),
                          ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            labelStyle: new TextStyle(color: Colors.white),
                            hintStyle: TextStyle(color: Colors.white)
                        ),
                      ),
                      SizedBox( height: 10),
                      RaisedButton(
                          color: Colors.white,
                          onPressed: (){
                            _controller.login();
                          },
                          child: Center(
                              child: Text('Iniciar')
                          ),
                          textColor: Color.fromRGBO(220, 0, 29, 1),
                      ),
                      SizedBox( height: 10),
                      GestureDetector(
                        onTap: _controller.goToRegisterPage,
                        child: Text(
                          '¿No tienes cuenta? Regístrate',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      SizedBox(height: 100),
                    ],

                  ),

                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  margin: EdgeInsets.only(left: 200,bottom: 50),
                  child: RaisedButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                        ),
                    ),
                    onPressed: _controller.returnUsers,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Usuarios',
                            style: TextStyle(color: Color.fromRGBO(220, 0, 29, 1)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CircleAvatar(
                            radius: 15,
                            child: Icon(Icons.arrow_back_ios_new, color: Color.fromRGBO(220, 0, 29, 1)),
                            backgroundColor: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
