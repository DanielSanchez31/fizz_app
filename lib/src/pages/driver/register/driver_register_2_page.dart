import 'package:fizz_app/src/pages/driver/register/driver_register_controller.dart';
import 'package:fizz_app/src/pages/driver/register/driver_register_page.dart';
import 'package:fizz_app/src/utils/otp_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fizz_app/src/utils/colors.dart';

class DriverRegister2Page extends StatefulWidget  {
  @override
  _DriverRegister2PageState createState() => _DriverRegister2PageState();
}

class _DriverRegister2PageState extends State<DriverRegister2Page> {
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
                          TextFormField(
                            controller: _controller.interController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)
                              ),
                              labelText: 'Clave Interbancaria',
                              labelStyle: new TextStyle(color:  Colors.white),
                              suffixIcon: Icon (
                                Icons.car_repair_outlined,
                                color: Colors.white,
                              )
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _controller.cardController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)
                              ),
                              labelText: 'Número de Tarjeta',
                              labelStyle: new TextStyle(color:  Colors.white),
                              suffixIcon: Icon (
                                Icons.numbers_outlined,
                                color: Colors.white,
                              )
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _controller.accountController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                //border: OutlineInputBorder(),
                                labelText: 'Número de Cuenta',
                                labelStyle: new TextStyle(color: Colors.white),
                              suffixIcon: Icon (
                                Icons.person_outline_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
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
        ),
      ),
    );
  }
}
