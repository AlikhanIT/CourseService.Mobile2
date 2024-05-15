// import 'package:flutter/material.dart';
// import '../models/user.dart';
//
// class ProfileScreen extends StatelessWidget {
//   final User user;
//
//   ProfileScreen({required this.user});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Профиль'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Имя: ${user.name}',
//               style: TextStyle(fontSize: 20.0),
//             ),
//             Text(
//               'Email: ${user.email}',
//               style: TextStyle(fontSize: 20.0),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//

import 'dart:ui';

import 'package:diploma/presentations/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/bg_data.dart';
import '../util/text_util.dart';
import 'authorization/animations.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;
  int selectedIndex=0;
  bool showOption=false;
  late AuthCubit authCubit;

  @override
  void initState() {
    usernameController = TextEditingController(text: '');
    passwordController = TextEditingController(text: '');
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin:const  EdgeInsets.symmetric(vertical: 10),
        height: 49,
        width: double.infinity,

        child: Row(
          children: [
            Expanded(
                child:showOption? ShowUpAnimation(
                  delay: 100,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: bgList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context,index){
                        return   GestureDetector(
                          onTap: (){
                            setState(() {
                              selectedIndex=index;
                            });
                          },
                          child: CircleAvatar(
                            radius: 30,

                            backgroundColor:selectedIndex==index? Colors.white:Colors.transparent,
                            child: Padding(
                              padding:const  EdgeInsets.all(1),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(bgList[index],),
                              ),
                            ),
                          ),
                        );

                      }),
                ):const SizedBox()),
            const  SizedBox(width: 20,),
            showOption? GestureDetector(
                onTap: (){
                  setState(() {
                    showOption=false;
                  });
                },
                child:const  Icon(Icons.close,color: Colors.white,size: 30,)) :
            GestureDetector(
              onTap: (){
                setState(() {
                  showOption=true;
                });
              },
              child: CircleAvatar(

                backgroundColor: Colors.white,
                child: Padding(
                  padding:const  EdgeInsets.all(1),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(bgList[selectedIndex],),
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
        decoration:  BoxDecoration(
          image: DecorationImage(
              image: AssetImage(bgList[selectedIndex]),fit: BoxFit.fill
          ),

        ),
        alignment: Alignment.center,
        child: Container(
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
            child: BackdropFilter(filter:ImageFilter.blur(sigmaY: 5,sigmaX: 5),
                child:Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const   Spacer(),
                      Center(child: TextUtil(text: "Авторизация",weight: true,size: 30,)),
                      const   Spacer(),
                      TextUtil(text: "Имя пользователя",),
                      Container(
                        height: 35,
                        decoration:const  BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.white))
                        ),
                        child:TextFormField(
                          style: const TextStyle(color: Colors.white),
                          decoration:const  InputDecoration(
                            suffixIcon: Icon(Icons.mail,color: Colors.white,),
                            fillColor: Colors.white,
                            border: InputBorder.none,),
                          controller: usernameController,
                        ),
                      ),
                      const   Spacer(),
                      TextUtil(text: "Пароль", ),
                      Container(
                        height: 35,
                        decoration:const  BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.white))
                        ),
                        child:TextFormField(
                          style: const TextStyle(color: Colors.white),
                          decoration:const  InputDecoration(
                            suffixIcon: Icon(Icons.lock,color: Colors.white,),
                            fillColor: Colors.white,
                            border: InputBorder.none,),
                          controller: passwordController,
                        ),
                      ),
                      const   Spacer(),
                      GestureDetector(
                        onTap: () {
                           context.read<AuthCubit>().login(username: usernameController.text, password: passwordController.text);
                        },
                        child:
                      Container(
                        height: 40,
                        width: double.infinity,
                        decoration:  BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)
                        ),
                        alignment: Alignment.center,
                        child: TextUtil(text: "Войти",color: Colors.black),
                      )),
                      const   Spacer(),
                      Center(child: TextUtil(text: "Регистрация",size: 12,weight: true,)),
                      const   Spacer(),
                    ],
                  ),
                ) ),
          ),
        ),
      ),
    );
  }
}