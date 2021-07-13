import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart'; 
import 'package:google_fonts/google_fonts.dart';

class MyApp1 extends StatefulWidget {
  @override
  _MyApp1State createState() => _MyApp1State();
}

class _MyApp1State extends State<MyApp1> {
  var rating = 5.0;
  @override
  Widget build(BuildContext context) {    
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      title: Text(
        "We would like If you review our app on Play Store",
        textAlign: TextAlign.center,
        style: GoogleFonts.raleway(fontWeight: FontWeight.w300, fontSize: 18.0)
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: 45.0,
            child: SmoothStarRating(
              rating: rating,
              isReadOnly: false,
              size: 40,
              filledIconData: Icons.star,
              halfFilledIconData: Icons.star_half,
              defaultIconData: Icons.star_border,
              color: Colors.amber,
              borderColor: Colors.amber,
              starCount: 5,
              allowHalfRating: true,
              spacing: 2.0,
              onRated: (value) {},
        )
          ),
          SizedBox(height: 30.0),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: RawMaterialButton(
                    padding: EdgeInsets.all(25),
                    shape: CircleBorder(),
                    fillColor: Colors.white,
                    elevation: 5,
                    onPressed: () {Navigator.pop(context);},
                    child: Text('Thanks',style: GoogleFonts.montserrat(
                      textStyle: TextStyle(fontSize:15,color: Colors.black,fontWeight: FontWeight.w400)
                    ),),
                  ),
                ),
              ),

              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: RawMaterialButton(
                    padding: EdgeInsets.all(25),
                    shape: CircleBorder(),
                    fillColor: Colors.white,
                    elevation: 5,
                    onPressed: () {},
                    child: Text('Submit',style: GoogleFonts.montserrat(
                      textStyle: TextStyle(fontSize:15,color: Colors.black,fontWeight: FontWeight.w400)
                    ),),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}