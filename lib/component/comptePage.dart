import 'package:blindtestlol_flutter_app/component/boutiquePage.dart';
import 'package:blindtestlol_flutter_app/component/homePage.dart';
import 'package:flutter/material.dart';
import 'package:blindtestlol_flutter_app/services/userServices.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';
import 'package:blindtestlol_flutter_app/models/models.dart';
import 'package:blindtestlol_flutter_app/component/background_video.dart';

import 'AnimatedPulse.dart'; // Assurez-vous de remplacer le chemin par celui de votre fichier

class ComptePage extends StatefulWidget {
  User user;
  final Function(User) updateUser;

  ComptePage({Key? key, required this.user, required this.updateUser})
      : super(key: key);

  @override
  _ComptePageState createState() => _ComptePageState();
}

class _ComptePageState extends State<ComptePage>
    with SingleTickerProviderStateMixin {
  late TextEditingController nameController;
  late TextEditingController emailController;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late List<Avatar> avatars = [];

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    emailController = TextEditingController(text: widget.user.email);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _loadAvatars();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadAvatars() async {
    try {
      List<Avatar> fetchedAvatars =
          await UserService().getAllAvatars(widget.user.uid, true);

      setState(() {
        avatars = fetchedAvatars;
      });
    } catch (e) {
      print('Failed to load avatars: $e');
    }
  }

  void _showAvatarGrid() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.colorNoirHextech,
          insetPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.colorTextTitle, width: 2.0),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    children: [
                      Positioned(
                        top: 5.0,
                        right: 5.0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.close),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Choisissez votre avatar',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
                        padding: EdgeInsets.only(bottom: 10.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: avatars.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              try {
                                await UserService().changeAvatar(
                                  widget.user.uid,
                                  avatars[index].id,
                                );
                                User updatedUser = await UserService()
                                    .getUser(widget.user.uid);
                                setState(() {
                                  widget.user = updatedUser;
                                });
                                Navigator.pop(context);
                              } catch (e) {
                                print('Failed to change avatar: $e');
                              }
                            },
                            child: _buildGridItem(avatars[index]),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                      height:
                          16.0), // Espace entre la grille et le bouton Boutique
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BoutiquePage(
                              user: widget.user,
                              updateUser: (User p1) {},
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppColors.colorTextTitle,
                        backgroundColor: AppColors.colorNoirHextech,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                            color: AppColors.colorTextTitle,
                            width: 2.0,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal:
                                12.0), // Ajuster le padding horizontal ici
                        minimumSize: Size(0,
                            0), // Définir la taille minimale à zéro pour s'adapter au contenu
                      ),
                      child: Text(
                        'Boutique',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'CustomFont2',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridItem(Avatar avatar) {
    String imagePath = 'assets/images/legendes/${avatar.token}.png';
    return Container(
      decoration: BoxDecoration(
        color: AppColors.colorNoirHextech,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8.0,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppColors.colorNoirHextech,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: AppColors.colorNoirHextech,
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(20.0)),
            ),
            child: Text(
              avatar.token,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'CustomFont2',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      appBar: AppBar(
        title: Text('Mon Compte'),
        backgroundColor: AppColors.colorNoirHextech,
        foregroundColor: AppColors.colorTextTitle,
      ),
      body: Stack(
        children: [
          Transform.translate(
            offset: Offset(-150, 0),
            child: const BackgroundVideo(
              videoPath: Mp4Assets.imageBackgroundProfil,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      GestureDetector(
                        onTap: _showAvatarGrid,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(
                              "assets/images/legendes/" +
                                  widget.user.avatarToken +
                                  ".png"),
                        ),
                      ),
                      Positioned(
                        right: -30,
                        bottom: -20,
                        child: AnimatedPulse(
                          child: GestureDetector(
                            onTap: _showAvatarGrid,
                            child: Image.asset(
                              ImageAssets.imageCurseur,
                              width: 80,
                              height: 80,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildEditableField('Nom d\'utilisateur', nameController,
                      isEditable: false),
                  SizedBox(height: 16),
                  _buildEditableField('Adresse e-mail', emailController,
                      isEditable: false),
                  SizedBox(height: 16),
                  _buildEditableField(
                      'Nouveau mot de passe', passwordController,
                      isPassword: true),
                  SizedBox(height: 16),
                  _buildEditableField(
                      'Confirmer le mot de passe', confirmPasswordController,
                      isPassword: true),
                  SizedBox(height: 24),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: _buildSaveButton(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.colorNoirHextech,
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () async {
        String newPassword = passwordController.text;
        String confirmPassword = confirmPasswordController.text;

        if (newPassword.isNotEmpty && newPassword == confirmPassword) {
          try {
            UserService userService = UserService();
            User updatedUser =
                await userService.updatePassword(widget.user.uid, newPassword);

            setState(() {
              widget.user = updatedUser;
            });

            _scaffoldMessengerKey.currentState?.showSnackBar(
              SnackBar(
                content: Text('Mot de passe mis à jour avec succès.'),
              ),
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  user: updatedUser,
                  updateUser: widget.updateUser,
                ),
              ),
            );
          } catch (e) {
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SnackBar(
                content:
                    Text('Erreur lors de la mise à jour du mot de passe: $e'),
              ),
            );
          }
        } else if (newPassword.isNotEmpty && newPassword != confirmPassword) {
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text('Les mots de passe ne correspondent pas.'),
            ),
          );
        } else {
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text('Modifications sauvegardées avec succès.'),
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                user: widget.user,
                updateUser: widget.updateUser,
              ),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.colorTextTitle,
        backgroundColor: AppColors.colorNoirHextech,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: AppColors.colorTextTitle,
            width: 2.0,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
      ),
      child: Text(
        'Sauvegarder les modifications',
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'CustomFont2',
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller,
      {bool isPassword = false, bool isEditable = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'CustomFont2',
            color: AppColors.colorTextTitle,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          style: TextStyle(
            color: AppColors.colorTextTitle,
          ),
          enabled: isEditable,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.colorNoirHextech,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: AppColors.colorTextTitle,
                width: 2.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
