
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';


import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:transparent_image/transparent_image.dart';

import 'gif_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

   String _search="";
  int _offset=0;
  Future<Map> _getGifs() async{
    http.Response response;

    if(_search == "")
      //YOUR API KEY TRENDING
      response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/trending?api_key=&limit=20&rating=g"));
    else
      //YOUR API KEY SEARCH
      response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/search?api_key==$_search&limit=19&offset=$_offset&rating=g&lang=pt"));

    return json.decode(response.body);
  }

  @override
  void initState(){
    super.initState();
    _getGifs().then((map){
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        //YOUR IMAGE
        title:Image.network(""),
        centerTitle: true,
      ),
        backgroundColor: Colors.white,
      body:Column(
        children: <Widget>[
         Padding(
           padding:EdgeInsets.all(10.0),
           child:TextField(
               decoration: InputDecoration(
                   labelText: "Digite para pesquisar",
                   labelStyle: TextStyle(color:Colors.black),
                   border:OutlineInputBorder()
               ),
               style: TextStyle(color:Colors.black,fontSize: 18.0),
               textAlign: TextAlign.center,
               onSubmitted: (text){
                 setState(() {
                   _search = text;
                   _offset =0;
                 });
               },
             )
         ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context,snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                      return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child:CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if(snapshot.hasError) return Container();
                      else return _createGifTable(context,snapshot);
                }
              }
            ),
          )
        ],
      )
    );
  }

  int _getCount(List data){
    if(_search == ""){
      return data.length;
    }else{
      return data.length+1;
    }
  }

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

  Widget _createGifTable(BuildContext context,AsyncSnapshot snapshot){
      return GridView.builder(
        padding:EdgeInsets.all(10.0),
        gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0
        ),
        itemCount: _getCount(snapshot.data["data"]),
        itemBuilder: (context,index){
          if(_search == "" || index < snapshot.data["data"].length)
            return GestureDetector(
              child:FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                  height: 300.0,
                  fit: BoxFit.cover,
              ),
              onTap: (){
                Navigator.push(context,
                MaterialPageRoute(builder: (context)=>GifPage(snapshot.data["data"][index]))
                );
              },
              onLongPress: () async{
                await _shareImageFromUrl(snapshot.data["data"][index]["images"]["fixed_height"]["url"],snapshot.data["data"][index]["title"]);
                },
            );
          else
            return Container(
              child:GestureDetector(
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:<Widget>[
                    Icon(Icons.add,color:Colors.black,size:70.0,),
                    Text("Ver mais...",
                        style: TextStyle(color:Colors.black,fontSize:22.0),)
                  ],
                ),
                onTap:(){
                  setState(() {
                    _offset += 19;
                  });
                }
              ),
            );
        }
      );
  }

}
