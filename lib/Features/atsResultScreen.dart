import 'package:ats_score_booster/common/atsscore.dart';
import 'package:flutter/material.dart';


class ResultScreen extends StatelessWidget {
  final AtsScoreResult result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    // We reuse the gradient background for consistency
    return Scaffold(
      appBar: AppBar(
        title: const Text('ATS Analysis Results'),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.deepPurple],
              begin: Alignment.bottomLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.deepPurpleAccent],
            begin: Alignment.bottomLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overall Score Card
              Card(
                color: Colors.white.withOpacity(0.95),
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'Compatibility Score',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${result.score}%',
                          style: TextStyle(
                            fontSize: 72,
                            fontWeight: FontWeight.w900,
                            color: result.score >= 70 ? Colors.green.shade700 : Colors.red.shade700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          result.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Keywords Matched
              _buildSectionCard(
                title: '✅ Matched Keywords',
                items: result.matchedKeywords,
                color: Colors.green.shade50,
                icon: Icons.check_circle_outline,
              ),

              const SizedBox(height: 20),

              // Keywords to Add
              _buildSectionCard(
                title: '➕ Keywords to Add',
                items: result.toAdd,
                color: Colors.amber.shade50,
                icon: Icons.lightbulb_outline,
                emptyMessage: "Great! You matched all major keywords.",
              ),
              
              const SizedBox(height: 20),

              // Recommendations to Remove
              _buildSectionCard(
                title: '➖ Content to Refine',
                items: result.toRemove,
                color: Colors.red.shade50,
                icon: Icons.delete_outline,
                isList: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to build consistent section cards
  Widget _buildSectionCard({
    required String title,
    required List<String> items,
    required Color color,
    required IconData icon,
    String? emptyMessage,
    bool isList = true,
  }) {
    return Card(
      color: color,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blueGrey, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ],
            ),
            const Divider(color: Colors.black26, height: 16),
            if (items.isEmpty && emptyMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(emptyMessage, style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black54)),
              ),
            if (items.isNotEmpty)
              ...items.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isList) const Icon(Icons.circle, size: 8, color: Colors.black54),
                      if (isList) const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}
