import 'package:flutter/material.dart';
import 'package:blindtestlol_flutter_app/component/SignalerProblemePage.dart';
import 'package:blindtestlol_flutter_app/component/boutiquePage.dart';
import 'package:blindtestlol_flutter_app/models/models.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';
import 'package:blindtestlol_flutter_app/component/loginPage.dart';

import 'aProposPage.dart';
import 'comptePage.dart'; // Import account page

class ProfilPage extends StatelessWidget {
  final User user;

  const ProfilPage(
      {Key? key,
      required this.user,
      required void Function(User newUser) updateUser})
      : super(key: key);

  void _deconnexion(BuildContext context) {
    // Implement logout logic here
    // For example, clear locally stored user data
    // Then navigate to login page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  // Button style similar to ComptePage save button
  static final ButtonStyle customButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor:
        AppColors.colorNoirHextech.withOpacity(0.9), // Opacity added
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0), // Rounded corners
      side: BorderSide(
        color: AppColors.colorTextTitle, // Border color
        width: 2.0, // Border width
      ),
    ),
    padding: EdgeInsets.symmetric(vertical: 15),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              ImageAssets.imageProfilPage, // Background image path
            ),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 20.0,
            left: 20.0,
            right: 20.0,
            bottom: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              _customButton(
                text: 'Compte',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ComptePage(
                        user: user,
                        updateUser: (User p1) {},
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16.0),
              Divider(),
              _customButton(
                text: 'Boutique',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BoutiquePage(
                              user: user,
                              updateUser: (User) {},
                            )),
                  );
                },
              ),
              SizedBox(height: 8.0),
              _customButton(
                text: 'À propos de nous',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AProposPage()),
                  );
                },
              ),
              SizedBox(height: 8.0),
              _customButton(
                text: 'Signaler un problème',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignalerProblemePage(),
                    ),
                  );
                },
              ),
              SizedBox(height: 8.0),
              _customButton(
                text: 'Déconnexion',
                onPressed: () {
                  _deconnexion(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: customButtonStyle, // Apply the custom button style
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
