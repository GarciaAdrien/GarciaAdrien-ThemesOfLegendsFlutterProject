import 'dart:async';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:blindtestlol_flutter_app/component/AnimatedCountDownCircle.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const Color colorBackground = Color.fromARGB(255, 0, 0, 0);
  static const Color colorText = Color(0xFFEAE4D8);
  static const Color colorTextTitle = Color(0xFFC8AA6E);
  static const Color colorTransparent = Colors.transparent;
  static const Color colorNoirHextech = Color(0xFF010A13);
}

class AppText {
  static const String title = 'THEME OF LEGENDS';
  static const String labelIdentifiant = 'IDENTIFIANT';
  static const String labelInscription = 'INSCRIPTION';
  static const String labelConnexion = 'CONNEXION';
  static const String labelPassword = 'MOT DE PASSE';
  static const String labelEmail = 'EMAIL';
  static const String labelLancer = 'LANCER';
  static const String labelMotDePasse = 'Mot de passe oublié';
}

class ImageAssets {
  static const String logo = 'assets/images/backgrounds/logo.png';
  static const String caitlynGif = 'assets/images/gif/caitlyn.gif';
  static const String esgiLogo = 'assets/images/esgi/esgi2.png';
  static const String soulignement =
      'assets/images/backgrounds/decorator-hr-lg.png';
  static const String title = 'assets/images/logo/title.png';
  static const String imageLegende1 = 'assets/images/legendes/globouille.png';
  static const String imageBackground =
      'assets/images/backgrounds/background.jpg';
  static const String imageBackgroundHeader =
      'assets/images/backgrounds/header.jpg';
  static const String imageButtonPlay =
      'assets/images/backgrounds/buttonplay.png';
  static const String imageAccueil = 'assets/images/backgrounds/accueil.png';
  static const String imageClassement =
      'assets/images/backgrounds/classement.png';
  static const String imageModesDejeu =
      'assets/images/backgrounds/modesdejeu.png';
  static const String jeu1 = 'assets/images/logo/jeu1.png';
  static const String jeu2 = 'assets/images/logo/jeu2.png';
  static const String jeu3 = 'assets/images/logo/jeu3.png';
  static const String jeu4 = 'assets/images/logo/jeu4.png';
  static const String imageEssenceBleue =
      'assets/images/backgrounds/essencebleu.png';
  static const String imageEssenceOrange =
      'assets/images/backgrounds/essenceOrange.png';
  static const String imageKda = 'assets/images/backgrounds/kda.png';
  static const String imageProfil = 'assets/images/backgrounds/profil.png';
  static const String imageCountdown =
      'assets/images/backgrounds/imageCountdown.png';
  static const String imageroundCircle = 'assets/images/logo/circle.gif';
  static const String Imageporogif = 'assets/images/logo/poro.gif';
  static const String abeilleMecontente =
      'assets/images/backgrounds/abeilleMecontente.png';
  static const String abeilleContente =
      'assets/images/backgrounds/abeilleContente.png';
  static const String imageCoinGif = 'assets/images/logo/coin.gif';
  static const String imageMasteryDefault = 'assets/images/logo/mastery.png';
  static const String imageBackground1 =
      'assets/images/backgrounds/seraphine.png';
  static const String imageBackground2 = 'assets/images/backgrounds/ekko.png';
  static const String imageBackground3 =
      'assets/images/backgrounds/morgana.jpg';
  static const String imageBackground4 = 'assets/images/backgrounds/kogmaw.jpg';
  static const String imageProfilPage =
      'assets/images/backgrounds/ProfilPage.png';
  static const String imageBackgroundSeraphine =
      'assets/images/logo/seraphine.png';
  static const String imageCurseur = 'assets/images/logo/curseur.png';
  static const String imageShop = 'assets/images/logo/shop.png';
  static const String imageBackgroundProfil =
      'assets/images/backgrounds/ProfilPage.png';
}

class Mp4Assets {
  static const videoPlayerController =
      'assets/musicBackground/Poro_base_AN_idle3.mp4';
  static const videoPlayerController2 = 'assets/musicBackground/heartsteel.mp4';
  static const String imageBackgroundProfil = 'assets/musicBackground/nunu.mp4';
  static const String imageBackgroundProfil2 =
      'assets/musicBackground/yuumi.mp4';
  static const String imageBackgroundProfil3 =
      'assets/musicBackground/season.mp4';
  static const String imageBackgroundParticle =
      'assets/images/logo/particle.mp4';
  static const String imageBackgroundGameOver =
      'assets/musicBackground/EndGame.mp4';
  static const String imageBackgroundClassement =
      'assets/musicBackground/sanctuaryBackground.mp4';
  static const String imageBackgroundClassement2 =
      'assets/musicBackground/arena2.mp4';
  static const String imageBackgroundClassement3 =
      'assets/musicBackground/arena3.mp4';
  static const String imageBackgroundProfilPage =
      'assets/musicBackground/profil.mp4';
}

class AproposAssets {
  static const apropos4 = 'assets/images/logo/arcane.gif';
  static const apropos2 = 'assets/images/logo/runeterra.png';
  static const apropos1 = 'assets/images/logo/lol.png';
  static const apropos3 = 'assets/images/logo/tft.png';
  static const apropos5 = 'assets/images/logo/team.gif';
}

class ProblemAssets {
  static const problem = 'assets/images/logo/problem.png';
}

class CountdownTimer extends StatefulWidget {
  final int duration;
  final VoidCallback onComplete;

  const CountdownTimer({
    Key? key,
    required this.duration,
    required this.onComplete,
  }) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late int remainingTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    remainingTime = widget.duration;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime == 0) {
        timer.cancel();
        widget.onComplete();
      } else {
        setState(() {
          remainingTime--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedCountdownCircle(
          totalSeconds: widget.duration,
          currentSecond: remainingTime,
        ),
        SizedBox(height: 10),
        Text(
          '$remainingTime',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: remainingTime <= 5
                ? Colors.red
                : (remainingTime <= 10 ? Colors.orange : AppColors.colorText),
          ),
        ),
      ],
    );
  }
}

class ScoreComboCountdownWidget extends StatefulWidget {
  final int seconds;
  final VoidCallback onComplete;

  const ScoreComboCountdownWidget({
    required this.seconds,
    required this.onComplete,
  });

  @override
  _ScoreComboCountdownWidgetState createState() =>
      _ScoreComboCountdownWidgetState();
}

class _ScoreComboCountdownWidgetState extends State<ScoreComboCountdownWidget> {
  late Timer _timer;
  late int currentSecond;

  @override
  void initState() {
    super.initState();
    currentSecond = widget.seconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (currentSecond == 0) {
        timer.cancel();
        widget.onComplete();
      } else {
        setState(() {
          currentSecond--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$currentSecond',
        style: const TextStyle(
          fontSize: 35, // Reduced font size
          fontWeight: FontWeight.bold,
          color: AppColors.colorText,
          shadows: [
            Shadow(
              blurRadius: 10.0,
              color: AppColors.colorNoirHextech,
              offset: Offset(5.0, 5.0),
            ),
          ],
        ),
      ),
    );
  }
}

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  AudioPlayer? _audioPlayer;

  AudioManager._internal();

  static AudioManager get instance => _instance;

  Future<void> playMusic(String musicId) async {
    // Always stop and dispose of the existing player before creating a new one
    if (_audioPlayer != null) {
      await _stopAndDisposeAudioPlayer();
    }
    _audioPlayer = AudioPlayer();
    final filePath = 'song/$musicId.mp3';
    await _audioPlayer!.play(AssetSource(filePath));
  }

  Future<void> stopMusic() async {
    if (_audioPlayer != null) {
      await _audioPlayer!.stop();
    }
  }

  Future<void> _stopAndDisposeAudioPlayer() async {
    if (_audioPlayer != null) {
      await _audioPlayer!.stop();
      await _audioPlayer!.dispose();
      _audioPlayer = null;
    }
  }
}

class RoundCountdownWidget extends StatelessWidget {
  final int duration;
  final VoidCallback onComplete;

  const RoundCountdownWidget({
    Key? key,
    required this.duration,
    required this.onComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CountdownTimer(
      duration: duration,
      onComplete: onComplete,
    );
  }
}
