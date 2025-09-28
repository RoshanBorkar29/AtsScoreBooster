import 'package:ats_score_booster/Features/atsResultScreen.dart';
import 'package:ats_score_booster/common/atsdetail.dart';
import 'package:ats_score_booster/common/atsscore.dart';
import 'package:ats_score_booster/common/myTextField.dart';

import 'package:ats_score_booster/services/atsapiscore.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final TextEditingController _jobController = TextEditingController();
  final AtsApiService _apiService = AtsApiService(); // Instantiate the API service
  
  PlatformFile? _selectedResume; // Holds the file details
  bool _isLoading = false; 

  // --- File Picker Logic ---
  Future<void> _pickResume() async {
    if (_isLoading) return;

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx'],
        withData: true, // CRITICAL: Must be true to get file bytes for API upload
      );

      if (result != null) {
        setState(() {
          _selectedResume = result.files.first;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected: ${_selectedResume!.name}')),
        );
      }
    } catch (e) {
      print('Error picking file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error selecting file.')),
      );
    }
  }

  // --- API Connection Logic (NEW) ---
  Future<void> _checkScore() async {
    // 1. Validation
    if (_selectedResume == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload a resume first.')),
      );
      return;
    }
    
    final String jobTitle = _jobController.text.trim(); 
    if (jobTitle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter the Job Title.')),
      );
      return;
    }

    // 2. Start Loading
    setState(() {
      _isLoading = true;
    });

    try {
      // 3. Call the API Service
      AtsScoreResult result = await _apiService.getScore(
        resumeFile: _selectedResume!,
        jobTitle: jobTitle,
      );

      // 4. Navigate on Success
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResultScreen(result: result)),
      );
    _jobController.clear();
    setState(() {
      _selectedResume=null;
    });
    } catch (e) {
      // 5. Handle Errors (Network, API validation, etc.)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', 'API Error: '))),
      );
      print('API CALL ERROR: $e');

    } finally {
      // 6. Reset Loading
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          title: const Text(
            'ATSScoreBooster',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              // RESTORING ORIGINAL GRADIENT COLORS
              gradient: LinearGradient(
                colors: [Colors.deepOrange, Colors.deepPurple], 
                begin: Alignment.bottomLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.deepPurpleAccent], // RESTORING BODY GRADIENT
            begin: Alignment.bottomLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Column(
            children: [
              // Dotted Border for Resume Drop
              GestureDetector(
                onTap: _pickResume,
                child: DottedBorder(
                  options: const RectDottedBorderOptions(
                    strokeWidth: 2,
                    color: Colors.white70, // Changed color to white for visibility
                    dashPattern: [8, 4],
                  ),
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _selectedResume != null ? Icons.check_circle_outline : Icons.file_copy_outlined,
                          size: 30,
                          color: _selectedResume != null ? Colors.lightGreenAccent : Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _selectedResume != null
                              ? 'File Ready: ${_selectedResume!.name}'
                              : 'Drop/Tap to Upload Resume (PDF/DOCX)',
                          style: TextStyle(
                            fontSize: _selectedResume != null ? 18 : 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 50),
              // Job Title Text Field
              Mytextfield(controller: _jobController, hint: 'Enter Job Title'),
              
              const SizedBox(height: 50),
              
              // CHECK SCORE BUTTON (FIXED STYLING AND ADDED LOGIC)
              Container(
                width: double.infinity, // FIX: Use full width
                height: 50,             // FIX: Use proper height
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [Colors.deepOrange, Colors.deepPurple], 
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _checkScore, // ATTACHED API CALL
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, 
                    shadowColor: Colors.transparent, 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0, 
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
                          'CHECK SCORE',
                          style: TextStyle(
                            fontSize: 20, // FIX: Increased font size
                            fontWeight: FontWeight.bold,
                            color: Colors.white, 
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 30),
              // ATS Detail Card
              const AtsDetail(),
            ],
          ),
        ),
      ),
    );
  }
}
