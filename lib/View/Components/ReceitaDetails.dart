import 'package:flutter/material.dart';
import 'package:myrecipes/Database/DB.dart';

import '../Home.dart';

class ReceitaDetails extends StatefulWidget {
  const ReceitaDetails({Key? key, required this.id, required this.titulo, required this.ingredientes, required this.preparo, required this.imagem}) : super(key: key);

  final id;
  final titulo;
  final ingredientes;
  final preparo;
  final imagem;

  @override
  _ReceitaDetailsState createState() => _ReceitaDetailsState();
}

class _ReceitaDetailsState extends State<ReceitaDetails> {
  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(widget.titulo),
        actions: [
          IconButton(
            icon: Icon(Icons.delete), onPressed: () async {
              await DB.instance.removeReceita(widget.id);
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Home() ), (route) => false);
          },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(widget.imagem, width: size.width * 0.9, height: size.height * 0.4, fit: BoxFit.fill,)),
            ),
            SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                        '''
Receita de ${widget.titulo}


Ingredientes:
--------------------------------------------------------------------------
${widget.ingredientes}\n\n
Preparo:
--------------------------------------------------------------------------
${widget.preparo}''',
                        toolbarOptions: ToolbarOptions(copy: true, cut: false, selectAll: true)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
