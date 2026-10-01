class ProgressModel {
  final String id;
  final String userId;
  final String caseId;
  final int currentStep;
  final bool completed;
  final DateTime updatedAt;

  ProgressModel({
    required this.id,
    required this.userId,
    required this.caseId,
    required this.currentStep,
    required this.completed,
    required this.updatedAt,
  });
}