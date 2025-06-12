import 'data.dart';

class SurveyState {
  String? gender;
  String? ageRange;
  List<String> areasToImprove = [];
  List<String> selectedBooks = [];
  bool? agreementResponse;
  String? contentType;
  List<String> skillsToImprove = [];
  String? availableTime;

  SurveyState({required SurveyData surveyData}) {
    gender = surveyData.gender;
    ageRange = surveyData.ageRange;
    areasToImprove = surveyData.areasToImprove ?? [];
    selectedBooks = surveyData.selectedBooks ?? [];
    agreementResponse = surveyData.agreementResponse;
    contentType = surveyData.contentType;
    skillsToImprove = surveyData.skillsToImprove ?? [];
    availableTime = surveyData.availableTime;
  }

  bool isStepValid(int step) {
    switch (step) {
      case 0: // Select your gender
        return gender != null;
      case 1: // What is your age?
        return ageRange != null;
      case 2: // What is your main goal in reading books? (areas to improve)
        return areasToImprove.isNotEmpty;
      case 3: // What type of content do you prefer?
        return contentType != null;
      case 4: // What skills or topics would you like to improve?
        return skillsToImprove.isNotEmpty;
      case 5: // What books are you interested in?
        return selectedBooks.length >= 3;
      case 6: // Do you agree with this sentence?
        return agreementResponse != null;
      case 7: // What time do you have available each day for reading or learning?
        return availableTime != null;
      default:
        return false;
    }
  }
}