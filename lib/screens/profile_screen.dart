import 'dart:ui';
import 'package:diploma/data/models/user_model.dart';
import 'package:diploma/models/result.dart';
import 'package:diploma/presentations/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController usernameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController repeatPasswordController;

  int selectedIndex = 0;
  bool showOption = false;
  late AuthCubit authCubit;
  UserModel? user;
  bool userAuthorized = false;
  bool isRegisterPage = false;
  Result<UserModel?>? userResult;
  bool isLoading = false;

  @override
  void initState() {
    getUserInfo();
    usernameController = TextEditingController(text: '');
    passwordController = TextEditingController(text: '');
    emailController = TextEditingController(text: '');
    repeatPasswordController = TextEditingController(text: '');
    super.initState();
  }

  Future<void> getUserInfo() async {
    userResult = await context.read<AuthCubit>().getUserInfo();
    if (userResult != null && userResult!.isSuccess) {
      setState(() {
        user = userResult!.data;
        userAuthorized = true;
      });
    } else {
      setState(() {
        userAuthorized = false;
      });
      print('Error: ${userResult?.errorMessage}');
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  String? validateEmail(String? value) {
    const pattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regExp = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return 'Введите E-Mail';
    } else if (!regExp.hasMatch(value)) {
      return 'Введите корректный E-Mail';
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Имя пользователя не должно быть пустым';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите пароль';
    } else if (value.length < 8 || value.length > 30) {
      return 'Пароль должен быть от 8 до 30 символов';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userAuthorized
          ? user != null
          ? buildUserProfile()
          : Center(child: CircularProgressIndicator())
          : buildAuthForm(),
    );
  }

  Widget buildUserProfile() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    user!.username[0].toUpperCase(),
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  user!.username,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  user!.email!,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              SizedBox(height: 30),
              Divider(),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Настройки'),
                onTap: () {
                  // Handle settings
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Выйти', style: TextStyle(color: Colors.red)),
                onTap: () async {
                  await context.read<AuthCubit>().logout();
                  setState(() {
                    userAuthorized = false;
                    user = null; // Reset the user on logout
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAuthForm() {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.purple.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        alignment: Alignment.center,
        child: isLoading
            ? CircularProgressIndicator()
            : Container(
          height: 400,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(15),
            color: Colors.black.withOpacity(0.3),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (isRegisterPage)
                          TextFormField(
                            controller: emailController,
                            validator: validateEmail,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              hintText: 'E-Mail',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                            ),
                          ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: usernameController,
                          validator: validateUsername,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            hintText: 'Имя пользователя',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          validator: validatePassword,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            hintText: 'Пароль',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (isRegisterPage)
                          TextFormField(
                            controller: repeatPasswordController,
                            obscureText: true,
                            validator: (value) {
                              if (value != passwordController.text) {
                                return 'Пароли не совпадают';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              hintText: 'Повторите пароль',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                            ),
                          ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                if (isRegisterPage) {
                                  await context.read<AuthCubit>().register(
                                      username: usernameController.text,
                                      password: passwordController.text,
                                      email: emailController.text);
                                } else {
                                  await context.read<AuthCubit>().login(
                                      username: usernameController.text,
                                      password: passwordController.text);
                                }
                                await getUserInfo();
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            child: Text(isRegisterPage
                                ? 'Зарегистрироваться'
                                : 'Войти'),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isRegisterPage = !isRegisterPage;
                            });
                          },
                          child: Text(
                            isRegisterPage
                                ? 'Уже есть аккаунт? Войти'
                                : 'Еще нет аккаунта? Зарегистрироваться',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
