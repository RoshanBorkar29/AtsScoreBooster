import 'package:ats_score_booster/common/atsscore.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Required for setting file content type
import 'package:file_picker/file_picker.dart';
import 'dart:convert';



class AtsApiService {

  final String _baseUrl = 'http://10.115.144.193:8000';

  Future<AtsScoreResult> getScore({
    required PlatformFile resumeFile,
    required String jobTitle,
  }) async {
    final uri = Uri.parse('$_baseUrl/process-resume');
    
    // 1. Create the Multipart Request
    var request = http.MultipartRequest('POST', uri);
    
    // 2. Attach Text Field (job_title)
    // Key must match the FastAPI Form parameter name
    request.fields['job_title'] = jobTitle;
    
    // Determine the content type based on the file extension
    final MediaType contentType = resumeFile.extension == 'pdf' 
        ? MediaType('application', 'pdf') 
        : MediaType('application', 'vnd.openxmlformats-officedocument.wordprocessingml.document');

    // 3. Attach File (resume_file)
    // Key 'resume_file' MUST match the parameter name in main.py's endpoint
    request.files.add(
      http.MultipartFile.fromBytes(
        'resume_file', 
        resumeFile.bytes!.toList(), // Get the bytes from the PlatformFile object
        filename: resumeFile.name,
        contentType: contentType,
      ),
    );

    try {
      // 4. Send Request and Get Response Stream
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // 5. Success: Decode JSON and convert to Dart Model
        final jsonMap = json.decode(response.body) as Map<String, dynamic>;
        return AtsScoreResult.fromJson(jsonMap);
      } else {
        // 6. Error: Server returned non-200 (e.g., 400 Bad Request from FastAPI validation)
        final responseBody = json.decode(response.body);
        final errorDetail = responseBody['detail'] ?? 'Unknown API Error';
        throw Exception('API Error (${response.statusCode}): $errorDetail');
      }
    } catch (e) {
      // 7. Network or unexpected error
      // This catches connection timeouts, DNS resolution failure, etc.
      throw Exception('Failed to connect to ATS Booster API. Ensure Python server is running on $_baseUrl. Error: $e');
    }
  }
}
