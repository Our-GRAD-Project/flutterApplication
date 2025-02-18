class SurveyData {
  String? gender;
  String? ageRange;
  List<String>? areasToImprove;
  List<String>? selectedBooks;
  bool? agreementResponse;

  SurveyData({
    this.gender,
    this.ageRange,
    this.areasToImprove,
    this.selectedBooks ,
    this.agreementResponse,
  }){
    if(this.selectedBooks == null){ this.selectedBooks = [];
    }if(this.areasToImprove == null){ this.areasToImprove = [];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'ageRange': ageRange,
      'areasToImprove': areasToImprove,
      'selectedBooks': selectedBooks,
      'agreementResponse': agreementResponse,
    };
  }

  factory SurveyData.fromJson(Map<String, dynamic> json) {
    return SurveyData(
      gender: json['gender'],
      ageRange: json['ageRange'],
      areasToImprove: json['areasToImprove'] != null
          ? List<String>.from(json['areasToImprove'])
          : null,
      selectedBooks: json['selectedBooks'] != null
          ? List<String>.from(json['selectedBooks'])
          : null,
      agreementResponse: json['agreementResponse'],
    );
  }
}


