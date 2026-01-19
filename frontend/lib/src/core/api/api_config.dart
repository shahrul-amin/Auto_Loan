class ApiConfig {
  // Use 10.0.2.2 for Android Emulator (maps to host's localhost)
  // Use your PC's IP address for physical device (e.g., 'http://192.168.x.x:5000/api')
  static const String baseUrl = 'http://10.0.2.2:5000/api';
  static const Duration timeout = Duration(seconds: 30);

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
