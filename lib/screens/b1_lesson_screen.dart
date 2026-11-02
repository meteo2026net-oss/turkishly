import 'package:flutter/material.dart';
import '../data/b1_course_data.dart';
import '../data/b2_course_data.dart';
import '../data/c1_course_data.dart';
import '../services/learning_progress.dart';
import '../theme/app_theme.dart';

class B1LessonScreen extends StatefulWidget {
  const B1LessonScreen({
    super.key, required this.unitId, required this.unitTitle,
    required this.lessonTitle, required this.lessonNumber,
  });
  final String unitId, unitTitle, lessonTitle;
  final int lessonNumber;
  @override
  State<B1LessonScreen> createState() => _B1LessonScreenState();
}

class _B1LessonScreenState extends State<B1LessonScreen> {
  final Map<int, int> answers = {};
  bool checked = false;
  bool saving = false;

  Future<void> _submit(B1Lesson lesson) async {
    if (answers.length != lesson.questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أجب عن الأسئلة الخمسة أولاً.')));
      return;
    }
    setState(() => saving = true);
    final score = lesson.questions.asMap().entries
        .where((entry) => answers[entry.key] == entry.value.answer).length;
    final lessonId = '${widget.unitId}-${widget.lessonNumber}';
    await LearningProgress.recordAttempt(lessonId);
    for (var i = 0; i < lesson.questions.length; i++) {
      final q = lesson.questions[i];
      if (answers[i] != q.answer) {
        await LearningProgress.recordMissedQuestionDetails(
          prompt: q.prompt,
          selectedAnswer: q.options[answers[i]!],
          correctAnswer: q.options[q.answer],
          explanation: q.explanation,
          topic: lesson.title,
          unitId: widget.unitId,
          lessonNumber: widget.lessonNumber,
          lessonTitle: lesson.title,
          source: 'B1 lesson',
        );
      }
    }
    if (score >= 4) await LearningProgress.completeLesson(lessonId);
    if (!mounted) return;
    setState(() { checked = true; saving = false; });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('نتيجتك: $score من ${lesson.questions.length} — ${score >= 4 ? "تم تسجيل إكمال الدرس" : "أعد المحاولة للوصول إلى 4 إجابات صحيحة"}')));
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.unitId.startsWith('c1-')
        ? C1CourseData.find(widget.unitId, widget.lessonNumber)
        : widget.unitId.startsWith('b2-')
            ? B2CourseData.find(widget.unitId, widget.lessonNumber)
            : B1CourseData.find(widget.unitId, widget.lessonNumber);
    if (lesson == null) {
      return Scaffold(appBar: AppBar(title: const Text('درس B1')),
        body: const Center(child: Text('لم يتم العثور على محتوى الدرس.')));
    }
    final score = lesson.questions.asMap().entries
        .where((entry) => answers[entry.key] == entry.value.answer).length;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FC),
      appBar: AppBar(title: Text('${widget.unitId.startsWith("b2-") ? "B2" : "B1"} • الدرس ${lesson.globalNumber}'),
        backgroundColor: Colors.white, foregroundColor: AppColors.darkGreen, elevation: 0),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 30),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF102B52), Color(0xFF2676B8)]),
              borderRadius: BorderRadius.circular(22)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('LESSON ${lesson.globalNumber} • B1', textDirection: TextDirection.ltr,
                style: const TextStyle(color: Color(0xFFFFD98A), fontWeight: FontWeight.w900, fontSize: 11)),
              const SizedBox(height: 8),
              Text(lesson.title, textAlign: TextAlign.right,
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text(lesson.goal, textAlign: TextAlign.right,
                style: const TextStyle(color: Colors.white70, height: 1.7)),
            ]),
          ),
          const SizedBox(height: 13),
          _section('القاعدة والشرح', lesson.rule),
          _examples(lesson.examples),
          _section('محادثة تطبيقية', lesson.dialogue),
          _section('مهمة التحدث', lesson.speakingTask),
          const SizedBox(height: 10),
          Text('اختبر فهمك • ${lesson.questions.length} أسئلة',
            textAlign: TextAlign.right,
            style: const TextStyle(color: AppColors.darkGreen, fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          ...lesson.questions.asMap().entries.map((entry) {
            final index = entry.key;
            final q = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Text('السؤال ${index + 1}', textAlign: TextAlign.right,
                    style: const TextStyle(color: AppColors.green, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 7),
                  Text(q.prompt, textAlign: TextAlign.right,
                    style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w800, height: 1.6)),
                  const SizedBox(height: 6),
                  ...q.options.asMap().entries.map((option) {
                    final chosen = answers[index] == option.key;
                    final isCorrect = checked && option.key == q.answer;
                    return InkWell(
                      borderRadius: BorderRadius.circular(11),
                      onTap: checked ? null : () => setState(() => answers[index] = option.key),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          color: isCorrect ? const Color(0xFFE8F7EF) : chosen ? const Color(0xFFEAF2FF) : const Color(0xFFF7F9FC),
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(color: isCorrect ? const Color(0xFF279765) : chosen ? AppColors.navy : const Color(0xFFE7ECF3))),
                        child: Row(children: [
                          Icon(chosen ? Icons.radio_button_checked : Icons.radio_button_off,
                            color: chosen ? AppColors.navy : AppColors.muted, size: 18),
                          const SizedBox(width: 9),
                          Expanded(child: Text(option.value, textAlign: TextAlign.right,
                            style: const TextStyle(color: AppColors.darkGreen, fontSize: 12))),
                        ]),
                      ),
                    );
                  }),
                  if (checked) ...[
                    const SizedBox(height: 4),
                    Text(answers[index] == q.answer ? 'إجابة صحيحة ✓' : 'الإجابة الصحيحة: ${q.options[q.answer]}',
                      textAlign: TextAlign.right,
                      style: TextStyle(color: answers[index] == q.answer ? const Color(0xFF279765) : const Color(0xFFB45309), fontWeight: FontWeight.w800)),
                    Text(q.explanation, textAlign: TextAlign.right,
                      style: const TextStyle(color: AppColors.muted, height: 1.5, fontSize: 11)),
                  ],
                ]),
              ),
            );
          }),
          const SizedBox(height: 8),
          if (!checked)
            FilledButton.icon(
              onPressed: saving ? null : () => _submit(lesson),
              icon: saving ? const SizedBox(width:16,height:16,child:CircularProgressIndicator(strokeWidth:2,color:Colors.white)) : const Icon(Icons.check_circle_outline),
              label: const Text('تصحيح الاختبار وحفظ التقدم'),
              style: FilledButton.styleFrom(backgroundColor: AppColors.navy, padding: const EdgeInsets.symmetric(vertical: 14)),
            )
          else ...[
            Text('النتيجة: $score / ${lesson.questions.length}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w900, fontSize: 18)),
            OutlinedButton.icon(
              onPressed: () => setState(() { answers.clear(); checked = false; }),
              icon: const Icon(Icons.refresh_rounded), label: const Text('إعادة الاختبار'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _section(String title, String body) => Card(
    color: Colors.white, margin: const EdgeInsets.only(bottom: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
    child: Padding(padding: const EdgeInsets.all(15), child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(title, textAlign: TextAlign.right,
          style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w900, fontSize: 15)),
        const SizedBox(height: 7),
        Text(body, textAlign: TextAlign.right,
          style: const TextStyle(color: AppColors.muted, height: 1.8, fontSize: 12)),
      ])),
  );

  Widget _examples(List<String> examples) => Card(
    color: Colors.white, margin: const EdgeInsets.only(bottom: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
    child: Padding(padding: const EdgeInsets.all(15), child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('أمثلة تركية مع الترجمة', textAlign: TextAlign.right,
          style: TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w900, fontSize: 15)),
        const SizedBox(height: 8),
        ...examples.map((item) {
          final parts = item.split('|');
          return Padding(padding: const EdgeInsets.only(bottom: 9), child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(parts.first, textDirection: TextDirection.ltr, textAlign: TextAlign.left,
                style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w800, fontSize: 13)),
              const SizedBox(height: 3),
              Text(parts.length > 1 ? parts[1] : '', textAlign: TextAlign.right,
                style: const TextStyle(color: AppColors.muted, fontSize: 11)),
            ]));
        }),
      ])),
  );
}
