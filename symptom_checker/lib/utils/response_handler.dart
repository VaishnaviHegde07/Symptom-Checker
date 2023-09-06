class Success {
  int? code;
  dynamic successResponse;
  Success({this.code, this.successResponse});
}

class Failure {
  int? code;
  dynamic errorResponse;
  Failure({this.code, this.errorResponse});
}
