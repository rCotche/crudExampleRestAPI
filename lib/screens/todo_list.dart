import 'package:crud_rest_example/screens/add_page.dart';
import 'package:crud_rest_example/services/todo_service.dart';
import 'package:crud_rest_example/utils/snackbar_helper.dart';
import 'package:crud_rest_example/widget/todo_card.dart';
import 'package:flutter/material.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({super.key});

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  //check wether app pour la gestion des chragements
  bool isLoading = true;
  List items = [];

  // Moi //Pour changer de page
  // Future<void> navigateToEditPage() async {
  //   final route = MaterialPageRoute(builder: (context) => const EditPage());
  //   await Navigator.push(context, route);
  //   //à améliorer car refresh automatiquement meme si on ne fait rien sur la page
  //   setState(() {
  //     isLoading = true;
  //   });
  //   fetchTodo();
  // }

  //Pour changer de page
  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddPage(),
    );
    await Navigator.push(context, route);
    //à améliorer car refresh automatiquement meme si on ne fait rien sur la page
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  //Pour changer de page
  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddPage(
        todo: item,
      ),
    );
    await Navigator.push(context, route);
    //à améliorer car refresh automatiquement meme si on ne fait rien sur la page
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  //Future à chaque fois qu'on attend qlq chose de l'extérieur
  //pour une ui qui consomme des api ce sera forcement toujours un Future

  //Get
  Future<void> fetchTodo() async {
    final response = await TodoService.fetchTodos();
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      if (!mounted) return;
      showMessage(context, message: 'Failed !', isSuccess: false);
    }
    setState(() {
      isLoading = false;
    });
  }

  //Delete
  Future<void> deleteById(String id) async {
    final isSuccess = await TodoService.deleteById(id);
    if (isSuccess) {
      //remove from the list au niveau du client

      //get les item dont l'id est différent de l'id qu'on supprime
      //et avec ses items on fait de nouveau une liste
      final filtered = items.where((item) => item['_id'] != id).toList();
      //on met à jour la liste des items avec la nouvelle liste
      setState(() {
        items = filtered;
      });
      //To remove this warning
      //Don't use 'BuildContext's across async gaps.
      //Try rewriting the code to not use the 'BuildContext', or guard the use with a 'mounted' check.
      if (!mounted) return;
      showMessage(context, message: 'Success !', isSuccess: true);
    } else {
      if (!mounted) return;
      showMessage(context, message: 'Failed !', isSuccess: false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Todo list'),
      ),
      //
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          //
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                'pas d\'item',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            //
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                //
                final item = items[index] as Map;
                //
                return ToDoCard(
                    index: index,
                    item: item,
                    navigate: navigateToEditPage,
                    deleteById: deleteById);
              },
            ),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      //Creates a wider [StadiumBorder]-shaped floating action button with an optional [icon] and a [label].
      floatingActionButton: FloatingActionButton.extended(
        //Navigator.push returns a Future and onPressed accepts void,
        //which is why you can't directly assign Navigator.push to onPressed,
        //however when you do onPressed: () =>  You're simply executing Navigator.push(...)
        //inside the callback provided by onPressed.
        onPressed: () {
          navigateToAddPage();
        },
        label: const Text('add todo'),
      ),
    );
  }
}
