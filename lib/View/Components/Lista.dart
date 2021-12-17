import 'package:flutter/material.dart';
import 'package:myrecipes/Database/DB.dart';
import 'package:myrecipes/Model/Receita.dart';
import 'package:myrecipes/View/Components/ReceitaDetails.dart';
import 'package:myrecipes/View/Components/SelectImage.dart';
import 'package:myrecipes/View/Components/addReceita.dart';

class Lista extends StatefulWidget {
  const Lista({Key? key}) : super(key: key);

  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Lista> {

  late List<Receita> receitas;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshReceitas();
  }

  Future refreshReceitas() async {
    setState(() => isLoading = true);
    await Future.delayed(Duration(seconds: 1));
    this.receitas = await DB.instance.readAllReceita();
    setState(() => isLoading = false);
  }

  Widget _buildLista() {

    var size = MediaQuery.of(context).size;

    return Container(
      child: Expanded(
        child: SingleChildScrollView(
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: receitas.length,
              itemBuilder: (context, index) {
                return Material(
                    color: Colors.transparent,
                    child: ListTile(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                            ReceitaDetails(
                                id: receitas[index].id,
                                titulo: receitas[index].titulo,
                                ingredientes: receitas[index].ingredientes,
                                preparo: receitas[index].preparo,
                                imagem: receitas[index].imagem
                            )
                        ));
                      },
                      title: Row(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(receitas[index].imagem, width: size.width * 0.18, height: size.height * 0.1, fit: BoxFit.fill)),
                          Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text("${receitas[index].titulo}", style: TextStyle(fontSize: 18))
                          ),
                        ],
                      ),
                    ),
                );
              }
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas receitas"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh), onPressed: () {
            refreshReceitas();
          },
          ),
          IconButton(
            icon: Icon(Icons.add), onPressed: () { 
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SelectImage() ));
          },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: isLoading ? Container(padding: EdgeInsets.all(20), child: CircularProgressIndicator()) : Container(),
          ),
          _buildLista()
        ],
      ),
    );
  }


}
