import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final url = 'https://api.nstack.in';

  //Update

  //ce serait bien si la func refresh la totdo list après avoir send data
  Future<void> editData() async {
    //get data
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    //send the data to the server
    final insertUrl =
        '$url/v1/todos'; //pour concatener | en dart on dit + souvent interpolation
    //url converti en uri
    final uri = Uri.parse(insertUrl);
    //execute la request
    //puis store la reponse que le serveur envoi dans la variable response

    //[body] sets the body of the request. It can be a [String], a [List] or a [Map<String, String>].
    //check la doc de la fonction post en hover le mot post
    //pour savoir comment la fonction reagi en fonction de
    //si c'est a [String], a [List] or a [Map<String, String>]

    //jsonEncode : Converts [object] to a JSON string.
    //parce que body c'est un Map<String, Object> et donc ne fait pas parti des 3 types accepté
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    //show success

    //response.body indique davantage d'information

    //faudra remplacer cette partie par un try catch
    //ou check dans wether app comment s'est gérer l'appel avec l'api
    if (response.statusCode == 201) {
      titleController.text = '';
      descriptionController.text = '';
      showMessage('Success !', true);
    } else {
      showMessage('Failed !', false);
    }
  }

  void showMessage(String message, bool isSuccess) {
    final SnackBar snackbar;
    //moi
    isSuccess
        ? snackbar = SnackBar(
            content: Text(message),
            backgroundColor: Colors.green[200],
          )
        : snackbar = SnackBar(
            content: Text(message),
            backgroundColor: Colors.red[200],
          );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Edit todo'),
      ),
      //utilise listview ici pour que qd le clavier est trigger
      //quand on tape dans le champs texte il n'y a pas d'erreur
      body: ListView(
        //pour que ça ne soit pas collé au bord de l'écran
        padding: const EdgeInsets.all(15),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Description'),
            //Requests the default platform keyboard,
            //but accepts newlines when the enter key is pressed.
            //This is the input type used for all multiline text fields.
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: editData,
            child: const Text('submit'),
          )
        ],
      ),
    );
  }
}
