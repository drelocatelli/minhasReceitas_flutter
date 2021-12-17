import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myrecipes/Database/DB.dart';
import 'package:myrecipes/Model/Receita.dart';
import 'package:myrecipes/View/Components/SelectImage.dart';
import 'package:myrecipes/View/Home.dart';

class addReceita extends StatefulWidget {
  const addReceita({Key? key, String? this.image}) : super(key: key);

  final image;

  @override
  _addReceitaState createState() => _addReceitaState();
}

class _addReceitaState extends State<addReceita> {

  Widget _receitaForm() {

    TextEditingController tituloIn = TextEditingController();
    TextEditingController imagemIn = TextEditingController(text: widget.image);
    TextEditingController ingredientesIn = TextEditingController();
    TextEditingController preparoIn = TextEditingController();

    return Column(
      children: [
        ElevatedButton(
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SelectImage() ));
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(Size.fromHeight(40)),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green)
            ),
            child: Text("Selecionar imagem")
        ),
        SizedBox(height: 10),
        TextField(
          controller: tituloIn,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Titulo"
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: ingredientesIn,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          minLines: 2,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Ingredientes"
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: preparoIn,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          minLines: 2,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Preparo"
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            if(tituloIn.text.isNotEmpty && imagemIn.text.isNotEmpty && ingredientesIn.text.isNotEmpty && preparoIn.text.isNotEmpty) {
              await DB.instance.insertReceita(Receita(imagem: imagemIn.text, preparo: preparoIn.text, titulo: tituloIn.text, ingredientes: ingredientesIn.text));
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Home() ), (route) => false);
            }
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
              minimumSize: MaterialStateProperty.all<Size>(Size.fromHeight(40)),
          ),
          child: Text("Salvar receita", style: TextStyle(fontSize: 20)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Home() ), (route) => false);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Salvar receita"),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: _receitaForm()
      ),
    );
  }
}
