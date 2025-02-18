import 'data.dart';

class SurveyState {
  String? gender;
  String? ageRange;
  List<String> areasToImprove = [];
  List<String> selectedBooks = [];
  bool? agreementResponse;

  SurveyState({required SurveyData surveyData}) {
    gender = surveyData.gender;
    ageRange = surveyData.ageRange;
    areasToImprove = surveyData.areasToImprove ?? [];
    selectedBooks = surveyData.selectedBooks ?? [];
    agreementResponse = surveyData.agreementResponse;
  }


  bool isStepValid(int step) {
    switch (step) {
      case 0:
        return gender != null;
      case 1:
        return ageRange != null;
      case 2:
        return areasToImprove.isNotEmpty;
      case 3:
        return selectedBooks.length >= 3;
      case 4:
        return agreementResponse != null;
      default:
        return false;
    }
  }
}