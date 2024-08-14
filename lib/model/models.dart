class Student  {
  late int studentID ;
  late String name ;
  late double payedAmount  ;

  Student({required this.studentID , required this.name , required this.payedAmount});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentID: json["mat"],
      name: json["name"],
      payedAmount: json["payed_amount"]
    );
  }

  Map<String , dynamic> toJson(){
    return {
      "mat" : studentID ,
      "name" : name ,
      "payedAmount" : payedAmount
    };

  }

}

class VerificationAmount {
  late double amount;

  VerificationAmount({required this.amount}) ;
  factory VerificationAmount.fromJson(Map<String, dynamic> json) {
    return VerificationAmount(
        amount: json["amount"],
    );
  }
}

class Api {
  late String api;

  Api({required this.api}) ;
  factory Api.fromJson(Map<String, dynamic> json) {
    return Api(
      api: json["api"],
    );
  }
}