import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_super/pages/forgot_password.dart';
import 'package:go_super/pages/home_page.dart';
import 'package:go_super/pages/sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();
  bool seepass = true;
  final _usernameController = TextEditingController();

  final _passwordController = TextEditingController();
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: const Color.fromARGB(255, 245, 245, 220), 
  backgroundColor: const Color.fromARGB(255, 6, 80, 7),
  textStyle: const TextStyle(fontFamily: 'Gagalin', fontSize: 30, letterSpacing: 2.5),
  minimumSize: const Size(100, 50),
  padding: const EdgeInsets.symmetric(horizontal: 20),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
);
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 236, 205),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 6, 80, 7),
        title: const Center(
          child: Text('Sign In',
          style: TextStyle(
            fontFamily: 'Gagalin',
            //fontweight: FontWeight.bold,
            fontSize: 45,
            letterSpacing: 0.8,
            shadows: [Shadow( blurRadius: 60.0,
        color: Colors.black,
        offset: Offset(5.0, 5.0),)],
            color: Color.fromARGB(255, 236, 236, 205)
          ),),
        ),
      ),
      body: SingleChildScrollView(
                  child: Form(
          key: formkey,
          child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  Image.asset(
                   "images/SUPER GO 3.png",
                   fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 30,),
                  TextFormField(
                    controller: _usernameController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      prefixStyle: TextStyle(fontFamily: 'Gagalin',
                      color: Colors.black,
                      fontSize: 17),
                      labelText: "Username",
                      labelStyle: TextStyle(fontFamily: 'Gagalin',
                      //fontweight: FontWeight.bold,
                      color: Color.fromARGB(255, 6, 80, 7),
                      fontSize: 20),
                      prefixIcon: Icon(Icons.person),
                      prefixIconColor: Color.fromARGB(255, 6, 80, 7),
                      hintText: "Enter your email",
                      hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 17),
                      contentPadding: EdgeInsetsDirectional.only(top: 25, bottom: 10),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 6, 80, 7)),
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 6, 80, 7))
                        
                      )
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: seepass,
                    decoration: const InputDecoration(
                      prefixStyle: TextStyle(fontFamily: 'Gagalin',
                      color: Colors.black,
                      fontSize: 17),
                      labelText: "Password",
                      labelStyle: TextStyle(fontFamily: 'Gagalin',
                      //fontweight: FontWeight.bold,
                      color: Color.fromARGB(255, 6, 80, 7),
                      fontSize: 20),
                      prefixIcon: Icon(Icons.lock),
                      prefixIconColor: Color.fromARGB(255, 6, 80, 7),
                      
                      hintText: "Enter your password",
                      hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 17),
                      contentPadding: EdgeInsetsDirectional.only(top: 25, bottom: 10),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 6, 80, 7)),
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 6, 80, 7))
                        
                      )
                    ),
                  ),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: (){
                      Get.to(ForgotPass());
                    }, child: const Text("Forgot Password?",
                    style: TextStyle(fontSize: 16,fontFamily: 'Gagalin',fontWeight: FontWeight.bold ,color: Color.fromARGB(255, 6, 80, 7),)),)
                  ],
                ),
                  const SizedBox(height: 20,
                  ),
                  ElevatedButton(
                    style: raisedButtonStyle,
                    onPressed: (){
                      Get.off(const HomePage());
                    }, 
                    child: const Text('Sign In',
                    style: TextStyle(fontFamily: 'Gagalin', letterSpacing: 0.8, fontSize: 30),),
                  ),
                  const SizedBox(height: 20.0,),
                  const Column(
                    children: [
                      Text("---------- OR ----------",style: TextStyle(fontSize: 20, fontFamily: 'Gagalin'),)],
                    ),
                  const SizedBox(height: 10.0,),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account ?",
                          style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        TextButton(onPressed: (){
                          Get.to(const SignupPage());
                        }, child: const Text("Sign Up",style: TextStyle(fontSize: 20,fontFamily: 'Gagalin',letterSpacing: 0.8,color: Color.fromARGB(255, 6, 80, 7),),),)
                      ],
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
                  ),
                );
  }
}