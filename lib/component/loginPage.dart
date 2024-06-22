import 'package:flutter/material.dart';
import 'package:blindtestlol_flutter_app/component/background_video.dart';
import 'package:blindtestlol_flutter_app/component/forgotPasswordPage.dart';
import 'package:blindtestlol_flutter_app/component/homePage.dart';
import 'package:blindtestlol_flutter_app/component/registerPage.dart';
import 'package:blindtestlol_flutter_app/services/userServices.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const BackgroundVideo(
            videoPath: Mp4Assets.videoPlayerController2,
            fit: BoxFit.cover,
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    ImageAssets.logo,
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    ImageAssets.title,
                    width: 300,
                    height: 75,
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    color: AppColors.colorTextTitle,
                    thickness: 1,
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _nameController,
                          labelText: AppText.labelIdentifiant,
                          obscureText: false,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _passwordController,
                          labelText: AppText.labelPassword,
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.colorNoirHextech,
                            side: BorderSide(color: AppColors.colorTextTitle),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      ImageAssets.logo,
                                      height: 50,
                                    ),
                                    const SizedBox(width: 3),
                                    const Text(
                                      AppText.labelConnexion,
                                      style: TextStyle(
                                        color: AppColors.colorTextTitle,
                                        fontFamily: 'CustomFont2',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ForgotPasswordPage()),
                            );
                          },
                          child: const Text(
                            AppText.labelMotDePasse,
                            style: TextStyle(
                              color: AppColors.colorText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Image.asset(
                          ImageAssets.soulignement,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()),
                          );
                        },
                        child: const Text(
                          AppText.labelInscription,
                          style: TextStyle(
                            color: AppColors.colorText,
                            fontFamily: 'CustomFont1',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required bool obscureText,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(
        color: AppColors.colorText,
        fontFamily: 'CustomFont1',
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: AppColors.colorTextTitle,
          fontFamily: 'CustomFont1',
        ),
        filled: true,
        fillColor: AppColors.colorNoirHextech,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.colorTextTitle),
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.colorTextTitle),
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
      ),
      validator: (value) =>
          value!.isEmpty ? 'Veuillez entrer votre $labelText' : null,
    );
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    if (!_formKey.currentState!.validate()) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final user = await UserService().connectUser(
        _nameController.text,
        _passwordController.text,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomePage(
            user: user,
            updateUser: (User) {},
          ),
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      // Afficher un SnackBar avec le message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Identifiant ou mot de passe incorrect',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
