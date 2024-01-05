import 'package:fizz_app/src/pages/client/payments/create/client_payment_create_controller.dart';
import 'package:fizz_app/src/pages/login/button_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class ClientPaymentCreatePage extends StatefulWidget {

  @override
  _ClientPaymentCreatePageState createState() => _ClientPaymentCreatePageState();
}

class _ClientPaymentCreatePageState extends State<ClientPaymentCreatePage> {

  ClientPaymentCreateController _con = new ClientPaymentCreateController();

  bool useBackgroundImage = false;
  
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
      key: _con.key,
      appBar: AppBar(title: Text('Métodos de pago'), backgroundColor: Color.fromRGBO(220, 0, 29, 1),),
      body: ListView(
        children: [
          CreditCardWidget(
            cardNumber: _con.cardNumber,
            expiryDate: _con.expireDate,
            cardHolderName: _con.cardHolderName,
            cvvCode: _con.cvvCode,
            showBackView: _con.isCvvFocused,
            cardBgColor: Color.fromRGBO(220, 0, 29, 1),
            obscureCardNumber: true,
            obscureCardCvv: true,
            animationDuration: Duration(milliseconds: 1000),
            labelCardHolder: 'NOMBRE & APELLIDO',
          ),
          CreditCardForm(
            cardNumber: '',
            expiryDate: '',
            cardHolderName: '',
            cvvCode: '',
            formKey: _con.keyForm, // Required
            onCreditCardModelChange: _con.onCreditCardModelChanged, // Required
            themeColor: Colors.red,
            obscureCvv: true,
            obscureNumber: true,
            cardNumberDecoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Número de la tarjeta',
              hintText: 'XXXX XXXX XXXX XXXX',
            ),
            expiryDateDecoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Fecha',
              hintText: 'XX/XX',
            ),
            cvvCodeDecoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'CVV',
              hintText: 'XXX',
            ),
            cardHolderDecoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nombre del titular',
            ),
          ),

        ],
      ),
      bottomNavigationBar: _buttonRegisterCard(),
    );
  }

  Widget _buttonRegisterCard() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
      child: ButtonApp(
        onPressed: _con.createCardToken,
        text: 'Continuar',
        color: Color.fromRGBO(220, 0, 29, 1),
        icon: Icons.arrow_forward_ios_outlined,
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
