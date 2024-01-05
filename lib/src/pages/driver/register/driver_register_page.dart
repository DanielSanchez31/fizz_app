import 'package:fizz_app/src/pages/driver/register/driver_register_controller.dart';
import 'package:fizz_app/src/pages/driver/register/driver_register_page.dart';
import 'package:fizz_app/src/utils/otp_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fizz_app/src/utils/colors.dart';

class DriverRegisterPage extends StatefulWidget  {
  @override
  _DriverRegisterPageState createState() => _DriverRegisterPageState();
}

class _DriverRegisterPageState extends State<DriverRegisterPage> {
  bool isHiddenPassword = true;

  DriverRegisterController _controller = new DriverRegisterController();

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
    return Scaffold(
      key: _controller.key,
      backgroundColor: Color.fromRGBO(220, 0, 29, 1),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Regístrate',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Conductor',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 300,
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
                          Container (
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Placa del Vehículo',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),

                            ),
                          ),
                          Container(
                            child: OTPFields(
                              pin1: _controller.pin1Controller,
                              pin2: _controller.pin2Controller,
                              pin3: _controller.pin3Controller,
                              pin4: _controller.pin4Controller,
                              pin5: _controller.pin5Controller,
                              pin6: _controller.pin6Controller,
                              pin7: _controller.pin7Controller,
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _controller.autoController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)
                              ),
                              labelText: 'Auto',
                              labelStyle: new TextStyle(color:  Colors.white),
                              suffixIcon: Icon (
                                Icons.car_repair_outlined,
                                color: Colors.white,
                              )
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _controller.modelController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)
                              ),
                              labelText: 'Modelo',
                              labelStyle: new TextStyle(color:  Colors.white),
                              suffixIcon: Icon (
                                Icons.numbers_outlined,
                                color: Colors.white,
                              )
                            ),
                          ),
                          SizedBox(height: 10),
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
                                labelText: 'Nombre Completo',
                                labelStyle: new TextStyle(color: Colors.white),
                              suffixIcon: Icon (
                                Icons.person_outline_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _controller.electorController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              //border: OutlineInputBorder(),
                              labelText: 'Clave de Elector',
                              labelStyle: new TextStyle(color: Colors.white),
                              suffixIcon: Icon (
                                Icons.contact_mail_outlined,
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
                          RaisedButton(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              onPressed: (){
                                _controller.nextRegisterPage();
                              },
                              child: Center(
                                  child: Text('Siguiente')
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
        ),
      ),
    );
  }
}
