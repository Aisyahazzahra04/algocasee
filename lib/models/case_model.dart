class CaseModel {
  final String id;
  final String title;
  final String difficulty;
  final CaseBriefing briefing;
  final ProblemAnalysis problemAnalysis;
  final InformationIdentification informationIdentification;
  final InputOutputRules inputOutputRules;
  final LogicBuilder logicBuilder;
  final List<TestCase> testCases;
  final Feedback feedback;

  CaseModel({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.briefing,
    required this.problemAnalysis,
    required this.informationIdentification,
    required this.inputOutputRules,
    required this.logicBuilder,
    required this.testCases,
    required this.feedback,
  });

  factory CaseModel.fromJson(Map<String, dynamic> json) {
    return CaseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      difficulty: json['difficulty'] as String,

      briefing: CaseBriefing.fromJson(
        Map<String, dynamic>.from(json['briefing']),
      ),

      problemAnalysis: ProblemAnalysis.fromJson(
        Map<String, dynamic>.from(json['problem_analysis']),
      ),

      informationIdentification:
          InformationIdentification.fromJson(
        Map<String, dynamic>.from(
          json['information_identification'],
        ),
      ),

      inputOutputRules: InputOutputRules.fromJson(
        Map<String, dynamic>.from(
          json['input_output_rules'],
        ),
      ),

      logicBuilder: LogicBuilder.fromJson(
        Map<String, dynamic>.from(
          json['logic_builder'],
        ),
      ),

      testCases: (json['test_cases'] as List)
          .map(
            (item) => TestCase.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),

      feedback: Feedback.fromJson(
        Map<String, dynamic>.from(
          json['feedback'],
        ),
      ),
    );
  }
}

// ============================================================
// CASE BRIEFING
// ============================================================

class CaseBriefing {
  final String description;
  final String mission;
  final List<String> rules;
  final List<BriefingFact> facts;

  CaseBriefing({
    required this.description,
    required this.mission,
    required this.rules,
    required this.facts,
  });

  factory CaseBriefing.fromJson(
    Map<String, dynamic> json,
  ) {
    return CaseBriefing(
      description: json['description'] as String,
      mission: json['mission'] as String,

      rules: List<String>.from(
        json['rules'],
      ),

      facts: (json['facts'] as List)
          .map(
            (item) => BriefingFact.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
    );
  }
}

// ============================================================
// BRIEFING FACT
// ============================================================

class BriefingFact {
  final String label;
  final String value;

  BriefingFact({
    required this.label,
    required this.value,
  });

  factory BriefingFact.fromJson(
    Map<String, dynamic> json,
  ) {
    return BriefingFact(
      label: json['label'] as String,
      value: json['value'] as String,
    );
  }
}

// ============================================================
// PROBLEM ANALYSIS
// ============================================================

class ProblemAnalysis {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String feedbackCorrect;
  final String feedbackWrong;

  ProblemAnalysis({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.feedbackCorrect,
    required this.feedbackWrong,
  });

  factory ProblemAnalysis.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProblemAnalysis(
      question: json['question'] as String,

      options: List<String>.from(
        json['options'],
      ),

      correctAnswer: json['correct_answer'] as int,

      feedbackCorrect:
          json['feedback_correct'] as String,

      feedbackWrong:
          json['feedback_wrong'] as String,
    );
  }
}

// ============================================================
// INFORMATION IDENTIFICATION
// ============================================================

class InformationIdentification {
  final String question;
  final List<InformationItem> information;

  InformationIdentification({
    required this.question,
    required this.information,
  });

  factory InformationIdentification.fromJson(
    Map<String, dynamic> json,
  ) {
    return InformationIdentification(
      question: json['question'] as String,

      information: (json['information'] as List)
          .map(
            (item) => InformationItem.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
    );
  }
}

// ============================================================
// INFORMATION ITEM
// ============================================================

class InformationItem {
  final String text;
  final bool relevant;

  InformationItem({
    required this.text,
    required this.relevant,
  });

  factory InformationItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return InformationItem(
      text: json['text'] as String,
      relevant: json['relevant'] as bool,
    );
  }
}

// ============================================================
// INPUT OUTPUT & RULES
// ============================================================

class InputOutputRules {
  final String inputQuestion;
  final List<String> inputOptions;
  final int inputAnswer;

  final String outputQuestion;
  final List<String> outputOptions;
  final int outputAnswer;

  final String rulesQuestion;
  final MultiSelectionQuestion rules;

  InputOutputRules({
    required this.inputQuestion,
    required this.inputOptions,
    required this.inputAnswer,
    required this.outputQuestion,
    required this.outputOptions,
    required this.outputAnswer,
    required this.rulesQuestion,
    required this.rules,
  });

factory InputOutputRules.fromJson(
  Map<String, dynamic> json,
) {
  final input = Map<String, dynamic>.from(
    json['input'],
  );

  final output = Map<String, dynamic>.from(
    json['output'],
  );

  final rulesData = Map<String, dynamic>.from(
    json['rules'],
  );

  return InputOutputRules(
    inputQuestion: input['question'] as String,

    inputOptions: List<String>.from(
      input['options'],
    ),

    inputAnswer: input['correct_answer'] as int,

    outputQuestion: output['question'] as String,

    outputOptions: List<String>.from(
      output['options'],
    ),

    outputAnswer: output['correct_answer'] as int,

    rulesQuestion: rulesData['question'] as String,

    rules: MultiSelectionQuestion.fromJson(
      rulesData,
    ),
  );
}
}

// ============================================================
// MULTI SELECTION QUESTION
// ============================================================

class MultiSelectionQuestion {
  final List<RuleOption> options;

  MultiSelectionQuestion({
    required this.options,
  });

  factory MultiSelectionQuestion.fromJson(
    dynamic json,
  ) {
    if (json is List) {
      return MultiSelectionQuestion(
        options: json.map(
          (item) {
            final data =
                Map<String, dynamic>.from(item);

            return RuleOption(
              text: data['text'] as String,
              correct: data['correct'] as bool,
            );
          },
        ).toList(),
      );
    }

    if (json is Map<String, dynamic>) {
      final optionTexts =
          List<String>.from(json['options']);

      final correctAnswers =
          List<int>.from(json['correct_answers']);

      return MultiSelectionQuestion(
        options: List.generate(
          optionTexts.length,
          (index) {
            return RuleOption(
              text: optionTexts[index],
              correct:
                  correctAnswers.contains(index),
            );
          },
        ),
      );
    }

    throw FormatException(
      'Format rules tidak dikenali.',
    );
  }
}

// ============================================================
// RULE OPTION
// ============================================================

class RuleOption {
  final String text;
  final bool correct;

  RuleOption({
    required this.text,
    required this.correct,
  });
}

// ============================================================
// LOGIC BUILDER
// ============================================================

class LogicBuilder {
  final List<String> availableBlocks;
  final List<String> expectedLogic;

  LogicBuilder({
    required this.availableBlocks,
    required this.expectedLogic,
  });

  factory LogicBuilder.fromJson(
    Map<String, dynamic> json,
  ) {
    return LogicBuilder(
      availableBlocks: List<String>.from(
        json['available_blocks'],
      ),

      expectedLogic: List<String>.from(
        json['expected_logic'],
      ),
    );
  }
}

// ============================================================
// TEST CASE
// ============================================================

class TestCase {
  final Map<String, dynamic> input;
  final dynamic expectedResult;

  TestCase({
    required this.input,
    required this.expectedResult,
  });

  factory TestCase.fromJson(
    Map<String, dynamic> json,
  ) {
    return TestCase(
      input: Map<String, dynamic>.from(
        json['input'],
      ),

      expectedResult:
          json['expected_result'],
    );
  }
}

// ============================================================
// FEEDBACK
// ============================================================

class Feedback {
  final String correct;
  final String wrong;

  Feedback({
    required this.correct,
    required this.wrong,
  });

  factory Feedback.fromJson(
    Map<String, dynamic> json,
  ) {
    return Feedback(
      correct: json['correct'] as String,
      wrong: json['wrong'] as String,
    );
  }
}