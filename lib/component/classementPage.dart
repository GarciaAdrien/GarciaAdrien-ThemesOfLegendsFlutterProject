import 'package:flutter/material.dart';
import '../models/models.dart'; // Importez vos modèles
import 'package:blindtestlol_flutter_app/services/highScoreServices.dart';
import '../component/AnimatedPulse.dart';
import '../utils/utils.dart';
import '../component/background_video.dart'; // Importez le composant BackgroundVideo

class ClassementPage extends StatefulWidget {
  final User user;

  const ClassementPage({Key? key, required this.user}) : super(key: key);

  @override
  _ClassementPageState createState() => _ClassementPageState();
}

class _ClassementPageState extends State<ClassementPage> {
  late Future<List<UserHighScore>> futureHighScores;
  int selectedRound = 5; // Tour sélectionné par défaut
  double offsetX = 0.0; // Position horizontale du fond d'écran
  double maxOffsetX = 0.0; // Limite maximale de défilement

  @override
  void initState() {
    super.initState();
    futureHighScores = fetchHighScores(selectedRound);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Calculer maxOffsetX une fois que le contexte est disponible
    maxOffsetX = MediaQuery.of(context).size.width *
        0.9; // 25% plus large que la largeur de l'écran
    offsetX = maxOffsetX; // Commencer tout à droite du fond d'écran
  }

  Future<List<UserHighScore>> fetchHighScores(int round) async {
    try {
      final highScores = await HighScoreService().getHighScores(round);
      return highScores;
    } catch (e) {
      print('Échec du chargement des meilleurs scores: $e');
      throw Exception('Échec du chargement des meilleurs scores: $e');
    }
  }

  void updateRound(int round) {
    setState(() {
      selectedRound = round;
      print(round);
      futureHighScores = fetchHighScores(selectedRound);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          setState(() {
            offsetX += details.primaryDelta!;
            // Limiter offsetX pour éviter l'espace noir
            if (offsetX > maxOffsetX) {
              offsetX = maxOffsetX;
            } else if (offsetX < -maxOffsetX) {
              offsetX = -maxOffsetX;
            }
          });
        },
        child: Stack(
          children: [
            // Widget de vidéo de fond avec transform pour l'effet de défilement
            BackgroundVideoWidget(
              key: ValueKey(selectedRound),
              selectedRound: selectedRound,
              offsetX: offsetX,
              maxOffsetX: maxOffsetX,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Expanded(
                  child: buildHighScoreList(),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: buildRoundButtons(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRoundButtons() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildRoundButton('Manche 5', 5),
          _buildRoundButton('Manche 10', 10),
          _buildRoundButton('Manche 15', 15),
        ],
      ),
    );
  }

  Widget _buildRoundButton(String label, int round) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.colorTextTitle, width: 2),
      ),
      child: ElevatedButton(
        onPressed: () => updateRound(round),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.colorNoirHextech,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 16, color: AppColors.colorTextTitle),
        ),
      ),
    );
  }

  // Inside the buildHighScoreList method
  Widget buildHighScoreList() {
    return FutureBuilder<List<UserHighScore>>(
      future: futureHighScores,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Aucun classement trouvé'));
        } else {
          List<UserHighScore> highScores = snapshot.data!;
          return ListView.builder(
            itemCount: highScores.length,
            itemBuilder: (context, index) {
              UserHighScore userHighScore = highScores[index];
              return Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.2), // Noir avec opacité
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                padding: EdgeInsets.all(12),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: SizedBox(
                    width: 100,
                    height: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: AnimatedPulse(
                        child: Image.asset(
                          "assets/images/legendes/${userHighScore.userAvatarToken}.png",
                          fit: BoxFit.cover,
                        ),
                        duration: Duration(milliseconds: 2500),
                      ),
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userHighScore.userName,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8), // Adjust spacing if needed
                      Row(
                        children: [
                          Text('Score: '),
                          Text(
                            '${userHighScore.highScore.highScoreValue}',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      SizedBox(height: 8), // Adjust spacing if needed
                      Row(
                        children: [
                          Text('Maîtrise: '),
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.asset(
                              'assets/images/score/${userHighScore.highScore.mastery}.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Image.asset(
                    'assets/images/maitriseClassement/${index + 1}.png',
                    width: 100,
                    height: 100,
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

class BackgroundVideoWidget extends StatelessWidget {
  final int selectedRound;
  final double offsetX;
  final double maxOffsetX;

  const BackgroundVideoWidget({
    Key? key,
    required this.selectedRound,
    required this.offsetX,
    required this.maxOffsetX,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(offsetX, 0),
      child: Container(
        width: MediaQuery.of(context).size.width * 1.25,
        height: MediaQuery.of(context)
            .size
            .height, // Utilisation de la hauteur maximale de la page
        child: getBackgroundVideo(selectedRound),
      ),
    );
  }

  Widget getBackgroundVideo(int round) {
    print("Updating background for round: $round");
    switch (round) {
      case 5:
        return BackgroundVideo(
          videoPath: Mp4Assets.imageBackgroundClassement,
          fit: BoxFit.cover, // Remplit la hauteur maximale sans déformation
        );
      case 10:
        return BackgroundVideo(
          videoPath: Mp4Assets.imageBackgroundClassement2,
          fit: BoxFit.cover, // Remplit la hauteur maximale sans déformation
        );
      case 15:
        return BackgroundVideo(
          videoPath: Mp4Assets.imageBackgroundClassement3,
          fit: BoxFit.cover, // Remplit la hauteur maximale sans déformation
        );
      default:
        return BackgroundVideo(
          videoPath: Mp4Assets.imageBackgroundClassement,
          fit: BoxFit.cover, // Remplit la hauteur maximale sans déformation
        );
    }
  }
}
