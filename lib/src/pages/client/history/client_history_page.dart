import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fizz_app/src/models/travel_history.dart';
import 'package:fizz_app/src/pages/client/history/client_history_controller.dart';
import 'package:fizz_app/src/utils/relative_time_util.dart';

class ClientHistoryPage extends StatefulWidget {
  @override
  _ClientHistoryPageState createState() => _ClientHistoryPageState();
}

class _ClientHistoryPageState extends State<ClientHistoryPage> {

  ClientHistoryController _con = new ClientHistoryController();

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
      appBar: AppBar(title: Text('Historial de viajes'), backgroundColor: Color.fromRGBO(220, 0, 29, 1),),
      body: FutureBuilder(
        future: _con.getAll(),
        builder: (context, AsyncSnapshot<List<TravelHistory>> snapshot) {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (_, index) {

              return _cardHistoryInfo(
                snapshot.data[index].from,
                snapshot.data[index].to,
                snapshot.data[index].nameDriver,
                snapshot.data[index].price?.toString(),
                snapshot.data[index].calificationDriver?.toString(),
                RelativeTimeUtil.getRelativeTime(snapshot.data[index].timestamp ?? 0),
                snapshot.data[index].id,
              );

            }
          );
        },
      )
    );
  }

  Widget _cardHistoryInfo(
    String from,
    String to,
    String name,
    String price,
    String calification,
    String timestamp,
    String idTravelHistory,
  ) {
    return GestureDetector(
      onTap: () {
        _con.goToDetailHistory(idTravelHistory);
      },
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: 5),
                Icon(Icons.drive_eta),
                SizedBox(width: 5),
                Text(
                  'Conductor: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                SizedBox(width: 5),
                Icon(Icons.location_on),
                SizedBox(width: 5),
                Text(
                    'Recoger en: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    from ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                SizedBox(width: 5),
                Icon(Icons.location_searching),
                SizedBox(width: 5),
                Text(
                  'Destino: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    to ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                SizedBox(width: 5),
                Icon(Icons.monetization_on),
                SizedBox(width: 5),
                Text(
                  'Precio: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    price ?? '\$ 0',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                SizedBox(width: 5),
                Icon(Icons.format_list_numbered),
                SizedBox(width: 5),
                Text(
                  'Calificacion: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    calification ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                SizedBox(width: 5),
                Icon(Icons.timer),
                SizedBox(width: 5),
                Text(
                  'Hace: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    timestamp ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
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
