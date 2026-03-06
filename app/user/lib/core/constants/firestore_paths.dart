class FirestorePaths {
  static const users = 'users';
  static const serviceRequests = 'service_requests';

  static String quotes(String requestId) => '$serviceRequests/$requestId/quotes';
}
