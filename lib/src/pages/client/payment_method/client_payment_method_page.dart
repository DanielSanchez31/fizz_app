import 'package:fizz_app/src/pages/client/payment_method/client_payment_method_controller.dart';
import 'package:fizz_app/src/pages/login/button_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ClientPaymentMethodPage extends StatefulWidget {
  const ClientPaymentMethodPage({Key key}) : super(key: key);

  @override
  _ClientPaymentMethodPageState createState() => _ClientPaymentMethodPageState();
}

class _ClientPaymentMethodPageState extends State<ClientPaymentMethodPage> {

  ClientPaymentMethodController _con = new ClientPaymentMethodController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Métodos de pago'),backgroundColor: Color.fromRGBO(220, 0, 29, 1)),
      bottomNavigationBar: _buttonAddCard(),
    );
  }

  Widget _buttonAddCard() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 30,vertical: 15),
      child: ButtonApp(
     //   onPressed: _con.newUser,
     //   text: 'Agregar Tarjeta',
      onPressed: _con.irAPagos,

      text: 'Pagar',

        icon: Icons.credit_card_outlined,
        color: Color.fromRGBO(220, 0, 29, 1),
      ),
    );
  }



  void refresh() {
    setState(() {});
  }
}
