import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:minhas_anotacoes/helper/AnnotationHelper.dart';
import 'package:minhas_anotacoes/model/Annotation.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _db = AnnotationHelper();

  List<Annotation> _annotations = List<Annotation>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  _saveUpdateAnnotation({ Annotation annotationSelected }) async {
    String title = _titleController.text;
    String description = _descriptionController.text;
    String date = DateTime.now().toString();

    if (annotationSelected == null) {
      Annotation annotation = Annotation(title, description, date);
      int result = await _db.saveAnnotation(annotation);
    } else {
      annotationSelected.title = title;
      annotationSelected.description = description;
      annotationSelected.date = date;
      int result = await _db.updateAnnotation(annotationSelected);
    }

    _retriveAnnotations();
  }

  _retriveAnnotations() async {
    List annotations = await _db.listAnnotations();

    List<Annotation> tempList = List<Annotation>();
    for(var item in annotations) {
      Annotation annotation = Annotation.fromMap(item);
      tempList.add(annotation);
    }

    setState(() {
      _annotations = tempList;
    });

    tempList = null;
  }

  _removeAnnotation(int id) async {
    int result = await _db.removeAnnotation(id);
    _retriveAnnotations();
  }

  String _formatDate(String date) {
    initializeDateFormatting("pt_BR");

    DateTime parsedDate = DateTime.parse(date);
    // return DateFormat("dd/MM/y HH:mm").format(parsedDate).toString();
    // return DateFormat.yMMMMd("pt_BR").format(parsedDate).toString();
    return DateFormat.yMd("pt_BR").format(parsedDate).toString();
  }

  _showAddScreen({ Annotation annotation }) {

    String textTitle= "Adicionar";
    String textButton= "Salvar";
    _titleController.text = "";
    _descriptionController.text = "";

    if (annotation != null) {
      textTitle = "Atualizar";
      textButton = "Atualizar";
      _titleController.text = annotation.title;
      _descriptionController.text = annotation.description;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("$textTitle Anotação"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _titleController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Título",
                  hintText: "Digite o título..."
                ),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Descrição",
                  hintText: "Digite a descrição..."
                ),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            FlatButton(
              onPressed: () {
                _saveUpdateAnnotation(annotationSelected: annotation);
                Navigator.pop(context);
              },
              child: Text(textButton),
            ),
          ],
        );
      }
    );
  }

  @override
  void initState() {
    super.initState();

    _retriveAnnotations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas anotações"),
        backgroundColor: Colors.lightGreen,
      ),

      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _annotations.length,
              itemBuilder: (context, index) {

                final annotation = _annotations[index];

                return Card(
                  child: ListTile(
                    title: Text(annotation.title),
                    subtitle: Text(
                      "${_formatDate(annotation.date)} - ${annotation.description}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Icon(
                              Icons.edit,
                              color: Colors.green,
                            ),
                          ),
                          onTap: () => _showAddScreen(annotation: annotation),
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                          onTap: () => _removeAnnotation(annotation.id),
                        ),
                      ],
                    ),
                  ),
                );

              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: _showAddScreen,
      ),
    );
  }
}
