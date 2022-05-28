import 'package:flutter/material.dart';
import 'package:projeto_oh_campeao/views/qrCode.dart';
import 'package:projeto_oh_campeao/widgets/custom_card.dart';
import 'package:projeto_oh_campeao/widgets/custom_drawer.dart';

class MesasPage extends StatefulWidget {
  static const String routeName = '/MesasPage';
  @override
  _MesasPage createState() => _MesasPage();
}


class _MesasPage extends State<MesasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: CustomDrawer(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text('Mesas'),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        CustomCard(ButtonTheme(
          minWidth: double.infinity,
          height: 50.0,
          child: FlatButton(
            onPressed: () async {
              QrCode.setMesa("1");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => QrCode()));
            },
            child: Column(// Replace with a Row for horizontal icon + text
                children: <Widget>[
              Text("1", style: TextStyle(fontSize: 20))
            ]),
          ),
        )),
        CustomCard(ButtonTheme(
          minWidth: double.infinity,
          height: 50.0,
          child: FlatButton(
            onPressed: () async {
              QrCode.setMesa("2");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => QrCode()));
            },
            child: Column(// Replace with a Row for horizontal icon + text
                children: <Widget>[
              Text("2", style: TextStyle(fontSize: 20))
            ]),
          ),
        )),
        CustomCard(ButtonTheme(
          minWidth: double.infinity,
          height: 50.0,
          child: FlatButton(
            onPressed: () async {
              QrCode.setMesa("3");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => QrCode()));
            },
            child: Column(// Replace with a Row for horizontal icon + text
                children: <Widget>[
              Text("3", style: TextStyle(fontSize: 20))
            ]),
          ),
        )),
        CustomCard(ButtonTheme(
          minWidth: double.infinity,
          height: 50.0,
          child: FlatButton(
            onPressed: () async {
              QrCode.setMesa("4");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => QrCode()));
            },
            child: Column(// Replace with a Row for horizontal icon + text
                children: <Widget>[
              Text("4", style: TextStyle(fontSize: 20))
            ]),
          ),
        )),
        
      ],
    );
  }
}
