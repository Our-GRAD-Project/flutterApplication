class SurveyData {
  String? gender;
  String? ageRange;
  List<String>? areasToImprove;
  List<String>? selectedBooks;
  bool? agreementResponse;
  String? contentType;
  List<String>? skillsToImprove;
  String? availableTime;

  SurveyData({
    this.gender,
    this.ageRange,
    this.areasToImprove,
    this.selectedBooks,
    this.agreementResponse,
    this.contentType,
    this.skillsToImprove,
    this.availableTime,
  }){
    if(this.selectedBooks == null){ this.selectedBooks = [];
    }if(this.areasToImprove == null){ this.areasToImprove = [];
    }if(this.skillsToImprove == null){ this.skillsToImprove = [];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'ageRange': ageRange,
      'areasToImprove': areasToImprove,
      'selectedBooks': selectedBooks,
      'agreementResponse': agreementResponse,
      'contentType': contentType,
      'skillsToImprove': skillsToImprove,
      'availableTime': availableTime,
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
      contentType: json['contentType'],
      skillsToImprove: json['skillsToImprove'] != null
          ? List<String>.from(json['skillsToImprove'])
          : null,
      availableTime: json['availableTime'],
    );
  }
}