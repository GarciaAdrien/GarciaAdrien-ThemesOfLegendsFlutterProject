import 'package:audioplayers/audioplayers.dart';
import 'package:blindtestlol_flutter_app/component/background_video.dart';
import 'package:flutter/material.dart';
import 'package:blindtestlol_flutter_app/component/SignalerProblemePage.dart';
import 'package:blindtestlol_flutter_app/component/boutiquePage.dart';
import 'package:blindtestlol_flutter_app/models/models.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';
import 'package:blindtestlol_flutter_app/component/loginPage.dart';
import 'package:video_player/video_player.dart';

import 'aProposPage.dart';
import 'comptePage.dart';

class ProfilPage extends StatefulWidget {
  final User user;

  const ProfilPage({
    Key? key,
    required this.user,
    required Function(User p1) updateUser,
  }) : super(key: key);

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    final AudioPlayer _audioPlayer = AudioPlayer();
    _audioPlayer.play(AssetSource('sounds/orianna.mp3'));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _deconnexion(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  static final ButtonStyle customButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: AppColors.colorNoirHextech.withOpacity(0.2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
      side: BorderSide(
        color: AppColors.colorTextTitle,
        width: 2.0,
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageAssets.imageBackgroundProfil),
                fit: BoxFit.fill,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox.shrink(),
                ), // Spacer to push buttons to the bottom
                _customButton(
                  text: 'Compte',
                  onPressed: () {
                    _audioPlayer.stop();
                    _audioPlayer.play(AssetSource('sounds/tft.mp3'));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ComptePage(
                          user: widget.user,
                          updateUser: (User p1) {},
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10.0),
                _customButton(
                  text: 'Boutique',
                  onPressed: () {
                    _audioPlayer.stop();
                    _audioPlayer.play(AssetSource('sounds/tft.mp3'));
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
                ),
                SizedBox(height: 10.0),
                _customButton(
                  text: 'À propos de nous',
                  onPressed: () {
                    _audioPlayer.stop();
                    _audioPlayer.play(AssetSource('sounds/tft.mp3'));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AProposPage(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10.0),
                _customButton(
                  text: 'Signaler un problème',
                  onPressed: () {
                    _audioPlayer.stop();
                    _audioPlayer.play(AssetSource('sounds/tft.mp3'));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignalerProblemePage(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10.0),
                _customButton(
                  text: 'Déconnexion',
                  onPressed: () {
                    _audioPlayer.stop();
                    _audioPlayer.play(AssetSource('sounds/tft.mp3'));
                    _deconnexion(context);
                  },
                ),
                SizedBox(height: 20.0), // Optional bottom padding
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _customButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: onPressed,
        style: customButtonStyle,
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
