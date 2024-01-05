import 'package:fizz_app/src/pages/client/register/client_register_controller.dart';
import 'package:fizz_app/src/pages/client/register/client_register_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fizz_app/src/utils/colors.dart';

class ClientRegisterPage extends StatefulWidget  {
  @override
  _ClientRegisterPageState createState() => _ClientRegisterPageState();
}

class _ClientRegisterPageState extends State<ClientRegisterPage> {
  bool isHiddenPassword = true;

  ClientRegisterController _controller = new ClientRegisterController();

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
              clipper: OvalBottomBorderClipper(),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.only(bottom: 25),
                height: MediaQuery.of(context).size.height * 0.25,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      'assets/img/FizzApp_Logo_Rojo.png',
                      width: 160,
                      height: 80,
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(height: 20),
                Text(
                  'Regístrate',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 2),
                Text(
                  'Cliente',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(height: 30),
                Container(
                  width: 300,
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _controller.usernameController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            //border: OutlineInputBorder(),
                            labelText: 'Usuario',
                            labelStyle: new TextStyle(color: Colors.white),
                          suffixIcon: Icon (
                            Icons.person_outline_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
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
                            labelStyle: new TextStyle(color: Colors.white),
                          suffixIcon: Icon (
                            Icons.mail_outline,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _controller.passwordController,
                        obscureText: true,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            labelStyle: new TextStyle(color: Colors.white),
                            hintStyle: TextStyle(color: Colors.white),
                          suffixIcon: Icon (
                            Icons.lock_open_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox( height: 10),
                      TextFormField(
                        controller: _controller.confirmPasswordController,
                        obscureText: true,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'Confirmar password',
                          labelStyle: new TextStyle(color: Colors.white),
                          hintStyle: TextStyle(color: Colors.white),
                          suffixIcon: Icon (
                            Icons.lock_open_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox( height: 10),
                      RaisedButton(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          onPressed: (){
                            _controller.register();
                          },
                          child: Center(
                              child: Text('Registrar ahora')
                          ),
                          textColor: Color.fromRGBO(220, 0, 29, 1),
                      ),
                      SizedBox( height: 10),

                    ],

                  ),

                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
