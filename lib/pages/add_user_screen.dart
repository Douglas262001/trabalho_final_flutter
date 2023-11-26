import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/api_service.dart';
import '../models/user.dart';

class AddUserScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final APIService apiService = APIService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Usuário'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Por favor, insira o nome';
                }
                return null;
              },
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'[^\s@]+@[^\s@]+\.[^\s@]+'))
              ],
              validator: (value) {
                if (!value!.contains('@')) {
                  return 'Insira um e-mail válido';
                }
                return null;
              },
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                labelText: 'Telefone',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor, insira o nome'),
                    ),
                  );
                } else if (!emailController.text.contains('@')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Insira um e-mail válido'),
                    ),
                  );
                } else {
                  User newUser = User(
                    id: 0,
                    name: nameController.text,
                    email: emailController.text,
                    phone: phoneController.text,
                  );

                  apiService.createUser(newUser).then((User createdUser) {
                    Navigator.pop(context);
                    print('Novo usuário criado - ID: ${createdUser.id}');
                  }).catchError((error) {
                    print('Erro ao criar usuário: $error');
                  });
                }
              },
              child: Text('Criar Usuário'),
            ),
          ],
        ),
      ),
    );
  }
}
