import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../services/learning_progress.dart';
import '../services/lesson_content_repository.dart';
import '../theme/app_theme.dart';

class JsonLessonScreen extends StatefulWidget {
  const JsonLessonScreen({
    super.key,
    required this.unitId,
    required this.unitTitle,
    required this.lessonTitle,
    required this.lessonNumber,
  });

  final String unitId;
  final String unitTitle;
  final String lessonTitle;
  final int lessonNumber;

  @override
  State<JsonLessonScreen> createState() => _JsonLessonScreenState();
}

class _JsonLessonScreenState extends State<JsonLessonScreen> {
  late Future<LessonRecord> _lessonFuture;
  final Map<int, int> _answers = {};
  bool _submitted = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _lessonFuture = LessonContentRepository.loadLesson(
      widget.unitId,
      widget.lessonNumber,
    );
  }

  int _score(LessonRecord lesson) => lesson.questions
      .asMap()
      .entries
      .where((entry) => _answers[entry.key] == entry.value.answerIndex)
      .length;

  Future<void> _submit(LessonRecord lesson) async {
    if (_answers.length != lesson.questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أجب عن جميع الأسئلة أولاً.')),
      );
      return;
    }
    setState(() => _saving = true);
    final lessonProgressId = '${widget.unitId}-${widget.lessonNumber}';
    final score = _score(lesson);
    await LearningProgress.recordAttempt(lessonProgressId);
    for (var i = 0; i < lesson.questions.length; i++) {
      final question = lesson.questions[i];
      if (_answers[i] != question.answerIndex) {
        await LearningProgress.recordMissedQuestionDetails(
          prompt: question.prompt,
          selectedAnswer: question.options[_answers[i]!],
          correctAnswer: question.options[question.answerIndex],
          explanation: question.explanation,
          topic: lesson.titleArabic,
          unitId: widget.unitId,
          lessonNumber: widget.lessonNumber,
          lessonTitle: lesson.titleArabic,
          source: '${lesson.level} lesson',
        );
      }
    }
    final requiredScore = math.max(1, (lesson.questions.length * 0.8).ceil());
    if (score >= requiredScore) {
      await LearningProgress.completeLesson(lessonProgressId);
    }
    if (!mounted) return;
    setState(() {
      _submitted = true;
      _saving = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'نتيجتك: $score من ${lesson.questions.length} — '
          '${score >= requiredScore ? "تم تسجيل إكمال الدرس" : "أعد المحاولة لتحسين نتيجتك"}',
        ),
      ),
    );
  }

  void _retry() {
    setState(() {
      _answers.clear();
      _submitted = false;
    });
  }

  Widget _section(String title, Widget child) => Card(
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: AppColors.darkGreen,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              child,
            ],
          ),
        ),
      );

  Widget _buildLesson(LessonRecord lesson) {
    final score = _score(lesson);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF102B52), Color(0xFF2676B8)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${lesson.level} • LESSON ${lesson.order}',
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  color: Color(0xFFFFD98A),
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                lesson.titleArabic.isEmpty ? widget.lessonTitle : lesson.titleArabic,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (lesson.titleTurkish.isNotEmpty) ...[
                const SizedBox(height: 5),
                Text(
                  lesson.titleTurkish,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(color: Colors.white70, height: 1.5),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                lesson.goal,
                textAlign: TextAlign.right,
                style: const TextStyle(color: Colors.white70, height: 1.7),
              ),
            ],
          ),
        ),
        if (lesson.rule.isNotEmpty)
          _section(
            'القاعدة والشرح',
            Text(lesson.rule, textAlign: TextAlign.right,
                style: const TextStyle(height: 1.8)),
          ),
        if (lesson.examples.isNotEmpty)
          _section(
            'أمثلة تطبيقية',
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: lesson.examples.map((example) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(example.turkish, textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 3),
                    Text(example.arabic, textAlign: TextAlign.right,
                        style: const TextStyle(color: AppColors.muted)),
                  ],
                ),
              )).toList(),
            ),
          ),
        if (lesson.dialogue.isNotEmpty)
          _section(
            'محادثة تطبيقية',
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: lesson.dialogue.map((line) => Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('${line.speaker}: ${line.turkish}',
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                    Text(line.arabic, textAlign: TextAlign.right,
                        style: const TextStyle(color: AppColors.muted)),
                  ],
                ),
              )).toList(),
            ),
          ),
        if (lesson.speakingTask.isNotEmpty)
          _section(
            'مهمة التحدث',
            Text(lesson.speakingTask, textAlign: TextAlign.right,
                style: const TextStyle(height: 1.8)),
          ),
        Text(
          'اختبر فهمك • ${lesson.questions.length} أسئلة',
          textAlign: TextAlign.right,
          style: const TextStyle(
            color: AppColors.darkGreen,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        ...lesson.questions.asMap().entries.map((entry) {
          final index = entry.key;
          final question = entry.value;
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'السؤال ${index + 1}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: AppColors.green,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(question.prompt,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: AppColors.darkGreen,
                        fontWeight: FontWeight.w800,
                        height: 1.6,
                      )),
                  const SizedBox(height: 5),
                  ...question.options.asMap().entries.map((option) {
                    final chosen = _answers[index] == option.key;
                    final correct = _submitted && option.key == question.answerIndex;
                    return RadioListTile<int>(
                      value: option.key,
                      groupValue: _answers[index],
                      onChanged: _submitted
                          ? null
                          : (value) => setState(() => _answers[index] = value!),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColors.green,
                      title: Text(option.value, textAlign: TextAlign.right),
                      subtitle: _submitted && chosen && !correct
                          ? Text('الإجابة الصحيحة: ${question.options[question.answerIndex]}')
                          : null,
                    );
                  }),
                  if (_submitted)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        question.explanation,
                        textAlign: TextAlign.right,
                        style: const TextStyle(color: AppColors.muted, height: 1.6),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
        if (_submitted) ...[
          Card(
            color: const Color(0xFFEAF5EE),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'نتيجتك: $score / ${lesson.questions.length}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.darkGreen,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          OutlinedButton(onPressed: _retry, child: const Text('إعادة المحاولة')),
        ] else
          ElevatedButton(
            onPressed: _saving ? null : () => _submit(lesson),
            child: Text(_saving ? 'جارٍ حفظ النتيجة...' : 'تصحيح الإجابات'),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFF5F7FC),
        appBar: AppBar(
          title: Text(widget.unitTitle),
          backgroundColor: Colors.white,
          foregroundColor: AppColors.darkGreen,
          elevation: 0,
        ),
        body: FutureBuilder<LessonRecord>(
          future: _lessonFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'تعذر تحميل الدرس من ملفات JSON.\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            return _buildLesson(snapshot.data!);
          },
        ),
      );
}
