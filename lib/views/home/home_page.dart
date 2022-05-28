import 'package:flutter/material.dart';
import 'package:projeto_oh_campeao/models/table.dart';
import 'package:projeto_oh_campeao/services/auth.dart';
import 'package:projeto_oh_campeao/services/menuList.dart';
import 'package:projeto_oh_campeao/utils/utils.dart';
import 'package:projeto_oh_campeao/views/Menu/listMenu_page.dart';
import 'package:projeto_oh_campeao/views/order.dart';
import 'package:projeto_oh_campeao/widgets/custom_card.dart';
import 'package:projeto_oh_campeao/widgets/custom_drawer.dart';
import 'package:dio/dio.dart';

import 'package:qrcode/qrcode.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static QRCaptureController _captureController = QRCaptureController();

  bool _isTorchOn = false;
  bool qrcode = false;
  bool ler = false;  
  bool campeao = false;
  bool loading = false;
  String codigo = TableI.getTable();
  int userId = Auth.getUserId();
  int page = 0; 
  bool gerou = false;

  @override
  void initState() {
    super.initState();

    if(TableI.getTable() == "" || TableI.getTable() == null)
      page = 0;
    else 
      page = 1;

    _captureController.onCapture((data) {
      print('onCapture----$data');
      if (data == null) {
        codigo = "";
      } else{
        print("entrou");
        TableI.setTable(data);
        codigo = data;                
        setState(() {
          qrcode = false;
          page = 1;                      
        });        
                
        gerarMesa(data);
        
      }      

    });
  }

  void gerarMesa(var cod) async{

    if(!gerou){
      gerou = true;
      if(userId != 0){
        Response response = await Dio().request(
            "http://192.168.15.10:8080/api/comanda/iniciar/" + userId.toString() + "/" + cod,
            options: Options(
              headers: {"Accept": "application/json"}
              )      
        );

        var idComanda = response.data["resultData"];
        print(idComanda);
        Menu.setIdComanda(idComanda);
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    List<Widget> allWidget = <Widget>[
      Expanded(
          child: CustomCard(Center(
              child: Text(
        "Leia um QRCODE", style: TextStyle(fontSize: 20)
      )))),
      Expanded(child: CustomCard(PageOrderList())),
    ];
  
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          actions: <Widget>[_actionOhCampeao()],
        ),
        drawer: CustomDrawer(),
        body: qrcode
            ? _buildqrcode()
            : Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                    CustomCard(_buildTable()),
                    allWidget[page],
                    CustomCard(codigo == "" || codigo == null ? _buttonQRCode() : _order())
                  ])));
  }

  Widget _actionOhCampeao() {
    return Row(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Center(
                child: Container(
                child: campeao
                  ? Icon(Icons.notifications_active)
                  : Icon(Icons.notifications_none),
            )),
          ],
        ),
        Container(
          child: FlatButton(
              onPressed: () async {
                setState(() {
                  campeao ? campeao = false : campeao = true;
                  loading = true;
                });
                await Future.delayed(Duration(seconds: 4));
                setState(() {
                  loading = false;
                  campeao ? campeao = false : campeao = true;
                });
              },
              child: loading ? Util.loading() :Text("Chamar oh_campeão",
                  style: TextStyle(color: Colors.white))
              ),
        ),
      ],
    );
  }

  Widget _buildTable() {
    return Container(
        alignment: Alignment.center,
        child: codigo == "" || codigo == null
            ? Text("Bem vindo " + Auth.getUserName(), style: TextStyle(fontSize: 20))
            : Text("Numero da sua mesa é: " + codigo, style: TextStyle(fontSize: 20)));
  }

  Widget _order() {
    
    return Container(  
      alignment: Alignment.center,
      height: 25,
        child: FlatButton(
            child: Text("Fazer o pedido", style: TextStyle(fontSize: 20)),                        
            onPressed: () async{ 
              await Menu.menuList(); 
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PageMenuList()),
              );
              
            }));

    /*Navigator.of(context)
                  .pushReplacementNamed(PageMenuList.routeName),
              child: Text("Fazer o pedido")));*/
  }

  Widget _buttonQRCode() {
    return Container(
        alignment: Alignment.bottomCenter,
        height: 25,
        child: FlatButton(
          child: Text("Ler QRCODE", style: TextStyle(fontSize: 20)),                 
          onPressed:  () async {            
            /*TableI.setTable("1");
            setState(() {
              codigo = "1";
              gerarMesa();
              qrcode = false;
              page = 1;              
            });*/
            setState(() {
              qrcode = true;
              codigo = "";              
              page = 1;
            });
          },
        ));
  }

  Widget _buildqrcode() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        QRCaptureView(controller: _captureController),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                color: Colors.white,
                onPressed: () {
                  if (_isTorchOn) {
                    _captureController.torchMode = CaptureTorchMode.off;
                  } else {
                    _captureController.torchMode = CaptureTorchMode.on;
                  }
                  _isTorchOn = !_isTorchOn;
                },
                child: Text('torch'),
              ),
              FlatButton(
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    qrcode = false;
                    page = 0;
                  });
                },
                child: Text('exit'),
              ),
            ],
          ),
        )
      ],
    );
  }
}
