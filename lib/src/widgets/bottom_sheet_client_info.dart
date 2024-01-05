import 'package:flutter/material.dart';

class BottomSheetClientInfo extends StatefulWidget {

  String imageUrl, username, email, plates, auto, model;

  BottomSheetClientInfo({
    @required this.imageUrl,
    @required this.username,
    @required this.email,
    @required this.plates,
    @required this.auto,
    @required this.model
  });

  @override
  _BottomSheetClientInfoState createState() => _BottomSheetClientInfoState();
}

class _BottomSheetClientInfoState extends State<BottomSheetClientInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      margin: EdgeInsets.all(30),
      child: Column(
        children: [
          Text(
            'Tu conductor',
            style: TextStyle(
              fontSize: 18
            ),
          ),
          SizedBox(height: 15),
          CircleAvatar(
            backgroundImage: widget.imageUrl != null
                ? NetworkImage(widget.imageUrl)
                : AssetImage('assets/img/profile.jpg'),
            radius: 50,
          ),
          ListTile(
            title: Text(
              'Nombre',
              style: TextStyle(
                fontSize: 15
              ),
            ),
            subtitle: Text(
              widget.username ?? '',
              style: TextStyle(
                  fontSize: 15
              ),
            ),
            leading: Icon(Icons.person),
          ),
          ListTile(
            title: Text(
              'Email',
              style: TextStyle(
                  fontSize: 15
              ),
            ),
            subtitle: Text(
              widget.email ?? '',
              style: TextStyle(
                  fontSize: 15
              ),
            ),
            leading: Icon(Icons.email),
          ),
          ListTile(
            title: Text(
              'Datos vehículo',
              style: TextStyle(
                  fontSize: 15
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Placas: ${widget.plates}' ?? '',
                  style: TextStyle(
                      fontSize: 15
                  ),
                ),

                    Text(
                      'Auto: ${widget.auto}' ?? '',
                      style: TextStyle(
                        fontSize: 15
                      ),
                    ),
                    Text(
                      'Model: ${widget.model}' ?? '',
                      style: TextStyle(
                          fontSize: 15
                      ),
                    )

              ],
            ),
            leading: Icon(Icons.directions_car),
          ),
        ],
      ),
    );
  }
}
