
import 'package:google_fonts/google_fonts.dart';
import '../wave_clippers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../providers/data_provider.dart';
import '../services/impact.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ExercisePage extends StatefulWidget {
  ExercisePage({Key? key}) : super(key: key);  
  @override
  State<ExercisePage> createState() => _ExerciseState();
}
class _ExerciseState extends State<ExercisePage> {
  String start = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 6)));
  String end = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //String start = '2023-04-04';
  //String end = '2023-04-10';
  
  @override
  Widget build (BuildContext context){
    //final result = ImpactService.authorize();
                  //final message =
                  //    result == 200 ? 'Request successful' : 'Request failed';
                  //ScaffoldMessenger.of(context)
                  //  ..removeCurrentSnackBar()
                  //  ..showSnackBar(SnackBar(content: Text(message)));
    Provider.of<DataProvider>(context, listen: false)
                        .clearData();
    Provider.of<DataProvider>(context, listen: false)
                        .fetchExerciseData(start, end);
  
    return MaterialApp(home:  Scaffold(
      body: Stack(
      children: [
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [ 
              Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
              OutlinedButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back),
                  style: OutlinedButton.styleFrom(
                  side: BorderSide.none,
                ),
              ), 
              Text(
                'Exercise', 
                style: GoogleFonts.dancingScript(textStyle: TextStyle(color: Color(0xFF49688D), fontSize: 50),),
                textWidthBasis: TextWidthBasis.parent,
              ),
              ]
            ),
            // Top Half: Information Section
            Container(
              padding: EdgeInsets.all(16.0),
              //height: 300,
              color: Color(0xFFEED5C7),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Exercise Tips for Managing Anemia',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Regular exercise can help improve your overall health and well-being, especially if you are managing anemia. Here are some exercises that are safe and beneficial:',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                        'Recommended', 
                          style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 8),
                      const Row(
                        children: [
                        Icon(Icons.rowing, 
                          size: 30.0,
                          color: Colors.green,),
                        Icon(MaterialCommunityIcons.yoga, 
                          size: 30.0,
                          color: Colors.green,),
                        
                        Icon(FontAwesome.bicycle, 
                          size: 30.0,
                          color: Colors.green
                        ), 
                      ],),
                      SizedBox(height: 8),
                      Container(
                        width: 130,
                        child: Text('Low-impact exercise that improves circulation',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,)
                        )
                      ),],
                    ), 
                    Column(
                      children: [
                        const Text(
                          'To avoid', 
                          style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 8),
                        const Row(
                          children: [
                            Icon(Icons.sports_mma, 
                            size: 30.0,
                            color: Colors.red,),
                            Icon(MaterialCommunityIcons.run, 
                            size: 30.0,
                            color: Colors.red,),
                            Icon(Icons.sports_soccer, 
                            size: 30.0,
                            color: Colors.red,),
                              ],
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: 130,
                          child: Text('Exercises that are overly strenuous or impactful',
                          textAlign: TextAlign.center, 
                          style: TextStyle(
                          fontSize: 10,
                          ),
                        )),
                      ],
                    )
                    
                  ],
                ), 
              ],
            ),
          ),
          // Bottom Half: Scrollable List Section
          Container(
            height: 40,
            alignment: Alignment.centerLeft,
            child: const Text(
              'How good was your choice this week?',
              style: TextStyle(
                fontSize: 18,
              ),
            )
          ),
          Consumer<DataProvider>(builder: (context, data, child) {
            if (data.exerciseData.length!=0){
              return Expanded(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemCount: data.exerciseData.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          title: Text(data.exerciseData[index].activityName),
                          leading: Text(data.exerciseData[index].date),
                          trailing: checkActivity(data.exerciseData[index].activityName) == true ? Icon(Icons.check_box, color: Colors.green,) 
                          : Icon(Icons.close, color: Colors.red),
                        ),
                      );
                    },
                  ),
                ),
              );
            }
            else{
              return Container(
                width: 200,
                padding: EdgeInsets.all(12),
                color: Colors.red,
                child: Text(
                  "Looks like you missed wearing your smartwatch this week!",
                  style: TextStyle(color: Colors.white),
                )
              );
            }
          }),
            ]
          )
        ),
        Positioned(
          top: 0,
          right: 0,
          child: ClipPath(
          clipper: TopWaveClipper(),
          child: Container(
           width: 200,
           height: 150,
           color: Color(0xFFE15D55 ),
          ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: ClipPath(
          clipper: BottomWaveClipper(),
            child: Container(
               width: 300,
               height: 150,
               color: Color(0xFF49688D ),
            ),
          ),
        ),
        Positioned(
          bottom: 30,
          left: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 130.0),
                  child: TextButton(
                    child: Text('Food Admins', style: TextStyle(color: Colors.black, fontSize: 16)),
                    onPressed: () async {
                      final result = await ImpactService.authorize();
                      final message =
                          result == 200 ? 'Request successful' : 'Request failed';
                      print(message);
                    },
                  ),
                ),]
              )
            )
          )
      ]
      )
      )
      );
  }
}

bool checkActivity(String activityName){
  bool check = false;
  List<String> activities = ['Bici', 'Camminata'];
  if (activities.contains(activityName)){
    check = true;
  }
  return check;
}
