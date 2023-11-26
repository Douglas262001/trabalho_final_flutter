import 'package:flutter/material.dart';
import '../components/api_service.dart';
import '../models/user.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final APIService apiService = APIService();
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() {
    apiService.fetchUsers().then((List<User> fetchedUsers) {
      setState(() {
        users = fetchedUsers;
      });
    }).catchError((error) {
      print('Erro para buscar usuários: $error');
    });
  }

  void navigateToAddUserScreen() {
    Navigator.pushNamed(context, '/addUser').then((_) => fetchUsers());
  }

  void _editUser(User user) {
    Navigator.pushNamed(context, '/editUser', arguments: user)
        .then((_) => fetchUsers());
  }

  void _deleteUser(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar exclusão'),
          content: Text('Tem certeza de que deseja excluir este usuário?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Excluir'),
              onPressed: () {
                apiService.deleteUser(user.id).then((_) {
                  setState(() {
                    users.removeWhere((element) => element.id == user.id);
                  });
                  Navigator.of(context).pop();
                  print('Usuário deletado');
                }).catchError((error) {
                  print('Erro ao deletar o usuário: $error');
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuários'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
              onPressed: navigateToAddUserScreen,
              child: Text('Adicionar Usuário'),
            ),
            SizedBox(height: 20.0),
            Text(
              'Usuários:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 2.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                          'ID: ${users[index].id} \nNome: ${users[index].name}'),
                      subtitle: Text(
                          'Email: ${users[index].email} \nTelefone: ${users[index].phone}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _editUser(users[index]);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteUser(users[index]);
                            },
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
      ),
    );
  }
}