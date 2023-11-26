import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/api_service.dart';
import '../models/user.dart';

class EditUserScreen extends StatelessWidget {
  final User user;

  EditUserScreen(this.user);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    nameController.text = user.name;
    emailController.text = user.email;
    phoneController.text = user.phone;

    final APIService apiService = APIService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Usuário'),
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
                if (nameController.text?.isEmpty ?? true) {
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
                  User updatedUser = User(
                    id: user.id,
                    name: nameController.text,
                    email: emailController.text,
                    phone: phoneController.text,
                  );

                  apiService.updateUser(user.id, updatedUser).then((User user) {
                    Navigator.pop(context);
                    print('Usuário atualizado - ID: ${user.id}');
                  }).catchError((error) {
                    print('Erro ao atualizar usuário: $error');
                  });
                }
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
