import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fizz_app/src/pages/driver/edit/driver_edit_controller.dart';
import 'package:fizz_app/src/pages/login/login_controller.dart';
import 'package:fizz_app/src/pages/driver/register/driver_register_controller.dart';
import 'package:fizz_app/src/utils/colors.dart' as utils;
import 'package:fizz_app/src/utils/otp_widget.dart';
import 'package:fizz_app/src/widgets/button_app.dart';

class DriverEditPage extends StatefulWidget {
  @override
  _DriverEditPageState createState() => _DriverEditPageState();
}

class _DriverEditPageState extends State<DriverEditPage> {

  DriverEditController _con = new DriverEditController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('INIT STATE');

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });

  }

  @override
  Widget build(BuildContext context) {

    print('METODO BUILD');

    return Scaffold(
      key: _con.key,
      appBar: AppBar(),
      bottomNavigationBar: _buttonRegister(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _bannerApp(),
            _textLogin(),
            _textLicencePlate(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25),
              child: OTPFields(
                pin1: _con.pin1Controller,
                pin2: _con.pin2Controller,
                pin3: _con.pin3Controller,
                pin4: _con.pin4Controller,
                pin5: _con.pin5Controller,
                pin6: _con.pin6Controller,
                pin7: _con.pin7Controller,
              ),
            ),

            _textFieldUsername(),
            _textFieldAuto(),
            _textFieldModel(),

          ],
        ),
      ),
    );
  }

  Widget _buttonRegister() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: ButtonApp(
        onPressed: _con.update,
        text: 'Actualizar ahora',
        color: Color.fromRGBO(220, 0, 29, 1),
        textColor: Colors.white,
      ),
    );
  }


  Widget _textFieldUsername() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _con.usernameController,
        decoration: InputDecoration(
            hintText: 'Pepito Perez',
            labelText: 'Nombre de usuario',
            suffixIcon: Icon(
              Icons.person_outline,
              color: Colors.grey[700],
            )
        ),
      ),
    );
  }

  Widget _textFieldAuto() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _con.autoController,
        decoration: InputDecoration(
            hintText: 'Cruze',
            labelText: 'Auto',
            suffixIcon: Icon(
              Icons.directions_car_outlined,
              color: Colors.grey[700],
            )
        ),
      ),
    );
  }

  Widget _textFieldModel() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _con.modelController,
        decoration: InputDecoration(
            hintText: '2010',
            labelText: 'Modelo',
            suffixIcon: Icon(
              Icons.confirmation_number_outlined,
              color: Colors.grey[700],
            )
        ),
      ),
    );
  }


  Widget _textLicencePlate() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
          'Placas',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 17
        ),
      ),
    );
  }

  Widget _textLogin() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Text(
        'Editar perfil',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 25
        ),
      ),
    );
  }

  Widget _bannerApp() {
    return ClipPath(
      clipper: WaveClipperTwo(),
      child: Container(
        color: Color.fromRGBO(220, 0, 29, 1),
        height: MediaQuery.of(context).size.height * 0.22,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: _con.showAlertDialog,
              child: CircleAvatar(
                backgroundImage: _con.imageFile != null ?
                AssetImage(_con.imageFile?.path ?? 'assets/img/profile.jpg') :
                _con.driver?.image != null
                    ? NetworkImage(_con.driver?.image)
                    : AssetImage(_con.imageFile?.path ?? 'assets/img/profile.jpg'),
                radius: 50,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Text(
                _con.driver?.email ?? '',
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void refresh() {
    setState(() {

    });
  }


}
