import 'package:flutter/material.dart';

class inputField  extends StatelessWidget{

    TextEditingController fieldController = TextEditingController();

    String hintText= "" ;

    inputField (this.fieldController , this.hintText, {super.key});
    
      @override
      Widget build(BuildContext context) {
   
        return Expanded(child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                border: Border.all(color: Colors.white.withOpacity(0.3)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                controller: fieldController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: hintText,
                                  hintStyle: TextStyle(color: Colors.white70),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  border: InputBorder.none,
                                  suffixIcon: Icon(Icons.person_outline, color: Colors.white70),
                                ),
                              ),
                            ),
                          );
      }
    
    
    
}

