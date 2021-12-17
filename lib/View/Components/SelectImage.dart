import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myrecipes/View/Components/addReceita.dart';

import 'Lista.dart';

class SelectImage extends StatefulWidget {
  const SelectImage({Key? key}) : super(key: key);

  @override
  _SelectImageState createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImage> {

  List<dynamic> imagens = [];
  TextEditingController search = TextEditingController();

  Widget _busca() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(height: 30),
          Text("Primeiro adicione uma imagem de capa:"),
          SizedBox(height: 10),
          Row(
            children: [
              Flexible(
                  child: TextField(
                    controller: search,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Digite sua busca...",
                        contentPadding: EdgeInsets.only(top: 0, bottom:0, left: 10)
                    ),
                  )
              ),
              ElevatedButton(
                  onPressed: (){
                    _carregarImages(search.text);
                  },
                  child: Text("buscar")
              )
            ],
          )
        ],
      ),
    );
  }

  Future _carregarImages(String busca) async {
    String key = "24854083-39f6af7af8df9a48d655cdf5e";
    String webservice = "https://pixabay.com/api?key=${key}&per_page=150&q=${busca}";
    final request = await http.get(Uri.parse(webservice));

    Map<String, dynamic> map = json.decode(request.body);
    // map["hits"][0]["previewURL"]
    List<dynamic> data = map["hits"].map((item) => item["previewURL"]).toList();

    imagens = data;
    setState(() {
    });

  }

  Widget _listaImagens() {
    return GridView.builder(
            // physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            // scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemCount: imagens.length,
            itemBuilder: (context, index) {
              return TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => addReceita(image: imagens[index]) ), (route) => false);
                  },
                  child: Image.network(imagens[index])
              );
            }
        );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _carregarImages("torta");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Selecionar imagem"),
      ),
      body: Column(
        children: [
          _busca(),
          Expanded(
            child: _listaImagens(),
          )
        ],
      )
    );
  }
}
