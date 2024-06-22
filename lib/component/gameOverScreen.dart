import 'package:flutter/material.dart';
import 'package:blindtestlol_flutter_app/component/background_video.dart';
import 'package:blindtestlol_flutter_app/component/homePage.dart';
import 'package:blindtestlol_flutter_app/models/models.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';

class GameOverScreen extends StatelessWidget {
  final int score;
  final String mastery;
  final User user;

  const GameOverScreen({
    Key? key,
    required this.score,
    required this.mastery,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fin de la partie'),
        backgroundColor: AppColors.colorNoirHextech,
        automaticallyImplyLeading: false, // Removes the back button
      ),
      body: Stack(
        children: [
          Transform.translate(
            offset: Offset(10.0, 0.0),
            child: BackgroundVideo(
              videoPath: Mp4Assets.imageBackgroundGameOver,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
            child: Center(),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(
                        "assets/images/legendes/${user.avatarToken}.png",
                      ),
                      radius: 40.0,
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            shadows: [
                              Shadow(
                                blurRadius: 2.0,
                                color: Colors.black,
                                offset: Offset(1.0, 1.0),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'Points: ${user.totalScore}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                shadows: [
                                  Shadow(
                                    blurRadius: 2.0,
                                    color: Colors.black,
                                    offset: Offset(1.0, 1.0),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 4),
                            Image.asset(
                              ImageAssets.imageEssenceBleue,
                              width: 30,
                              height: 30,
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 70),
                if (mastery.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Maîtrise obtenue',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 2.0,
                                color: Colors.black,
                                offset: Offset(1.0, 1.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: Image.asset(
                            'assets/images/score/' + mastery + '.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                SizedBox(height: 10),
                if (score != null) // Check if score is not null
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Score de la partie: $score',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 2.0,
                                    color: Colors.black,
                                    offset: Offset(1.0, 1.0),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                                width: 8), // Espace entre le texte et l'image
                            Image.asset(
                              ImageAssets.imageEssenceBleue,
                              width: 30,
                              height: 30,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 120.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _navigateToHomePage(context);
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
                          vertical: 16.0,
                          horizontal: 32.0,
                        ),
                      ),
                      child: Text(
                        'Retour à l\'accueil', // Changed text to "Retour à l'accueil"
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'CustomFont2',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToHomePage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
          user: user,
          updateUser: (User) {},
        ),
      ),
    );
  }
}
