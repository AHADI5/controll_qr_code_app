class Student  {
  late String studentID ;
  late String name ;
  late int payedAmount  ;

  Student({required this.studentID , required this.name , required this.payedAmount});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentID: json["MAT"] ,
      name:  json["NAME"] ?? "NAN",
      payedAmount: json["AMOUNTPAYED"]
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
  late int amount;

  VerificationAmount({required this.amount}) ;
  factory VerificationAmount.fromJson(Map<String, dynamic> json) {
    return VerificationAmount(
        amount: json["amount"],
    );
  }
}

class StudentNumber {
  late int stNumber;

  StudentNumber({required this.stNumber}) ;
  factory StudentNumber.fromJson(Map<String, dynamic> json) {
    return StudentNumber(
      stNumber: json["stNumber"],
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