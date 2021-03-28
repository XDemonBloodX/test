import 'package:flutter/material.dart';
import 'package:epicture/models/AccountBase.dart';
import 'package:epicture/managers/imgur/Account.dart';
import 'package:epicture/models/GalleryList.dart';
import 'package:epicture/models/GalleryImage.dart';
import 'package:epicture/components/ImageViewer.dart';

class ProfileView extends StatefulWidget {
    ProfileView({Key key}) : super(key: key);

    @override
    _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with SingleTickerProviderStateMixin {
  AccountBase accountBase;
  GalleryList accountImages;
  GalleryList accountFavoritesImages;
  int pubCount;
  TabController tabController;

  _ProfileViewState() {
    Account().getAccountImages().then((GalleryList g) =>
    (setState(() => this.accountImages = g)));
    Account().getAccountBase().then((AccountBase a) =>
    (setState(() => this.accountBase = a)));
    Account().getAccountPublicationsCount().then((int c) =>
    (setState(() => this.pubCount = c)));
    Account().getGalleryFavorites().then((GalleryList g) =>
    (setState(() => this.accountFavoritesImages = g)));
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    if (this.accountBase == null || this.accountImages == null
        || this.pubCount == null || this.accountFavoritesImages == null) {
      return CircularProgressIndicator();
    } else {
      return Container(

        child: Column(
          children: <Widget>[
            createProfileHeader(context),
            createTabBar(context),
            createProfileAlbum(context)
          ],
        ),
      );
    }
  }

  Widget createTabBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: TabBar(
        controller: this.tabController,
        tabs: <Widget>[
          Tab(
            icon: Icon(
              Icons.camera,
              color: Colors.indigo,
            ),
          ),
          Tab(
              icon: Icon(
                  Icons.favorite,
                  color: Colors.redAccent
              )
          )
        ],
      ),
    );
  }

  Widget createResultCard(BuildContext context, GalleryImage image) {
    return Container(
      child: Card(
          semanticContainer: true,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>
                      ImageViewer(
                          image: image,
                          isFromUser: true,
                          canPopContext: true)
                  )
              );
            },
            child: GridTile(
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          "https://i.imgur.com/" + image.id + "." +
                              ((image.imagesInfo == null) ? "jpg" : image
                                  .imagesInfo[0].type.split('/')[1]),
                        )
                    )
                ),
              ),
            ),
          )
      ),
    );
  }

  Widget createProfileAlbum(BuildContext context) {
    return Expanded(
      child: TabBarView(
        controller: this.tabController,
        children: <Widget>[
          Container(
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: this.accountImages.gallery.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return createResultCard(
                      context, this.accountImages.gallery[index]);
                }
            ),
          ),
          Container(
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: this.accountFavoritesImages.gallery.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return createResultCard(
                      context, this.accountFavoritesImages.gallery[index]);
                }
            ),
          )
        ],
      ),
    );
  }

  Widget createProfileHeader(BuildContext context) {
    return Container(
        child: Card(
            child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        child: Row(
                          children: <Widget>[
                            createProfilePicture(context),
                          ],
                        )
                    ),

                  ],
                )
            )
        )
    );
  }

  Widget createProfilePicture(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Container(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            "https://imgur.com/user/" + this.accountBase.name +
                                "/avatar")
                    )
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: 5),
            child: Text(
              this.accountBase.name,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15)
            ),
          )
        ],
      ),
    );
  }
}
