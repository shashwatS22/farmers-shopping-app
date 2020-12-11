import 'package:flutter/material.dart';


class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn,this.isLoading);
  final bool isLoading;
  final void Function(
    String email,
    String username,
    
    String password,
    bool isLogin,
    BuildContext ctx) submitFn;  
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey=GlobalKey<FormState>();
  bool _isLogin=true;
  String _userEmail='';
  String _userName=''; 
  
  String _userPassword='';
  

  

  void _trySubmit(){

    final _isValid=_formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    
    if(_isValid){
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userName.trim(),
        
        _userPassword.trim(),
        _isLogin,context
        );

    }
      
  }


  @override
  Widget build(BuildContext context) {
    return Center(
          child: Card(
            margin: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child:Form(

                key: _formKey,
                
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 150,
                      height: 150,
                      child: Image.asset("lib/assets/logo.png"),
                      margin : EdgeInsets.all(10),
                    ),
                    SizedBox(height: 20,),
                    
                    
                    TextFormField(
                      key: ValueKey("email"),
                      validator: (value){
                        if(value.isEmpty || !value.contains('@')){
                          return "Enter valid email address";
                        }
                        return null;
                      } ,
                                             
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email Address",
                        focusColor: Theme.of(context).backgroundColor,
                        fillColor: Theme.of(context).backgroundColor,
                        hoverColor: Theme.of(context).backgroundColor,
                        
                      ),
                      onSaved: (value){
                        _userEmail=value;
                      },
                    ),
                    if(!_isLogin)
                    TextFormField(
                      key: ValueKey("username"),                      
                      validator: (value){
                      if(value.isEmpty|| value.length<4)  {
                        return "Username should be atleast 4 characters long.";
                      }
                      return null;
                      } ,
                                           
                      decoration: InputDecoration(
                        labelText: "Username",
                      ),
                      
                      onSaved: (value){
                        _userName=value;
                      },
                    ),
                    TextFormField(  
                      key: ValueKey("password"),                  
                      
                      validator: (value){
                        if(value.isEmpty|| value.length<7){
                          return "Password must be 7 characters long.";
                        }
                        return null;
                      },
                        obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        
                      ),
                      
                      onSaved: (value){
                        _userPassword=value;
                      },
                    ),
                      SizedBox(height: 12,),
                      if(widget.isLoading)CircularProgressIndicator(),
                      if(!widget.isLoading)
                      RaisedButton(
                          onPressed:_trySubmit ,
                         child: Text(_isLogin?"Login":"Signup"), 
                      ),
                      
                      if(!widget.isLoading)
                      FlatButton(
                          onPressed: (){
                            setState(() {
                              _isLogin=!_isLogin;
                            });
                          },
                          textColor: Theme.of(context).backgroundColor,
                         child: Text(_isLogin?"Create an account":"I already have an account"), 
                      ),
                    
                  ],
                ),),
              ),
            ),
          ),
        );
  }
}