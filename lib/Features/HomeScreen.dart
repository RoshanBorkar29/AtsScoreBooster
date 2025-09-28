// The problematic line is removed/modified
// import 'dart:ui' as BorderType; // <--- REMOVE THIS LINE
import 'package:ats_score_booster/common/atsdetail.dart';
import 'package:ats_score_booster/common/myTextField.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final TextEditingController _jobController=TextEditingController();
  PlatformFile? _selectedResume; // Holds the file details
  bool _isLoading = false; 

  Future<void> _pickResume()async {
    if(_isLoading)return;
    try{
      FilePickerResult? result=await FilePicker.platform.pickFiles(
        type:FileType.custom,
        allowedExtensions: ['pdf','docx'],
      );
      if(result!=null){
        setState(() {
          _selectedResume=result.files.first;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected,${_selectedResume!.name}'),),
        );
      }
    }
    catch(e){
       print('Error picking file: $e');
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error selecting file.')),
    );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          title: Text(
            'ATSScoreBooster',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.white],
                begin: Alignment.bottomLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.greenAccent, Colors.deepPurpleAccent],
            begin: Alignment.bottomLeft,
            end: Alignment.bottomRight,
          ),
        ),
       
        child: Padding(
          padding: const EdgeInsets.only(top: 20,left:10,right:10),
          child: Column(
            children: [
              //border filledlike container
              GestureDetector(
                onTap:_pickResume,
                child: DottedBorder(
                  // The BorderType enum is now correctly referenced from the dotted_border package
                     options: RectDottedBorderOptions(
                   // borderRadius: BorderRadius.circular(12), // replaces old "radius"
                    strokeWidth: 2,
                    color: Colors.grey,
                    dashPattern: [8, 4],
                  ),
                  
                  // Add a size constraint to the inner Container so the DottedBorder has dimensions
                  child: Container(
                    height: 150, // Example size
                    width: double.infinity, // Example size
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 35),
                      child: Column(
                        
                        children: [
                          Icon(Icons.file_copy_outlined,size:25),
                          const Text('Drop Your Resume here',style: TextStyle(fontSize: 22,fontWeight:FontWeight.bold),),
                      
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              //textfiled-job title
              const SizedBox(height:50),
            Mytextfield(controller: _jobController, hint:'Enter Job Title'),
            const SizedBox(height: 50,),
            
            //Submit button
          // NEW, IMPROVED CHECK SCORE BUTTON:
Container(
  width: 100, // Makes the button full width
  height: 30, // Gives it a nice, substantial height
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    // Use the same strong gradient as your AppBar/Body
    gradient: const LinearGradient(
      colors: [Colors.deepOrange, Colors.deepPurple], 
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
  ),
  child: ElevatedButton(
    onPressed: () {},
    // Remove default button styling to let the Container's gradient show through
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent, // Important: Make button background transparent
      shadowColor: Colors.transparent, // Optional: Remove shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.zero, // Remove default padding if necessary, though not strictly required here
      elevation: 0, // Remove default elevation
    ),
    child: const Text(
      'CHECK SCORE',
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: Colors.white, // Ensure text color contrasts with the dark gradient
      ),
    ),
  ),
),
          
          const SizedBox(height:5),
         AtsDetail(),
            ],
          ),
        ),
      ),
    );
  }
}