import 'package:blindtestlol_flutter_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:blindtestlol_flutter_app/component/profilPage.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';
import 'package:blindtestlol_flutter_app/component/accueilPage.dart';
import 'package:blindtestlol_flutter_app/component/classementPage.dart';
import 'package:blindtestlol_flutter_app/component/comptePage.dart'; // Import the ComptePage
import 'package:blindtestlol_flutter_app/services/userServices.dart';
import 'background_video.dart';

class HomePage extends StatefulWidget {
  final User user;
  final Function(User) updateUser;

  HomePage({Key? key, required this.user, required this.updateUser})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;
  final UserService _userService = UserService();
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _widgetOptions = <Widget>[
      AccueilPage(
        user: _user,
        updateUser: (User) {},
      ),
      ProfilPage(
          user: _user,
          updateUser:
              widget.updateUser), // Utilisation de updateUser depuis widget
      ClassementPage(user: _user),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchUserScore();
  }

  Future<void> _fetchUserScore() async {
    try {
      User updatedUser = await _userService.getUser(widget.user.uid);
      setState(() {
        _user = updatedUser;
        _widgetOptions = <Widget>[
          AccueilPage(
            user: _user,
            updateUser: (User p1) {},
          ),
          ProfilPage(
              user: _user,
              updateUser:
                  widget.updateUser), // Utilisation de updateUser depuis widget
          ClassementPage(user: _user),
        ];
      });
    } catch (e) {
      // Handle error
      print('Failed to fetch user score: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _goToProfile() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ProfilPage(
          user: _user,
          updateUser:
              widget.updateUser, // Utilisation de updateUser depuis widget
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  void _goToCompte() async {
    final updatedUser = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComptePage(
          user: _user,
          updateUser: widget.updateUser,
        ),
      ),
    );

    // Check if updatedUser is not null (handling if the user presses back without saving)
    if (updatedUser != null) {
      setState(() {
        _user = updatedUser;
        _widgetOptions[1] = ProfilPage(
          user: _user,
          updateUser: widget.updateUser,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background video
          Positioned.fill(
            child: Transform.translate(
              offset: const Offset(0, -300),
              child: BackgroundVideo(
                videoPath: Mp4Assets.imageBackgroundParticle,
                fit: BoxFit.cover,
                playbackSpeed: 2.5, // Adjust playback speed if supported
              ),
            ),
          ),
          // Contenu principal
          Column(
            children: [
              // Header avec logo et image de profil
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: AppColors.colorNoirHextech.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Section gauche avec le nom d'utilisateur, l'icône de maîtrise et les points
                    Expanded(
                      child: Row(
                        children: [
                          // Icône de maîtrise à gauche
                          Image.asset(
                            ImageAssets.imageMasteryDefault,
                            width: 100,
                            height: 100,
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nom d'utilisateur
                              Text(
                                _user.name,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'CustomFont1',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              // Points
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Points: ${_user.totalScore.toString()}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'CustomFont2',
                                      color: Colors.white,
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
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Icône à droite (Profil)
                    GestureDetector(
                      onTap: _goToCompte, // Navigate to ComptePage when tapped
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFCDFAFA),
                              blurRadius: 5,
                              spreadRadius: 5,
                            ),
                          ],
                          border: Border.all(
                            color: AppColors.colorTextTitle,
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            "assets/images/legendes/" +
                                _user.avatarToken +
                                ".png",
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Contenu principal de la page
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: _widgetOptions.elementAt(_selectedIndex),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.colorTextTitle, width: 2),
          ),
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage(ImageAssets.imageAccueil), size: 30),
              label: 'ACCUEIL',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                ImageAssets.Imageporogif,
                width: 70,
                height: 70,
              ),
              label: 'PROFIL',
            ),
            BottomNavigationBarItem(
              icon:
                  ImageIcon(AssetImage(ImageAssets.imageClassement), size: 30),
              label: 'CLASSEMENT',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.colorTextTitle,
          onTap: _onItemTapped,
          selectedLabelStyle:
              const TextStyle(fontFamily: 'CustomFont1', fontSize: 14),
          unselectedLabelStyle:
              const TextStyle(fontFamily: 'CustomFont1', fontSize: 14),
          backgroundColor: AppColors.colorNoirHextech.withOpacity(0.2),
          selectedIconTheme: const IconThemeData(size: 40),
          unselectedIconTheme: const IconThemeData(size: 30),
        ),
      ),
    );
  }
}
