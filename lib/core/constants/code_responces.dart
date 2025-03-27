class ResponseCode {
  static const success = 200; // success with data
  static const noContent = 201; // success with no data (no content)
  static const badRequest = 400; // failure, API rejected request
  static const unauthorized = 401; // failure, user is not authorised
  static const forbidden = 403; // failure, API rejected request
  static const iternalServerError = 500; // failure, crash in server side
  static const notFound = 404; // failure, not found

  // local status code
  static const connectTimeOut = -1;
  static const cancel = -2;
  static const receiveTimeout = -3;
  static const sendTimeout = -4;
  static const cacheError = -5;
  static const noInternetConnection = -6;
  static const defaultError = -7;
}