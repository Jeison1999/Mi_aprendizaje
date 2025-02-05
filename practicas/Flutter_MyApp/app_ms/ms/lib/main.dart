import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLogoVisible = false;
  bool _isCardVisible = false;

  @override
  void initState() {
    super.initState();
    _animateElements();
  }

  void _animateElements() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _isLogoVisible = true;
    });

    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _isLogoVisible = false;
      _isCardVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3F2FD),
      body: Center(
        child: Stack(
          children: [
            // Ball animation
            AnimatedPositioned(
              duration: Duration(seconds: 2),
              top: _isLogoVisible ? 150 : -100,
              left: 50,
              child: AnimatedOpacity(
                opacity: _isLogoVisible ? 1 : 0,
                duration: Duration(seconds: 1),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue,
                ),
              ),
            ),
            
            // Logo animation
            AnimatedOpacity(
              opacity: _isLogoVisible ? 1 : 0,
              duration: Duration(seconds: 1),
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset('assets/logo.png', width: 120, height: 120),
              ),
            ),

            // Card (login form)
            AnimatedPositioned(
              duration: Duration(seconds: 1),
              top: _isCardVisible ? MediaQuery.of(context).size.height * 0.35 : MediaQuery.of(context).size.height,
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
              child: AnimatedOpacity(
                opacity: _isCardVisible ? 1 : 0,
                duration: Duration(seconds: 1),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1089D3),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'E-mail',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(fontSize: 12, color: Color(0xFF0099FF)),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF1089D3), Color(0xFF12B1D1)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Sign In',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Text(
                          'Or Sign in with',
                          style: TextStyle(fontSize: 10, color: Color(0xFFAAAAAA)),
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SocialButton(icon: Icons.login),
                            SocialButton(icon: Icons.apple),
                            SocialButton(icon: Icons.facebook),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Learn user licence agreement',
                          style: TextStyle(fontSize: 9),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final IconData icon;

  SocialButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Color(0xFF727272),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
