import 'package:flutter/material.dart';

class AtsDetail extends StatelessWidget {
  const AtsDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.all(16.0),
      padding:const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color:Colors.white),
        borderRadius:BorderRadius.circular(10),
       color: Colors.white.withOpacity(0.15),
      ),
      child:Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: Colors.yellowAccent, size: 10),
              const SizedBox(height: 10,),
              const Text('How our System Works?',
               style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Ensure text is visible on gradient
                ),
              ),
            ],
          ),
          const SizedBox(height:5),
          _buildFeaturePoint(
            icon:Icons.search,
            text:'We cross-reference keywords from your resume against the job title.',
          ),
          _buildFeaturePoint(
            icon: Icons.score,
            text: 'Get an **ATS Compatibility Score** to see your ranking.',
          ),
          _buildFeaturePoint(
            icon: Icons.add_circle_outline,
            text: 'Receive clear suggestions on **what to add** for a higher score.',
          ),
          _buildFeaturePoint(
            icon: Icons.remove_circle_outline,
            text: 'Identify and **remove** low-impact or redundant content.',
          ),
        ],
      ),
    );
  }
}
Widget _buildFeaturePoint({required IconData icon, required String text}){
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child:Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        Icon(icon, color: Colors.white70, size: 12),
        const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
      ]
    )
  );
}