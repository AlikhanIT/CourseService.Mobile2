import 'dart:ui';

import 'package:diploma/data/models/user_model.dart';
import 'package:diploma/models/result.dart';
import 'package:diploma/presentations/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/bg_data.dart';
import '../util/text_util.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController usernameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController repeatPasswordController;

  int selectedIndex = 0;
  bool showOption = false;
  late AuthCubit authCubit;
  late UserModel user;
  bool userAuthorized = false;
  bool isRegisterPage = false;
  late Result<UserModel?> userResult;
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
    if (userResult.isSuccess) {
      setState(() {
        user = userResult.data!;
        userAuthorized = true;
      });
    } else {
      setState(() {
        userAuthorized = false;
      });
      print('Error: ${userResult.errorMessage}');
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

  @override
  Widget build(BuildContext context) {
    return userAuthorized
        ? Scaffold(
      body: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .5,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.elliptical(
                              MediaQuery.of(context).size.width * 0.5, 100.0),
                          bottomRight: Radius.elliptical(
                              MediaQuery.of(context).size.width * 0.5, 100.0),
                        ),
                        image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              'https://i.pinimg.com/564x/1e/7f/85/1e7f85e354e1a11b4a439ac9d9f7e283.jpg'),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Stack(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          child: Icon(
                            Icons.close,
                            color: Color(0xffC3C3C3),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 40),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              user.username,
                              style: const TextStyle(
                                color: Color(0xffBDBDBD),
                                fontSize: 35,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(0xffD8D8D8),
                          child: Icon(
                            Icons.chat,
                            size: 30,
                            color: Color(0xff6E6E6E),
                          ),
                        ),
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage(
                              'https://i.pinimg.com/564x/1e/7f/85/1e7f85e354e1a11b4a439ac9d9f7e283.jpg'),
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(0xffD8D8D8),
                          child: Icon(
                            Icons.call,
                            size: 30,
                            color: Color(0xff6E6E6E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Text(
                user.email!,
                style: TextStyle(fontSize: 15),
              ),
            ),
            GestureDetector(
              child: const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text("Выйти"),
              ),
              onTap: () async {
                await context.read<AuthCubit>().logout();
                setState(() {
                  userAuthorized = false;
                });
              },
            ),
          ],
        ),
      ),
    )
        : Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 49,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
                child: showOption
                    ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: bgList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: selectedIndex == index
                              ? Colors.white
                              : Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(1),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(
                                bgList[index],
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                    : const SizedBox()),
            const SizedBox(
              width: 20,
            ),
            showOption
                ? GestureDetector(
                onTap: () {
                  setState(() {
                    showOption = false;
                  });
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ))
                : GestureDetector(
              onTap: () {
                setState(() {
                  showOption = true;
                });
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(
                      bgList[selectedIndex],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(bgList[selectedIndex]), fit: BoxFit.fill),
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
            color: Colors.black.withOpacity(0.1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    isRegisterPage
                        ? Center(
                        child: TextUtil(
                          text: "Регистрация",
                          weight: true,
                          size: 30,
                        ))
                        : Center(
                        child: TextUtil(
                          text: "Авторизация",
                          weight: true,
                          size: 30,
                        )),
                    const Spacer(),
                    TextUtil(
                      text: "Имя пользователя",
                    ),
                    Container(
                      height: 35,
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.white))),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.mail,
                            color: Colors.white,
                          ),
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                        controller: usernameController,
                      ),
                    ),
                    isRegisterPage
                        ? TextUtil(
                      text: "E-Mail",
                    )
                        : Container(),
                    isRegisterPage
                        ? Container(
                      height: 35,
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.white))),
                      child: TextFormField(
                        style: const TextStyle(
                            color: Colors.white),
                        decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                        controller: emailController,
                      ),
                    )
                        : Container(),
                    const Spacer(),
                    TextUtil(
                      text: "Пароль",
                    ),
                    Container(
                      height: 35,
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.white))),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                        controller: passwordController,
                      ),
                    ),
                    isRegisterPage
                        ? TextUtil(
                      text: "Повторный пароль",
                    )
                        : Container(),
                    isRegisterPage
                        ? Container(
                        height: 35,
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.white))),
                        child: TextFormField(
                          style: const TextStyle(
                              color: Colors.white),
                          decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                            fillColor: Colors.white,
                            border: InputBorder.none,
                          ),
                          controller: repeatPasswordController,
                        ))
                        : Container(),
                    const Spacer(),
                    GestureDetector(
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });
                          if (isRegisterPage) {
                            if (passwordController.text ==
                                repeatPasswordController.text) {
                              await context
                                  .read<AuthCubit>()
                                  .register(
                                  username:
                                  usernameController.text,
                                  password:
                                  passwordController.text);
                              var then = await context
                                  .read<AuthCubit>()
                                  .getUserInfo();
                              if (then.isSuccess) {
                                setState(() {
                                  user = then.data!;
                                  userAuthorized = true;
                                });
                              }
                            }
                          } else {
                            var auth = await context
                                .read<AuthCubit>()
                                .login(
                                username:
                                usernameController.text,
                                password:
                                passwordController.text);
                            var data = await context
                                .read<AuthCubit>()
                                .getUserInfo();
                            if (data.isSuccess) {
                              setState(() {
                                user = data.data!;
                                userAuthorized = true;
                              });
                            }
                          }
                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: Container(
                          height: 40,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(30)),
                          alignment: Alignment.center,
                          child: TextUtil(
                              text: "Войти",
                              color: Colors.black),
                        )),
                    const Spacer(),
                    GestureDetector(
                        child: Center(
                            child: TextUtil(
                              text: !isRegisterPage
                                  ? "Регистрация"
                                  : "Авторизация",
                              size: 12,
                              weight: true,
                            )),
                        onTap: () {
                          setState(() {
                            isRegisterPage = !isRegisterPage;
                          });
                        }),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}