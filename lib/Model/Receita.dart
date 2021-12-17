// To parse this JSON data, do
//
//     final receita = receitaFromJson(jsonString);

import 'dart:convert';

Receita receitaFromJson(String str) => Receita.fromJson(json.decode(str));

String receitaToJson(Receita data) => json.encode(data.toJson());

class Receita {
  Receita({
    this.id,
    required this.titulo,
    required this.ingredientes,
    required this.preparo,
    required this.imagem,
  });

  int? id;
  String titulo;
  String ingredientes;
  String preparo;
  String imagem;

  Receita copy({
    int? id,
    String? titulo,
    String? ingredientes,
    String? preparo,
    String? imagem
  }) =>
      Receita(
        id: id ?? this.id,
        titulo: titulo ?? this.titulo,
        ingredientes: ingredientes ?? this.ingredientes,
        preparo: preparo ?? this.preparo,
        imagem: imagem ?? this.imagem
      );

  factory Receita.fromJson(Map<String, dynamic> json) => Receita(
    id: json["id"],
    titulo: json["titulo"],
    ingredientes: json["ingredientes"],
    preparo: json["preparo"],
    imagem: json["imagem"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "titulo": titulo,
    "ingredientes": ingredientes,
    "preparo": preparo,
    "imagem": imagem,
  };
}
