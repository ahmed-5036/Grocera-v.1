import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_super/pages/verify_name.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

bool _containsUpperCase(String value) {
    return value.contains(RegExp(r'[A-Z]'));
  }

bool _containsLowerCase(String value) {
    return value.contains(RegExp(r'[a-z]'));
  }
bool _isCheckBoxChecked = false;
  bool _containsNumber(String value) {
    return value.contains(RegExp(r'[0-9]'));
  }
bool _isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );
    return emailRegex.hasMatch(email);
  }

class _SignupPageState extends State<SignupPage> {
  DateTime? _selectedDate;
  Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
  );

  if (picked != null && picked != _selectedDate) {
    setState(() {
      _selectedDate = picked;
      _birthdateController.text =
          '${picked.day}/${picked.month}/${picked.year}';
    });
  }
}

  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _addressController = TextEditingController();
  final _formmkey = GlobalKey<FormState>();
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
          child: Text('Sign Up',
          style: TextStyle(
            fontFamily: 'Gagalin',
            //fontweight: FontWeight.bold,
            fontSize: 45,
            letterSpacing: 0.8,
            shadows: [Shadow( blurRadius: 60.0,
        color: Colors.black,
        offset: Offset(5.0, 5.0),)],
            color: Color.fromARGB(255, 245, 245, 220)
          ),),
        ),  
      ),
      body: SingleChildScrollView(
        child: Form(key: _formmkey,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Image.asset("images/SUPER GO 6.png"),
                Container(height: 3, color: const Color.fromARGB(255, 6, 80, 7)),
                const SizedBox(height: 10),
                TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {

                          if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                          } else if (!_isValidEmail(value)) {
                             return 'Please enter a valid email';
                            }
                          return null;
                        },
                        decoration: const InputDecoration(
                          prefixStyle: TextStyle(fontFamily: 'Gagalin',
                          color: Colors.black,
                          fontSize: 17),
                          labelText: "Email",
                          labelStyle: TextStyle(fontFamily: 'Gagalin',
                          //fontweight: FontWeight.bold,
                          color: Color.fromARGB(255, 6, 80, 7),
                          fontSize: 30),
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
                      ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _fnameController,
                        validator: (value){
                            if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          prefixStyle: TextStyle(fontFamily: 'Gagalin',
                          color: Colors.black,
                          fontSize: 17),
                          labelText: "First Name",
                          labelStyle: TextStyle(fontFamily: 'Gagalin',
                          //fontweight: FontWeight.bold,
                          color: Color.fromARGB(255, 6, 80, 7),
                          fontSize: 30),
                          prefixIcon: Icon(Icons.person),
                          prefixIconColor: Color.fromARGB(255, 6, 80, 7),
                          hintText: "Write your first name",
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
                    ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                          controller: _lnameController,
                          keyboardType: TextInputType.text,
                          validator: (value){
                            if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                          },
                          decoration: const InputDecoration(
                            prefixStyle: TextStyle(fontFamily: 'Gagalin',
                            color: Colors.black,
                            fontSize: 17),
                            labelText: "Last Name",
                            labelStyle: TextStyle(fontFamily: 'Gagalin',
                            //fontweight: FontWeight.bold,
                            color: Color.fromARGB(255, 6, 80, 7),
                            fontSize: 30),
                            prefixIcon: Icon(Icons.person),
                            prefixIconColor: Color.fromARGB(255, 6, 80, 7),
                            hintText: "Write your family name",
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
                ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                        controller: _passController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                } else if (value.length < 8) {
                  return 'Password must be at least 8 characters';
                } else if (!_containsUpperCase(value)) {
                  return 'Password must contain at least one uppercase letter';
                } else if (!_containsLowerCase(value)) {
                  return 'Password must contain at least one lowercase letter';
                } else if (!_containsNumber(value)) {
                  return 'Password must contain at least one number';
                }
                return null;
              },
                        decoration: const InputDecoration(
                          prefixStyle: TextStyle(fontFamily: 'Gagalin',
                          color: Colors.black,
                          fontSize: 17),
                          labelText: "Password",
                          labelStyle: TextStyle(fontFamily: 'Gagalin',
                          //fontweight: FontWeight.bold,
                          color: Color.fromARGB(255, 6, 80, 7),
                          fontSize: 30),
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
                const SizedBox(height: 20),
                TextFormField(
                        controller: _addressController,
                        keyboardType: TextInputType.text,
                        validator: (value){
                          if (value == null || value.isEmpty) {
                              return 'Please enter your address';
                              }
                          return null;
                        },
                        decoration: const InputDecoration(
                          prefixStyle: TextStyle(fontFamily: 'Gagalin',
                          color: Colors.black,
                          fontSize: 17),
                          labelText: "Address",
                          labelStyle: TextStyle(fontFamily: 'Gagalin',
                          //fontweight: FontWeight.bold,
                          color: Color.fromARGB(255, 6, 80, 7),
                          fontSize: 30),
                          prefixIcon: Icon(Icons.house),
                          prefixIconColor: Color.fromARGB(255, 6, 80, 7),
                          hintText: "Enter your address",
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
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _birthdateController,
                        keyboardType: TextInputType.datetime,
                        readOnly: true,
                        onTap: () {
                          _selectDate(context);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your birthdate';
                              }
                              return null;
                              },
                              decoration: const InputDecoration(
                                prefixStyle: TextStyle(
                                  fontFamily: 'Gagalin',color: Colors.black,fontSize: 17,
                                  ),
                                  labelText: "Birthdate",
                                  labelStyle: TextStyle(
                                    fontFamily: 'Gagalin',
                                    color: Color.fromARGB(255, 6, 80, 7),
                                    fontSize: 30,
                                    ),
                                    prefixIcon: Icon(Icons.calendar_today),
                                    prefixIconColor: Color.fromARGB(255, 6, 80, 7),
                                    hintText: "Select your birthdate",
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      ),
                                      contentPadding: EdgeInsetsDirectional.only(top: 25, bottom: 10),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Color.fromARGB(255, 6, 80, 7)),
                                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Color.fromARGB(255, 6, 80, 7)),
                                          ),
                                          ),
                                          ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          Checkbox(
                            value: _isCheckBoxChecked,
                             onChanged: (value) {
                              setState(() {
                                _isCheckBoxChecked = value!;
                                });
                                },
                                ),
                          const Text('I agree to the terms and conditions'),
                          ],
                          ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                             style: raisedButtonStyle,
                             onPressed: () {
                                if (_formmkey.currentState!.validate() &&
                                     _isCheckBoxChecked) {
                                      Get.to(VerifyEmail());
                                    } else if (!_isCheckBoxChecked) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Please agree to the terms and conditions'),
                                          backgroundColor: Colors.red,
                                          ),
                                          );
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Please fill all fields'),
                                                backgroundColor: Colors.red,
                                                ),
                                                );
                                                }
                                                },
                            child: const Text('SIGN UP',
                            style: TextStyle(fontSize: 30.0,fontFamily: 'Gagalin',letterSpacing: 0.8),
                             ),
                        ),
              ],
            ),
          ))
      ),
    );
  }
}