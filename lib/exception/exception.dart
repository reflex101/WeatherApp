class FetchCityException implements Exception{
  final String message;
  FetchCityException(this.message);


  @override
  String toString(){
    return message;
    // if (message == null){
    //   return "Exception";
    // }else{
    //   return "Exception: $message";
    // }
  }
}