import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/home.jpg"), fit: BoxFit.fill),
            ),
          ),
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: size.height*0.07,
                ),
                Text("Charts 4 U",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.white),),
                Spacer(),
                InkWell(
                  onTap: (){
                    context.go("/chart");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    height: 50,
                    alignment: Alignment.center,
                    width: size.width * 0.9,
                    child: Text(
                      'Welcome',
                      style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
