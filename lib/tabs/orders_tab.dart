import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_levitate/models/user_model.dart';
import 'package:flutter_levitate/screens/login_screen.dart';
import 'package:flutter_levitate/tiles/order_tile.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    if(UserModel.of(context).isLoggedIn()){

      String uid = UserModel.of(context).firebaseUser.uid;

      //QuerySnapshot pois iremos receber todos os documentos de uma collection, se fosse apenas um doc, utilizariamos DocumentSnapshot
      return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection("users").document(uid).collection("orders").getDocuments(),
        builder: (context, snapshot){
          if(!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          else {
            return ListView(
              //pegando cada documento do firebase, transformando em um ordertile(quadradinho que vai mostrar o pedido)
              children: snapshot.data.documents.map((doc) => OrderTile(doc.documentID)).toList(),
            );
          }
        },
      );

    } else {
      return Container(
        padding: EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.view_list, size: 80.0, color: Theme.of(context).primaryColor,),
            SizedBox(height: 16.0,),
            Text("Faça o login para acompanhar!", textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0,),
            RaisedButton(
              child: Text("Entrar", style: TextStyle(fontSize: 18.0),),
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
              onPressed: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>LoginScreen())
                );
              },
            )
          ],
        ),
      );
    }
  }
}
