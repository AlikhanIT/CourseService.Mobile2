class Result<T> {
  bool isSuccess;
  T? data;
  String? errorMessage;

  Result.success({this.data}) : isSuccess = true;

  Result.error({this.errorMessage}) : isSuccess = false;
}
