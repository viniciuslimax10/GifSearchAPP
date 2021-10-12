import 'dart:io';

import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';



class GifPage extends StatelessWidget {


  final Map _gifData;

  GifPage(this._gifData);

  Future<void> _shareImageFromUrl(urlImage,name) async {
    try {
      var request = await HttpClient().getUrl(Uri.parse(urlImage));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.file('Busca Gif', name+".gif", bytes, 'image/gif');
    } catch (e) {
      print('error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifData["title"]),
        backgroundColor: Colors.black,
        actions:<Widget>[
          IconButton(
            icon:Icon(Icons.share),
              onPressed: () async{
                await _shareImageFromUrl(_gifData["images"]["fixed_height"]["url"],_gifData["title"]);
              }
          )
        ]
      ),
        body:Column(
          children: <Widget>[
            Padding(
              padding:EdgeInsets.all(10.0),
            ),
            Container(
                child:Text(
                  "Dados do GIF",
                  textAlign: TextAlign.center,
                  style: TextStyle(color:Colors.black,fontSize:18.0)
                  ),
                  alignment: Alignment.center,
                ),
            Padding(
              padding:EdgeInsets.all(10.0),
            ),
            Container(
              child: Text(
                'Nome:'+_gifData["title"],
                style: TextStyle(color:Colors.black,fontSize:15.0)
                ),
            ),
            Container(
              child: Text(
                'Criador:'+_gifData["username"],
                  style: TextStyle(color:Colors.black,fontSize:15.0)
              ),
            ),
            Container(
                child:Image.network(
                  _gifData["images"]["fixed_height"]["url"],
                  width: 350.0,
                  height: 250.0,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),

            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: StadiumBorder(),
                side: BorderSide(
                    width: 4,
                    color: Colors.blue,

                ),
              ),
              onPressed: () async{
                await _shareImageFromUrl(_gifData["images"]["fixed_height"]["url"],_gifData["title"]);
              },
              child: Text(
                  'Compartilhar',
                  style: TextStyle(color:Colors.white,fontSize:20.0)
              ),
            )
          ],
        )
    );
  }
}
