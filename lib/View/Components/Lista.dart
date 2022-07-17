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

  List<Receita> receitas = [];
  bool isLoading = false;

  @override
  void initState() {
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
          child: Visibility(
            visible: receitas.isNotEmpty,
            replacement: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(25),
              child: Text("Nenhuma receita foi salva."),
            ),
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
                        title: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(receitas[index].imagem, width: 80, height: 80, fit: BoxFit.cover)),
                              Padding(
                                  padding: EdgeInsets.only(left: 20, top: 10),
                                  child: Text("${receitas[index].titulo}", style: TextStyle(fontSize: 14))
                              ),
                            ],
                          ),
                        ),
                      ),
                  );
                }
            ),
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
          isLoading ? Container(padding: EdgeInsets.all(20), child: Center(child: Padding(
            padding: const EdgeInsets.only(top: 25),
            child: CircularProgressIndicator(),
          ))) : _buildLista(),
        ],
      ),
    );
  }


}
