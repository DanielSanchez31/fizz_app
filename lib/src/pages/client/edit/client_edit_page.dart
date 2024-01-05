import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fizz_app/src/pages/client/edit/client_edit_controller.dart';
import 'package:fizz_app/src/pages/login/login_controller.dart';
import 'package:fizz_app/src/pages/client/register/client_register_controller.dart';
import 'package:fizz_app/src/utils/colors.dart' as utils;
import 'package:fizz_app/src/widgets/button_app.dart';

class ClientEditPage extends StatefulWidget {
  @override
  _ClientEditPageState createState() => _ClientEditPageState();
}

class _ClientEditPageState extends State<ClientEditPage> {

  ClientEditController _con = new ClientEditController();

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

    return Scaffold(
      key: _con.key,
      appBar: AppBar(),
      bottomNavigationBar: _buttonRegister(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _bannerApp(),
            _textLogin(),
            _textFieldUsername(),
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
      clipper: OvalBottomBorderClipper(),
      child: Container(
        color: Color.fromRGBO(220, 0, 29, 1),
        height: MediaQuery.of(context).size.height * 0.25,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
           GestureDetector(
             onTap: _con.showAlertDialog,
             child: CircleAvatar(
               backgroundImage: _con.imageFile != null ?
               AssetImage(_con.imageFile?.path ?? 'assets/img/profile.jpg') :
               _con.client?.image != null
                   ? NetworkImage(_con.client?.image)
                   : AssetImage(_con.imageFile?.path ?? 'assets/img/profile.jpg'),
               radius: 50,
             ),
           ),
            Container(
              margin: EdgeInsets.only(top: 25),
              child: Text(
                _con.client?.email ?? '',
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
