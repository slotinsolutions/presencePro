import 'package:flutter/material.dart';
import 'package:testapp/pages/LoginScreen.dart';
import 'package:testapp/utils/colors.dart';

class Selecttype extends StatefulWidget {
  const Selecttype({super.key});

  @override
  State<Selecttype> createState() => _SelecttypeState();
}

class _SelecttypeState extends State<Selecttype> {
  String selectedOption = 'STUDENT';
  @override
  Widget build(BuildContext context) {
    double w= MediaQuery.of(context).size.width;
    double h= MediaQuery.of(context).size.height;
    return Scaffold(
    body: Container(

      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            AppColors.bgColor2,
            AppColors.bgColor,

          ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          )
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 600,
              height: 100,

              decoration: const BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                      image: AssetImage('assets/images/presencepro.png'),
                      fit: BoxFit.fitWidth
                  )
              ),),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text("  Select User Type",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            Container(
              height: h*0.12,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,width: 1.0,

                  ),
                  borderRadius: BorderRadius.circular(8.0)

              ),
              child: Center(
                child: ListTile(
                  onTap: (){
                    setState(() {
                      selectedOption = "STUDENT";
                    });
                  },
                  title: Text("STUDENT",style: TextStyle(color: Colors.white,fontSize: 24)),
                  leading: Radio(value: "STUDENT", groupValue: selectedOption,
                      activeColor: Colors.white,
                      onChanged: (value){
                        setState(() {
                          selectedOption = value!;
                        });
                      }),
                ),
              ),
            ),
            SizedBox(height: 15,),
            Container(
              height: h*0.12,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,width: 1.0,

                  ),
                  borderRadius: BorderRadius.circular(8.0)

              ),
              child: Center(
                child: ListTile(
                  onTap: (){
                    setState(() {
                      selectedOption = "STAFF";
                    });
                  },
                  title: Text("STAFF",style: TextStyle(color: Colors.white,fontSize: 24)),
                  leading: Radio(value: "STAFF", groupValue: selectedOption,
                      activeColor: Colors.white,
                      onChanged: (value){
                        setState(() {
                          selectedOption = value!;
                        });
                      }),
                ),
              ),
            ),
            SizedBox(height: 15,),
            Container(
              height: h*0.12,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,width: 1.0,

                  ),
                  borderRadius: BorderRadius.circular(8.0)

              ),
              child: Center(
                child: ListTile(
                  onTap: (){
                    setState(() {
                      selectedOption = "ADMIN";
                    });
                  },
                  title: Text("ADMIN",style: TextStyle(color: Colors.white,fontSize: 24),),
                  leading: Radio(value: "ADMIN", groupValue: selectedOption,
                      focusColor: Colors.white,
                      hoverColor: Colors.white,
                      activeColor: Colors.white,

                      onChanged: (value){
                        setState(() {
                          selectedOption = value!;
                        });
                      }),
                ),
              ),
            ),
            ]
        ),

            Center(

              child: SizedBox(
                width: w*0.7,
                child: ElevatedButton(onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>loginScreen(userType: selectedOption)));
                },
                    child: Text("Proceed",style: TextStyle(fontSize: 16,color: AppColors.primary),)),
              ),
            )
          ],
        ),
      ),
    ),
    );
  }
}
