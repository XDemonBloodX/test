import 'package:flutter/material.dart';
import 'package:epicture/views/HomeView.dart';
import 'package:epicture/views/SearchView.dart';
import 'package:epicture/views/ProfileView.dart';
import '../views/NewView.dart';
import 'package:image_picker/image_picker.dart';
import 'package:epicture/views/LoginView.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class NavigationBarWidget extends StatefulWidget {
    bool byPassLogin = false;

    NavigationBarWidget({Key key, this.byPassLogin}) : super(key: key);

    @override
    _NavigationBarWidgetState createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
    int selectedIndex = 0;
    List<String> pageNames = ["Imgur", "Rechercher une image", "Mon profile"];
    List<Widget> widgetOptions = <Widget>[
        HomeView(),
        SearchView(),
        ProfileView()
    ];
    bool loggedOut = false;

    void _onItemTapped(int index) {
        setState(() {
            selectedIndex = index;
        });
    }

    Widget defaultAppBar(BuildContext context) {
        return PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: AppBar(
                backgroundColor: Colors.indigo,
                title: Text(pageNames[selectedIndex]),
            ),
        );
    }

    Widget profileAppBar(BuildContext context) {
        return PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: AppBar(
                backgroundColor: Colors.indigo,
                title: Text(pageNames[selectedIndex]),
                actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.forward, color: Colors.black54),
                        onPressed: () {
                            setState(() {
                              this.loggedOut = true;
                            });
                        }
                    )
                ],
            ),
        );
    }

    @override
    Widget build(BuildContext context) {
        if (this.loggedOut == true && this.widget.byPassLogin == false) {
            return LoginView();
        }
        return Scaffold(
            backgroundColor: Colors.indigoAccent,
            resizeToAvoidBottomInset: false,
            appBar: (selectedIndex == 2) ? profileAppBar(context) : defaultAppBar(context),
            body: Center(
                child: widgetOptions.elementAt(selectedIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Icon(Icons.image),
                        title: Text('Image'),
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.search_rounded),
                        title: Text('Rechercher'),
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        title: Text('Moi'),
                    )
                ],
                currentIndex: selectedIndex,
                selectedItemColor: Colors.indigo,
                unselectedItemColor: Colors.grey.shade700,
               onTap: _onItemTapped,
            ),
            floatingActionButton: SpeedDial(
                marginRight: 18,
                marginBottom: 20,
                animatedIcon: AnimatedIcons.menu_arrow,
                animatedIconTheme: IconThemeData(size: 28.0),
                closeManually: false,
                curve: Curves.ease,
                overlayColor: Colors.black,
                overlayOpacity: 0.5,
                backgroundColor: Colors.indigoAccent,
                foregroundColor: Colors.black54,
                elevation: 8.0,
                shape: CircleBorder(),
                children: [
                    SpeedDialChild(
                        child: Icon(Icons.camera),
                        backgroundColor: Colors.indigo,
                        onTap: () async {
                            var image = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);

                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => NewView(imageData: image)
                            ));
                        }
                    ),
                    SpeedDialChild(
                        child: Icon(Icons.image),
                        backgroundColor: Colors.indigo,
                        onTap: () async {
                            var image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);

                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => NewView(imageData: image)
                            ));
                        }
                    )
                ],
            ),
        );
    }
}
