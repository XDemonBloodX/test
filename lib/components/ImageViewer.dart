import 'package:flutter/material.dart';
import 'package:epicture/managers/imgur/Gallery.dart';
import 'package:epicture/models/GalleryImage.dart';
import 'package:epicture/managers/imgur/Image.dart' as ImgurImage;

class ImageViewer extends StatefulWidget {
  final GalleryImage image;
  final bool canPopContext;
  final bool isFromUser;

  ImageViewer({
      Key key,
      @required this.image,
      @required this.canPopContext,
      @required this.isFromUser
  }) : super(key: key);

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {

  @override
  Widget build(BuildContext context) {
      if (this.widget.canPopContext == true) {
          return Scaffold(
	      appBar: PreferredSize(
		  preferredSize: Size.fromHeight(40),

		  child: AppBar(
		      backgroundColor: Colors.indigo,
		      title: Text(this.widget.image.username),
		  ),
	      ),

	      body: createBody(context),
	  );
      }
      return createBody(context);
  }

  Widget createBody(BuildContext context) {
      if (this.widget.canPopContext == true) {
          return SingleChildScrollView(
	      child: Container(
		  child: Column(
		      children: <Widget>[
			  Container(
			      padding: EdgeInsets.all(5),
			      child: createPostHeader(context, this.widget.image)
			  ),
			  createPostImage(context, this.widget.image),
			  createPostActions(context, this.widget.image),
		      ],
		  ),
	      ),
	  );
      }
      return Card(
	  semanticContainer: true,
	  clipBehavior: Clip.antiAliasWithSaveLayer,
	  child: Container(
	      child: Column(
		  children: <Widget>[
		      Container(
			  padding: EdgeInsets.all(5),

			  child: createPostHeader(context, this.widget.image)),
		      createPostImage(context, this.widget.image),
		      createPostActions(context, this.widget.image),
		  ],
	      ),
	  ),
	  shape: RoundedRectangleBorder(
	      borderRadius: BorderRadius.circular(20.0),
	  ),
	  elevation: 7,
	  margin: EdgeInsets.all(10),
      );
  }

  Widget createPostHeader(BuildContext context, GalleryImage image) {
      if (this.widget.isFromUser == false) {
	  return Container(
	      child: Row(
		  mainAxisAlignment: MainAxisAlignment.start,
		  children: <Widget>[
		      Container(
			  padding: EdgeInsets.all(5),
			  child: Align(
			      alignment: Alignment.centerLeft,
			      child: Container(
				  width: 30.0,
				  height: 30.0,
				  decoration: BoxDecoration(
				      shape: BoxShape.circle,
				      image: DecorationImage(
					  fit: BoxFit.cover,
					  image: NetworkImage(
					      "https://imgur.com/user/" +
						  image.username + "/avatar"
					  )
				      )
				  ),
			      ),
			  ),
		      ),
		      Container(
			  padding: EdgeInsets.only(left: 10),
			  child: Text(
			      image.username,
			      style: TextStyle(fontWeight: FontWeight.w600),
			  ),
		      ),
		  ],
	      )
	  );
      }
      return Container();
  }

  Widget createPostImage(BuildContext context, GalleryImage image) {
      if (this.widget.isFromUser == true) {
	  return Card(
	    elevation: 7,
	    child: Image.network(
		"https://i.imgur.com/" +
		    image.id +
		    "." + ((image.imagesInfo == null) ? "jpg": image.imagesInfo[0].type.split('/')[1]),
	    ),
	  );
      }
      return Image.network(
	  "https://i.imgur.com/" +
	      image.cover +
	      "." +
	      image.imagesInfo[0].type.split('/')[1],
	  fit: BoxFit.fill,
      );
  }

  Widget createPostActions(BuildContext context, GalleryImage image) {
      if (this.widget.isFromUser == true) {
          return Container(
	      padding: EdgeInsets.all(10),
	      child: Row(
		  mainAxisAlignment: MainAxisAlignment.end,
		  children: <Widget>[
		      Container(
			  child: Text(
			      image.views.toString() + " views",
			      style: TextStyle(fontWeight: FontWeight.w600),
			  ),
		      )
		  ],
	      ),
	  );
      }
      return Container();
  }
}
