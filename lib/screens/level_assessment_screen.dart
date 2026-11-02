import 'dart:math';
import 'package:flutter/material.dart';
import '../data/b1_course_data.dart';
import '../data/b2_course_data.dart';
import '../data/c1_course_data.dart';
import '../data/c2_course_data.dart';
import '../data/course_catalog.dart';
import '../screens/course_lesson_screen.dart';
import '../services/learning_progress.dart';
import '../theme/app_theme.dart';

class _AssessmentQuestion {
  const _AssessmentQuestion(this.prompt, this.options, this.answer, this.explanation);
  final String prompt;
  final List<String> options;
  final int answer;
  final String explanation;
}

class LevelAssessmentScreen extends StatefulWidget {
  const LevelAssessmentScreen({super.key, this.level = 'A1'});
  final String level;

  @override
  State<LevelAssessmentScreen> createState() => _LevelAssessmentScreenState();
}

class _LevelAssessmentScreenState extends State<LevelAssessmentScreen> {
  /// Builds the diagnostic pool from the actual lessons of the requested CEFR level.
  /// A1/A2 contribute one authored question per lesson; B1-C2 contribute their
  /// complete lesson question sets, so advanced assessments are not beginner-only.
  static List<_AssessmentQuestion> _questionBankForLevel(String level) {
    final pool = <_AssessmentQuestion>[];
    for (final unit in CourseCatalog.units.where((unit) => unit.level == level)) {
      for (var index = 0; index < unit.lessons.length; index++) {
        switch (level) {
          case 'A1':
          case 'A2':
            final lesson = LessonContent.find(unit.id, index);
            if (lesson != null) {
              pool.add(_AssessmentQuestion(
                lesson.question, lesson.options, lesson.answer, lesson.feedback,
              ));
            }
            break;
          case 'B1':
            final lesson = B1CourseData.find(unit.id, index + 1);
            if (lesson != null) {
              pool.addAll(lesson.questions.map((q) =>
                _AssessmentQuestion(q.prompt, q.options, q.answer, q.explanation)));
            }
            break;
          case 'B2':
            final lesson = B2CourseData.find(unit.id, index + 1);
            if (lesson != null) {
              pool.addAll(lesson.questions.map((q) =>
                _AssessmentQuestion(q.prompt, q.options, q.answer, q.explanation)));
            }
            break;
          case 'C1':
            final lesson = C1CourseData.find(unit.id, index + 1);
            if (lesson != null) {
              pool.addAll(lesson.questions.map((q) =>
                _AssessmentQuestion(q.prompt, q.options, q.answer, q.explanation)));
            }
            break;
          case 'C2':
            final lesson = C2CourseData.find(unit.id, index + 1);
            if (lesson != null) {
              pool.addAll(lesson.questions.map((q) =>
                _AssessmentQuestion(q.prompt, q.options, q.answer, q.explanation)));
            }
            break;
        }
      }
    }
    return pool;
  }

  static const _questionsPerAttempt = 10;
  late List<_AssessmentQuestion> _questions;

  int _index = 0;
  int _score = 0;
  int? _selected;
  bool _finished = false;
  bool _saving = false;
  int _best = 0;

  @override
  void initState() {
    super.initState();
    _newQuestionSet();
    _loadBest();
  }

  void _newQuestionSet() {
    final pool = _questionBankForLevel(widget.level)..shuffle(Random());
    if (pool.length < _questionsPerAttempt) {
      throw StateError('Assessment bank for ${widget.level} has fewer than $_questionsPerAttempt questions.');
    }
    _questions = pool.take(_questionsPerAttempt).toList(growable: false);
  }

  Future<void> _loadBest() async {
    final value = await LearningProgress.levelAssessmentBest(widget.level);
    if (mounted) setState(() => _best = value);
  }

  Future<void> _answer(int option) async {
    if (_selected != null || _finished) return;
    final question = _questions[_index];
    setState(() {
      _selected = option;
      if (option == question.answer) _score++;
    });
    if (option != question.answer) {
      await LearningProgress.recordMissedQuestionDetails(
        prompt: question.prompt,
        selectedAnswer: question.options[option],
        correctAnswer: question.options[question.answer],
        explanation: question.explanation,
        topic: _topicFor(question.prompt),
        source: 'تقييم المستوى ${widget.level}',
      );
    }
  }

  String _topicFor(String prompt) {
    if (prompt.contains('ضمير')) return 'الضمائر الشخصية';
    if (prompt.contains('جمع')) return 'الجمع والانسجام الصوتي';
    if (prompt.contains('Günaydın') || prompt.contains('Teşekkür') ||
        prompt.contains('Lütfen') || prompt.contains('akşamlar')) return 'التحيات والعبارات اليومية';
    if (prompt.contains('Nerede') || prompt.contains('ner')) return 'السؤال عن المكان';
    if (prompt.contains('kitap') || prompt.contains('Su')) return 'المفردات الأساسية';
    if (prompt.contains('Benim evim') || prompt.contains('صفة')) return 'ترتيب الكلمات والصفات';
    if (prompt.contains('Bugün') || prompt.contains('Yarın')) return 'الزمن والأيام';
    if (prompt.contains('konuşuyorum') || prompt.contains('النفي')) return 'الأفعال والتصريف';
    if (prompt.contains('Adın') || prompt.contains('yaşındasın')) return 'التعارف والمعلومات الشخصية';
    return 'القواعد والمفردات الأساسية';
  }

  Future<void> _next() async {
    if (_selected == null || _saving) return;
    if (_index < _questions.length - 1) {
      setState(() { _index++; _selected = null; });
      return;
    }
    setState(() => _saving = true);
    final percent = _score * 100 ~/ _questions.length;
    await LearningProgress.recordLevelAssessment(widget.level, percent);
    await LearningProgress.recordLevelAssessmentAttempt(
      level: widget.level, score: _score, total: _questions.length,
    );
    final best = await LearningProgress.levelAssessmentBest(widget.level);
    if (!mounted) return;
    setState(() { _best = best; _finished = true; _saving = false; });
  }

  void _restart() {
    setState(() {
      _newQuestionSet();
      _index = 0;
      _score = 0;
      _selected = null;
      _finished = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF5F7FC),
    appBar: AppBar(
      backgroundColor: const Color(0xFFF5F7FC),
      foregroundColor: AppColors.darkGreen,
      elevation: 0,
      title: Text('تقييم المستوى ${widget.level}', style: const TextStyle(fontWeight: FontWeight.w900)),
    ),
    body: SafeArea(child: ListView(
      padding: const EdgeInsets.fromLTRB(17, 8, 17, 28),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.border)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('اختبار تشخيصي للمستوى', style: TextStyle(color: AppColors.darkGreen, fontSize: 17, fontWeight: FontWeight.w900)),
            const SizedBox(height: 5),
            const Text('10 أسئلة مختارة عشوائياً من بنك يضم 20 سؤالاً في المفردات والتراكيب والقواعد الأساسية. درجة الاجتياز 80%.', style: TextStyle(color: AppColors.muted, fontSize: 11, height: 1.6)),
            const SizedBox(height: 9),
            Text('أفضل نتيجة محفوظة: $_best%', style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w800)),
          ]),
        ),
        const SizedBox(height: 14),
        if (_finished) _result() else _questionCard(),
      ],
    )),
  );

  Widget _questionCard() {
    final q = _questions[_index];
    final answered = _selected != null;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Text('السؤال ${_index + 1} من ${_questions.length}', style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w900, fontSize: 12)),
          const Spacer(),
          Text('$_score صحيحة', style: const TextStyle(color: AppColors.muted, fontSize: 11)),
        ]),
        const SizedBox(height: 10),
        LinearProgressIndicator(value: (_index + (answered ? 1 : 0)) / _questions.length, minHeight: 7,
          backgroundColor: const Color(0xFFE9EEF6), color: const Color(0xFF2E82C7)),
        const SizedBox(height: 22),
        Text(q.prompt, textAlign: TextAlign.right, style: const TextStyle(color: AppColors.darkGreen, fontSize: 19, height: 1.5, fontWeight: FontWeight.w900)),
        const SizedBox(height: 16),
        ...List.generate(q.options.length, (i) {
          final correct = i == q.answer;
          final selected = i == _selected;
          final color = answered && correct ? const Color(0xFFE8F7EF) :
              answered && selected ? const Color(0xFFFFEEEE) : const Color(0xFFF7F9FC);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: color,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: answered ? null : () => _answer(i),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: answered && correct ? const Color(0xFF62B889) : AppColors.border)),
                  child: Text(q.options[i], textAlign: TextAlign.right, style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w800)),
                ),
              ),
            ),
          );
        }),
        if (answered) Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(q.explanation, textAlign: TextAlign.right, style: const TextStyle(color: AppColors.navy, fontSize: 12, height: 1.6)),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: answered && !_saving ? _next : null,
          style: FilledButton.styleFrom(backgroundColor: AppColors.navy, minimumSize: const Size.fromHeight(50)),
          child: _saving ? const CircularProgressIndicator(color: Colors.white) :
            Text(_index == _questions.length - 1 ? 'إنهاء التقييم' : 'السؤال التالي'),
        ),
      ]),
    );
  }

  Widget _result() {
    final percent = _score * 100 ~/ _questions.length;
    final passed = percent >= 80;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: AppColors.border)),
      child: Column(children: [
        Icon(passed ? Icons.workspace_premium_rounded : Icons.menu_book_rounded,
          color: passed ? const Color(0xFFE2A63B) : AppColors.navy, size: 54),
        const SizedBox(height: 12),
        Text(passed ? 'اجتزت التقييم!' : 'تحتاج إلى مراجعة إضافية',
          style: const TextStyle(color: AppColors.darkGreen, fontSize: 21, fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        Text('$percent%', style: const TextStyle(color: AppColors.navy, fontSize: 36, fontWeight: FontWeight.w900)),
        Text('$_score من ${_questions.length} إجابات صحيحة', style: const TextStyle(color: AppColors.muted)),
        const SizedBox(height: 10),
        Text(passed ? 'حققت شرط الاجتياز لهذا التقييم التشخيصي.' : 'راجع الدروس الأساسية ثم أعد المحاولة. تحتاج إلى 80% للاجتياز.',
          textAlign: TextAlign.center, style: const TextStyle(color: AppColors.muted, height: 1.6, fontSize: 12)),
        const SizedBox(height: 8),
        Text('أفضل نتيجة محفوظة: $_best%', style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w800)),
        const SizedBox(height: 15),
        SizedBox(width: double.infinity, child: FilledButton.icon(
          onPressed: _restart, icon: const Icon(Icons.refresh_rounded), label: const Text('إعادة التقييم'),
          style: FilledButton.styleFrom(backgroundColor: AppColors.navy, minimumSize: const Size.fromHeight(50)),
        )),
      ]),
    );
  }
}
