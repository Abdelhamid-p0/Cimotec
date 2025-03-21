import 'package:flutter/material.dart';

class Largebutton  extends StatelessWidget{

    
    String routeName= "" ;
    String buttonName= "" ;


    Largebutton (this.buttonName , this.routeName, {super.key});
    
      @override
      Widget build(BuildContext context) {
   
        return  ElevatedButton(
                   onPressed: () {
                     //navig to select page
                    Navigator.pushNamed(context, routeName);
                   },
                   style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.white.withOpacity(0.2),
                     foregroundColor: Colors.white,
                     padding: EdgeInsets.symmetric(vertical: 16),
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(8),
                       side: BorderSide(color: Colors.white.withOpacity(0.5)),
                     ),
                     elevation: 0,
                   ),
                   child: Text(
                     buttonName,
                     style: TextStyle(
                       fontWeight: FontWeight.bold,
                       letterSpacing: 1.2,
                     ),
                   ),
                );
      }
    
    
    
}

