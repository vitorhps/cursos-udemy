import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'Post.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _baseUrl = "https://jsonplaceholder.typicode.com";

  Future<List<Post>> _getPosts() async {

    http.Response response = await http.get(_baseUrl + "/posts");

    var jsonData = jsonDecode(response.body);

    List<Post> posts = List();

    for(var post in jsonData) {
      Post p = Post(post["userId"], post["id"], post["title"], post["body"]);
      posts.add(p);
    }

    return posts;
  }

  void _post() async {

    Post post = Post(120, null, "Titulo", "Corpo da mensagem");

    http.Response response = await http.post(
      _baseUrl + "/posts",
      headers: {
        "Content-type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(post.toJson()),
    );

    print("Resposta: ${response.statusCode}");
    print("Resposta: ${response.body}");

  }

  void _put() async {

    http.Response response = await http.put(
      _baseUrl + "/posts/1",
      headers: {
        "Content-type": "application/json; charset=UTF-8"
      },
      body: jsonEncode({
        "userId": 120,
        "id": null,
        "title": "Titulo alterado",
        "body": "Corpo da postagem alterada",
      }),
    );

    print("Resposta: ${response.statusCode}");
    print("Resposta: ${response.body}");

  }

  void _patch() async {

    http.Response response = await http.patch(
      _baseUrl + "/posts/2",
      headers: {
        "Content-type": "application/json; charset=UTF-8"
      },
      body: jsonEncode({
        "userId": 120,
        "title": "Titulo alterado",
      }),
    );

    print("Resposta: ${response.statusCode}");
    print("Resposta: ${response.body}");

  }

  void _delete() async {

    http.Response response = await http.delete(_baseUrl + "/posts/2");

    print("Resposta: ${response.statusCode}");
    print("Resposta: ${response.body}");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de serviço avançado"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Text("Salvar"),
                  onPressed: _post,
                ),
                RaisedButton(
                  child: Text("Atualizar"),
                  onPressed: _put,
                ),
                RaisedButton(
                  child: Text("Remover"),
                  onPressed: _delete,
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Post>>(
                future: _getPosts(),
                builder: (context, snapshot) {

                  switch(snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                      break;

                    case ConnectionState.active:
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        print("lista: erro ao carregar");
                      } else {

                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {

                            List<Post> list = snapshot.data;
                            Post post = list[index];

                            return ListTile(
                              title: Text(post.title),
                              subtitle: Text(post.body),
                            );

                          }
                        );

                      }
                      break;
                  }

                  return Text("Erro ao carregar");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
