import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_super/pages/login.dart';

class ForgotPass extends StatelessWidget {
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
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 6, 80, 7),
        title: const Center(
          child: Text('Forgot Password',
          style: TextStyle(
            fontFamily: 'Gagalin',
            //fontweight: FontWeight.bold,
            fontSize: 40,
            letterSpacing: 0.8,
            shadows: [Shadow( blurRadius: 60.0,
        color: Colors.black,
        offset: Offset(5.0, 5.0),)],
            color: Color.fromARGB(255, 245, 245, 220)
          ),),
        ),  
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10),
              Image.asset('images/SUPER GO 8.png'),
              SizedBox(height: 20),
              Text(
                'Forgot Your Password?',
                style: TextStyle(
              fontFamily: 'Gagalin',
              //fontweight: FontWeight.bold,
              fontSize: 30,
              letterSpacing: 0.8,
              color: Color.fromARGB(255, 6, 80, 7)
            ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              Text(
                'Please enter your email address. We will send you a password reset link.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0,
                  fontFamily: 'Gagalin'),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                        prefixStyle: TextStyle(fontFamily: 'Gagalin',
                        color: Colors.black,
                        fontSize: 17),
                        labelText: "Email",
                        labelStyle: TextStyle(fontFamily: 'Gagalin',
                        //fontweight: FontWeight.bold,
                        color: Color.fromARGB(255, 6, 80, 7),
                        fontSize: 20),
                        prefixIcon: Icon(Icons.email),
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
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () {
                  Get.off(LoginPage());
                  // Add functionality to send the reset password link
                  // Here, you might use the entered email to send the reset link
                  // You can use a service or API to handle this functionality
                  // For example: AuthService.sendResetPasswordLink(email);
                },
                child: Text('Send Reset Link',
                style: TextStyle(fontFamily: 'Gagalin', letterSpacing: 0.8, fontSize: 25),),
                style: raisedButtonStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
