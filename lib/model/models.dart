class Student  {
  late int studentID ;
  late String name ;
  late double payedAmount  ;

  Student({required this.studentID , required this.name , required this.payedAmount});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentID: json["mat"],
      name: json["name"],
      payedAmount: json["payedAmount"]
    );
  }

  Map<String , dynamic> toJson(){
    return {
      "mat" : studentID ,
      "name" : name ,
      "payedAmount" : payedAmount
    };

  }

  Student.syncStudentList() {
    /*
  * this function fetches the student list from
  * GET http://localhost:8080/api/v1/students
  * and then saves it to the local data base
  *
  *  */




  }
}

class VerificationAmount {
  late double amount;

  VerificationAmount({required this.amount}) ;


}