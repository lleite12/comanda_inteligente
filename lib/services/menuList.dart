
import 'dart:convert';

import 'package:dio/dio.dart';

import 'dart:async';


import 'package:projeto_oh_campeao/models/menu.dart';



class Menu {
  static List<Product> data = List<Product>();
  static List<Product> dataOrder = List<Product>();
  static List<Product> dataOrderTable  = List<Product>();

  static double total = 0.0;
  static double totalTable = 0.0;
  static double totalOrder = 0.0;

  static int idComanda = 0;

  static Future<bool> menuList() async {    

    data = [];
    Response response = await Dio().request(
      "http://192.168.15.10:8080/api/produto/todos",
      options: Options(headers: {"Accept": "application/json"})
    );
    var produto = response.data["resultData"];
    
    for(Map<String,dynamic> item in produto){
      data.add(Product.fromJson(item));
    }        

    return true;    

  }

  static List getMenuList() {            
    return data;
  }

   static void order(List<Product> list) {
    //var post = list.toString();
    if (list.length > 0) {
      for (int i = 0; i < list.length; i++) {
        if (list[i].quantity > 0) {
          dataOrder.add(list[i]);
          total += list[i].valor * list[i].quantity;
          totalOrder += list[i].valor * list[i].quantity;
        }
      }
    }
    //print(post);
    //menuList();
  }

  static void orderTable(List<Product> list) {

    if (list.length > 0) {
      for (int i = 0; i < list.length; i++) {
        if (list[i].quantity > 0) {
          dataOrderTable.add(list[i]);
          totalTable += list[i].valor * list[i].quantity;
          totalOrder += (list[i].valor * list[i].quantity) / 5;
          list[i].valor = list[i].valor / 5;
          dataOrder.add(list[i]);
        }
      }
    }
    //print(post);
    //menuList();
  }

  static Future<bool> orderList(List<Product> order) async {    
     
    var produto = [];

   if (order.length > 0) {
      for (int i = 0; i < order.length; i++) {
        if (order[i].quantity > 0) {
        

          var item = {"IdProduto" : order[i].id, 
                     "Quantidade" : order[i].quantity,
                     "IdComanda" : idComanda };

          print(item);

          produto.add(item);
        }
      }
    }

    print(produto);

    await Dio().request(
        "http://192.168.15.10:8080/api/comanda/adicionar/individual",
        options: Options(
          headers: {"Accept": "application/json"},
          method: 'POST'
          ),
          data: produto
    );

    return true;
  }

  static List getOrderList() {
    return dataOrder;
  }

  static Future<bool> orderTableList(List<Product> order) async {
  
   var produto = [];

   if (order.length > 0) {
      for (int i = 0; i < order.length; i++) {
        if (order[i].quantity > 0) {
        

          var item = {"IdProduto" : order[i].id, 
                     "Quantidade" : order[i].quantity,
                     "IdComanda" : idComanda };

          print(item);

          produto.add(item);
        }
      }
    }

    print(produto);

    await Dio().request(
        "http://192.168.15.10:8080/api/comanda/adicionar/compartilhado",
        options: Options(
          headers: {"Accept": "application/json"},
          method: 'POST'
          ),
          data: produto
    );

    return true;
  }

  static List getOrderTableList() {
    return dataOrderTable;
  }


  static double getTotal() {
    return total;
  }

  static double getTotalOrder() {
    return totalOrder;
  }

  static double getTotalTable() {
    return totalTable;
  }

  static bool setIdComanda(var id) {
    idComanda = id;

    return true;
  }

   static Future<bool>  fecharComanda() async {
    
      await Dio().request(
        "http://192.168.15.10:8080/api/comanda/fechar/" + idComanda.toString(),
        options: Options(headers: {"Accept": "application/json"})
      );

      return true;
    
  }

  static void clearData() async {

    fecharComanda();
    
    dataOrder = [];
    dataOrderTable = [];;

    total = 0.0;
    totalTable = 0.0;
    totalOrder = 0.0;
    idComanda = 0;

  }
  
}
