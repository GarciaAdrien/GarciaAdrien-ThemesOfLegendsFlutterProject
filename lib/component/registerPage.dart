import 'package:flutter/material.dart';
import 'package:blindtestlol_flutter_app/component/background_video.dart'; // Importez le widget BackgroundVideo
import 'package:blindtestlol_flutter_app/utils/utils.dart'; // Importez vos ressources d'images depuis le fichier utils.dart
import 'package:blindtestlol_flutter_app/component/homePage.dart';
import 'package:blindtestlol_flutter_app/component/loginPage.dart';
import 'package:blindtestlol_flutter_app/services/userServices.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              ImageAssets
                  .imageBackgroundSeraphine, // Chemin de votre image de fond
              fit: BoxFit.cover, // Ajustement pour couvrir toute la surface
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    ImageAssets.logo, // Assurez-vous que ce chemin est correct
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    ImageAssets.title, // Chemin de ton image unique
                    width: 300, // Ajuste la largeur selon tes besoins
                    height: 75, // Ajuste la hauteur selon tes besoins
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
                          controller: _emailController,
                          labelText: AppText.labelEmail,
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
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.colorNoirHextech,
                            side: const BorderSide(
                                color: AppColors.colorTextTitle),
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
                                      AppText.labelInscription,
                                      style: TextStyle(
                                          color: AppColors.colorTextTitle,
                                          fontFamily: 'CustomFont1',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
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
                                builder: (context) => LoginPage()),
                          );
                        },
                        child: const Text(
                          AppText.labelConnexion,
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
    Color? color,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(
        color: color ?? AppColors.colorTextTitle,
        fontFamily: 'CustomFont1',
      ), // Utilisation de la couleur
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: color ?? AppColors.colorTextTitle,
          fontFamily: 'CustomFont1',
        ), // Utilisation de la couleur
        filled:
            true, // Ajout de cette ligne pour activer le remplissage du champ
        fillColor: AppColors
            .colorNoirHextech, // Couleur de fond pour le champ d'entrée
        border: const OutlineInputBorder(),
      ),
    );
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final user = await UserService().createUser(_nameController.text,
          _emailController.text, _passwordController.text);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (_) => HomePage(
                  user: user,
                  updateUser: (User) {},
                )),
      );
    } catch (e) {
      // Handle errors, possibly show an alert dialog
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
