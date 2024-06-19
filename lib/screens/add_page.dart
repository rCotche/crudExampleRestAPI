import 'package:crud_rest_example/services/todo_service.dart';
import 'package:crud_rest_example/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  final Map? todo;
  const AddPage({super.key, this.todo});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  final url = 'https://api.nstack.in';

  //body act like a variable
  Map get body {
    final title = titleController.text;
    final description = descriptionController.text;
    return {"title": title, "description": description, "is_completed": false};
  }

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    //widget est comparable à this
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  //Insert

  //ce serait bien si la func refresh la totdo list après avoir send data
  Future<void> submitData() async {
    /////////////////////
    // ACIENNE VERSION //
    /////////////////////
    ///// //get data
    // final title = titleController.text;
    // final description = descriptionController.text;
    // final body = {
    //   "title": title,
    //   "description": description,
    //   "is_completed": false
    // };
    // //send the data to the server
    // final insertUrl =
    //     '$url/v1/todos'; //pour concatener | en dart on dit + souvent interpolation
    // //url converti en uri
    // final uri = Uri.parse(insertUrl);
    // //execute la request
    // //puis store la reponse que le serveur envoi dans la variable response

    // //[body] sets the body of the request. It can be a [String], a [List] or a [Map<String, String>].
    // //check la doc de la fonction post en hover le mot post
    // //pour savoir comment la fonction reagi en fonction de
    // //si c'est a [String], a [List] or a [Map<String, String>]

    // //jsonEncode : Converts [object] to a JSON string.
    // //parce que body c'est un Map<String, Object> et donc ne fait pas parti des 3 types accepté
    // final response = await http.post(
    //   uri,
    //   body: jsonEncode(body),
    //   headers: {'Content-Type': 'application/json'},
    // );

    //show success//

    //response.body indique davantage d'information
    //faudra remplacer cette partie par un try catch
    //ou check dans wether app comment s'est gérer l'appel avec l'api
    // if (response.statusCode == 201) {
    //   titleController.text = '';
    //   descriptionController.text = '';
    //   if (!mounted) return;
    //   showMessage(context, message: 'Success !', isSuccess: true);
    // } else {
    //   if (!mounted) return;
    //   showMessage(context, message: 'Failed !', isSuccess: false);
    // }

    final isSuccess = await TodoService.addToDo(body);
    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
      if (!mounted) return;
      showMessage(context, message: 'Success !', isSuccess: true);
    } else {
      if (!mounted) return;
      showMessage(context, message: 'Failed !', isSuccess: false);
    }
  }

// uPDATE
  Future<void> editData() async {
    //get data
    final todo = widget.todo;
    if (todo == null) {
      debugPrint('Error');
      return;
    }
    final id = todo['_id'];
    //
    final isSuccess = await TodoService.updateToDo(id, body);
    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
      if (!mounted) return;
      showMessage(context, message: 'Success !', isSuccess: true);
    } else {
      if (!mounted) return;
      showMessage(context, message: 'Failed !', isSuccess: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: isEdit ? const Text('Edit todo') : const Text('Add todo'),
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
            onPressed: isEdit ? editData : submitData,
            child: isEdit ? const Text('update') : const Text('submit'),
          )
        ],
      ),
    );
  }
}
