import 'package:fizz_app/src/db/db_sql.dart';
import 'package:fizz_app/src/pages/client/payments/create/client_payment_create_controller.dart';
import 'package:fizz_app/src/pages/login/button_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import 'client_payment_list_controller.dart';

class ClientPaymentListPage extends StatefulWidget {

  @override
  _ClientPaymentListPageState createState() => _ClientPaymentListPageState();
}

class _ClientPaymentListPageState extends State<ClientPaymentListPage> {

  ClientPaymentListController _con = new ClientPaymentListController();



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
    // print('_con.listadoDeTarjetas.length: ' +_con.listadoDeTarjetas.length.toString());

    //   print('_con.listadoDeTarjetas: ' +_con.listadoDeTarjetas.toString());
    return Scaffold(

        key: _con.key,
        appBar: AppBar(title: Text('Métodos de pago'),
          backgroundColor: Color.fromRGBO(220, 0, 29, 1),
          actions: [
            IconButton(onPressed: () =>
                Navigator.pushNamed(context, 'client/payment/create'),
                icon: Icon(Icons.add))
          ],
        ),

        body: FutureBuilder(
            future: DBProvider.db.listarTarjetas(),
            builder:
                (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot?.data == null) {
                //refresh();
                return Container();
              }

              print(snapshot.data);

              //  print('index: '+data.toString());
              //   print(_con.listadoDeTarjetas[index]['numero_tarjeta']);

              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    print('index: ' + index.toString());
                    //   print(_con.listadoDeTarjetas[index]['numero_tarjeta']);

                    return ListTile(
                      onTap: _con.boleano ? () {
                        Navigator.pushNamed(
                            context, 'client/travel/request', arguments: {
                          'from': _con.from,
                          'to': _con.to,
                          'fromLatLng': _con.fromLatLng,
                          'toLatLng': _con.toLatLng,
                          'numero_tarjeta': snapshot
                              .data[index]['numero_tarjeta'].toString(),
                          'codigo_tarjeta': snapshot
                              .data[index]['codigo_tarjeta'].toString(),
                          'expiracion_tarjeta': snapshot
                              .data[index]['expiracion_tarjeta'].toString()
                        });
                      } : null,
                      trailing: _con.boleano
                          ? Icon(Icons.send)
                          : const SizedBox(),


                      title: Text('Numero de tarjeta: \n' +
                          snapshot.data[index]['numero_tarjeta']
                              .toString()
                              .replaceRange(0, 12, "************"),
                      ),
                      leading: Icon(Icons.credit_card),
                      //subtitle: Text('Expiracion de la tarjeta: ' + snapshot.data[index]['expiracion_tarjeta'].toString().substring(5)),
                    );
                  }
              );
            })
    );
  }


    void refresh (){
    setState(() {});
    }
}

