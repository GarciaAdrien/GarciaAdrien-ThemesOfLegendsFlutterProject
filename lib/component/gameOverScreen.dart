import 'package:blindtestlol_flutter_app/component/homePage.dart';
import 'package:blindtestlol_flutter_app/services/gameServices.dart';
import 'package:flutter/material.dart';
import 'package:blindtestlol_flutter_app/models/models.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';
import 'package:blindtestlol_flutter_app/component/modesDeJeuPage.dart';

class GameOverScreen extends StatelessWidget {
  final int score;
  final int combo;
  final String mastery;
  final User user;

  const GameOverScreen({
    Key? key,
    required this.score,
    required this.combo,
    required this.mastery,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fin de la partie'),
        backgroundColor: AppColors.colorNoirHextech,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/your_background_image.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.black.withOpacity(0.5),
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Fin de la partie',
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    CircleAvatar(
                      //backgroundImage: NetworkImage(user.),
                      radius: 40.0,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    _buildScoreInfo(context, 'Score', '$score'),
                    _buildScoreInfo(context, 'Combo', '$combo'),
                    SizedBox(height: 20.0),
                    Text(
                      'Maîtrise obtenue',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Image.asset(
                      'assets/images/mastery_image.png',
                      width: 100.0,
                      height: 100.0,
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
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
                        'Rejouer',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'CustomFont2',
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

  Widget _buildScoreInfo(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
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
