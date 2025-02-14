import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/utils/colors.dart';
import 'package:testapp/utils/theme_provider.dart';
class Customersupport extends StatefulWidget {
  const Customersupport({super.key});

  @override
  State<Customersupport> createState() => _CustomersupportState();
}

class _CustomersupportState extends State<Customersupport> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text("Customer Support",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500,color: Colors.white),),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40),bottomRight: Radius.circular(40))
        ),

      ),
      body:Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(

            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        width: 1,
                        color: Colors.grey

                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text("How can we assist you?",style: TextStyle(fontSize: 20),),
                        ),
                        ListTile(
                          title: Text("Attendance Issues",style: TextStyle(color: themeProvider.textColor),),
                          subtitle: Text("Problem with your attendance record",style: TextStyle(color: themeProvider.textColor)),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                        Divider(
                          thickness: 3,
                          color: themeProvider.textColor,

                        ),
                        ListTile(
                          title: Text("Login Issues",style: TextStyle(color: themeProvider.textColor)),
                          subtitle: Text("Trouble Signing In",style: TextStyle(color: themeProvider.textColor)),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                      ]
                  ),
                ),
              ),
              SizedBox(height: 25,),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        width: 1,
                        color: Colors.grey

                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text("Speak with a Representative",style: TextStyle(fontSize: 20),),
                        ),
                        SizedBox(height: 5,),
                        ListTile(
                          title: Text("Our support team is available 24/7 to assist you with any isssue or concern",style: TextStyle(color: Colors.grey[500]),),
                        ),
                        SizedBox(height: 10,),
                        Center(
                          child: SizedBox(
                            width: w*0.7,
                            child: ElevatedButton(


                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    )

                                ),
                                onPressed: (){},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.call,color: Colors.white,),
                                    SizedBox(width: 10,),
                                    Text("Call Support",style: TextStyle(color:Colors.white,fontSize: 18),)
                                  ],
                                )),
                          ),
                        )
                      ]
                  ),
                ),
              ),
              SizedBox(height: 25,),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        width: 1,
                        color: Colors.grey

                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text("FAQs",style: TextStyle(fontSize: 20),),
                        ),

                        ListTile(
                          title: Text("What if my attendance marked incorrectly?",style: TextStyle(color: themeProvider.textColor)),
                          trailing: Icon(Icons.add,color: themeProvider.textColor,),
                        ),
                        Divider(
                          thickness: 3,

                        ),
                        ListTile(
                          title: Text("How can I reset my password?",style: TextStyle(color: themeProvider.textColor)),
                          trailing: Icon(Icons.add,color: themeProvider.textColor,),
                        ),
                      ]
                  ),
                ),
              ),
              SizedBox(height: 25,),
              Text("Still need help? Email us at support@presencepro.com",style: TextStyle(fontSize: 16,color: Colors.grey),)
            ],
          ),
        ),
      ),
    );
  }
}
