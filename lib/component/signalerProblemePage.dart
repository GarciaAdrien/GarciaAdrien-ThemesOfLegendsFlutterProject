import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';

import 'background_video.dart'; // Importez votre widget BackgroundVideo ici

class SignalerProblemePage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signaler un problème'),
        backgroundColor: AppColors.colorNoirHextech,
        foregroundColor: AppColors.colorTextTitle,
      ),
      body: Stack(
        children: [
          // Background video widget with translation
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(100.0, 0.0), // Translate 100 pixels to the right
              child:
                  BackgroundVideo(videoPath: Mp4Assets.imageBackgroundProfil2),
            ),
          ),
          // Content overlay
          Positioned.fill(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.colorNoirHextech,
                            width: 2.0,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          'Un Bug ? Un Problème, c\'est par ici que ça se passe...',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Nom
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.colorNoirHextech.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: AppColors.colorTextTitle,
                          width: 2.0,
                        ),
                      ),
                      child: TextFormField(
                        controller: nameController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Votre nom',
                          labelStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Sujet du problème
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.colorNoirHextech.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: AppColors.colorTextTitle,
                          width: 2.0,
                        ),
                      ),
                      child: TextFormField(
                        controller: subjectController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Sujet du problème',
                          labelStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Description détaillée du problème
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.colorNoirHextech.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: AppColors.colorTextTitle,
                          width: 2.0,
                        ),
                      ),
                      child: TextFormField(
                        controller: messageController,
                        style: TextStyle(color: Colors.white),
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          labelText: 'Description détaillée du problème',
                          labelStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 16.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Bouton Envoyer
                    Center(
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                          color: AppColors.colorNoirHextech.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: AppColors.colorTextTitle,
                            width: 2.0,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () => _confirmAndSendEmail(context),
                          child: Text(
                            'Envoyer',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmAndSendEmail(BuildContext context) async {
    final String email = 'adriengarciaperso@gmail.com';
    final String subject = Uri.encodeComponent(subjectController.text);
    final String body = Uri.encodeComponent(
      '${nameController.text} vous signale un problème :\n\n${messageController.text}',
    );

    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=$subject&body=$body',
    );

    bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ouvrir l\'application Gmail'),
          content: Text('Voulez-vous ouvrir Gmail pour envoyer l\'e-mail ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Non'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Oui'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      try {
        _sendMail() async {
          // Android and iOS
          const uri = 'mailto:adriengarciaperso@gmail.com';
          if (await canLaunch(uri)) {
            await launch(uri);
          } else {
            throw 'Could not launch $uri';
          }
        }
      } catch (e) {
        print('Erreur lors de l\'envoi de l\'e-mail: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erreur lors de l\'envoi de l\'e-mail. Veuillez réessayer plus tard.',
            ),
          ),
        );
      }
    }
  }
}
