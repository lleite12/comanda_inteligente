import 'package:flutter/material.dart';
import 'package:projeto_oh_campeao/models/menu.dart';
import 'package:projeto_oh_campeao/services/menuList.dart';
import 'package:projeto_oh_campeao/views/home/home_page.dart';
import 'package:projeto_oh_campeao/widgets/custom_card.dart';
import 'package:projeto_oh_campeao/widgets/custom_drawer.dart';

class PageMenuList extends StatefulWidget {
  static const String routeName = '/menu';
  @override
  _PageMenuListState createState() => _PageMenuListState();
  
}

class _PageMenuListState extends State<PageMenuList> {  
  List<Product> list = Menu.getMenuList();  

  double total = 0;

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(title: Text("Cardápio")),
      body: CustomCard(_listview()),
    );    
  }

  Widget _listview() {
    return Column(
      children: <Widget>[
        Container(
          child: Text("Total:  R\$ " + total.toStringAsFixed(2).toString(), style: TextStyle(fontSize: 20)),
          padding: EdgeInsets.symmetric(vertical: 15.0),
        ),
        Expanded(
            child: ListView.separated(
                separatorBuilder: (context, index) => Divider(
                      color: Colors.grey,
                    ),
                itemCount: list == null ? 0 : list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      title: Text(list[index].nome, style: TextStyle(fontSize: 20)),
                      subtitle: Center(
                          child: Row(
                        children: <Widget>[
                          IconButton(
                              color: list[index].quantity == 0
                                  ? Colors.transparent
                                  : Colors.black,
                              icon: Icon(Icons.remove),
                              onPressed: list[index].quantity == 0
                                  ? () {}
                                  : () {
                                      setState(() {
                                        list[index].quantity =
                                            list[index].quantity - 1;
                                        total -=
                                            list[index].valor;
                                      });
                                    }),
                          Text(list[index].quantity.toString()),
                          IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  list[index].quantity =
                                      list[index].quantity + 1;
                                  total += list[index].valor;
                                });
                              })
                        ],
                      )),
                      trailing: Text("R\$ " + list[index].valor.toString()));
                })),
        Row(
          children: <Widget>[
            Expanded(
                child: ButtonTheme(
                    height: 50.0,
                    child: FlatButton(
                      child: Text("Para mim", style: TextStyle(fontSize: 20, color: Colors.white)),  
                      color: Colors.blue, 
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),                    
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Confirmar pedido individual"),
                              content: Text(
                                  "Deseja continuar com o pedido individual ?"),
                              actions: [
                                FlatButton(
                                  child: Text("Confirmar"),
                                  onPressed: () async {
                                    for (int i = 0; i < list.length; i++) {
                                      list[i].order = "individual";
                                    }
                                    await Menu.orderList(list);
                                    Menu.order(list);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => HomePage()),
                                    );
                                  },
                                ),
                                FlatButton(
                                  child: Text("cancelar"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ))), 
                    Container(child: Text("  ")),           
            Expanded(
                child: ButtonTheme(                  
                    height: 50.0,                    
                    child: FlatButton(
                      child: Text("Para mesa", style: TextStyle(fontSize: 20, color: Colors.white)), 
                      color: Colors.blue,                   
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),                  
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Confirmar pedido para mesa"),
                              content: Text(
                                  "Deseja continuar com o pedido para mesa ?"),
                              actions: [
                                FlatButton(
                                  child: Text("Confirmar"),
                                  onPressed: () async{
                                    for (int i = 0; i < list.length; i++) {
                                      list[i].order = "mesa";
                                    }     
                                    await Menu.orderTableList(list);                              
                                    Menu.orderTable(list);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => HomePage()),
                                    );
                                  },
                                ),
                                FlatButton(
                                  child: Text("cancelar"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ], 
                            );
                          },
                        );
                      },
                    )))
          ],
        )
      ],
    );
  }
}
