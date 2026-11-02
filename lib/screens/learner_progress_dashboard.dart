import 'package:flutter/material.dart';

import '../data/course_catalog.dart';
import '../services/learning_progress.dart';
import '../theme/app_theme.dart';

class LearnerProgressDashboard extends StatefulWidget {
  const LearnerProgressDashboard({super.key});

  @override
  State<LearnerProgressDashboard> createState() => _LearnerProgressDashboardState();
}

class _LearnerProgressDashboardState extends State<LearnerProgressDashboard> {
  bool _loading = true;
  Set<String> _completed = <String>{};
  int _words = 0;
  int _bestQuiz = 0;
  int _quizCount = 0;
  int _mistakes = 0;
  List<Map<String, dynamic>> _quizHistory = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _levelHistory = <Map<String, dynamic>>[];
  Map<String, int> _levelBest = <String, int>{};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final values = await Future.wait([
      LearningProgress.completedLessons(),
      LearningProgress.learnedWords(),
      LearningProgress.bestQuizScore(),
      LearningProgress.quizCount(),
      LearningProgress.missedQuestionDetails(),
      LearningProgress.quizHistory(limit: 6),
      LearningProgress.levelAssessmentHistory(limit: 6),
      ...CourseCatalog.levels.map(LearningProgress.levelAssessmentBest),
    ]);
    if (!mounted) return;
    setState(() {
      _completed = values[0] as Set<String>;
      _words = (values[1] as Set<String>).length;
      _bestQuiz = values[2] as int;
      _quizCount = values[3] as int;
      _mistakes = (values[4] as List).length;
      _quizHistory = values[5] as List<Map<String, dynamic>>;
      _levelHistory = values[6] as List<Map<String, dynamic>>;
      _levelBest = {
        for (var i = 0; i < CourseCatalog.levels.length; i++)
          CourseCatalog.levels[i]: values[7 + i] as int,
      };
      _loading = false;
    });
  }

  int _completedForLevel(String level) => CourseCatalog.units
      .where((unit) => unit.level == level)
      .fold<int>(0, (sum, unit) => sum + unit.lessons.asMap().entries
          .where((entry) => _completed.contains('${unit.id}-${entry.key + 1}')).length);

  int _totalForLevel(String level) => CourseCatalog.units
      .where((unit) => unit.level == level)
      .fold<int>(0, (sum, unit) => sum + unit.lessonCount);

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF5F7FC),
    appBar: AppBar(
      title: const Text('لوحة تقدم المتعلم', style: TextStyle(fontWeight: FontWeight.w900)),
      backgroundColor: const Color(0xFFF5F7FC),
      foregroundColor: AppColors.darkGreen,
      elevation: 0,
    ),
    body: _loading
      ? const Center(child: CircularProgressIndicator())
      : RefreshIndicator(
          onRefresh: _load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(17, 8, 17, 28),
            children: [
              Container(
                padding: const EdgeInsets.all(19),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft,
                    colors: [Color(0xFF102B52), Color(0xFF2676B8)]),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  const Text('ملخص رحلتك التعليمية', textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 6),
                  const Text('الأرقام التالية مأخوذة من سجل التعلم المحلي على هذا الجهاز.',
                    textAlign: TextAlign.right, style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.5)),
                  const SizedBox(height: 16),
                  Row(children: [
                    _heroMetric('${_completed.length}', 'درس مكتمل'),
                    _heroMetric('$_words', 'كلمة متقنة'),
                    _heroMetric('$_bestQuiz%', 'أفضل اختبار'),
                  ]),
                ]),
              ),
              const SizedBox(height: 20),
              _heading('تقدم المستويات', 'عدد الدروس المكتملة من إجمالي الدروس الموجودة في المنهج'),
              const SizedBox(height: 10),
              ...CourseCatalog.levels.map((level) {
                final done = _completedForLevel(level);
                final total = _totalForLevel(level);
                final percent = total == 0 ? 0 : (done * 100 ~/ total);
                final best = _levelBest[level] ?? 0;
                return Container(
                  margin: const EdgeInsets.only(bottom: 9),
                  padding: const EdgeInsets.all(14),
                  decoration: _surface(),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Row(children: [
                      Container(width: 43, height: 37, alignment: Alignment.center,
                        decoration: BoxDecoration(color: const Color(0xFFEAF2FF), borderRadius: BorderRadius.circular(10)),
                        child: Text(level, style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w900))),
                      const SizedBox(width: 10),
                      Expanded(child: Text('$done من $total درس', textAlign: TextAlign.right,
                        style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w800, fontSize: 12))),
                      Text('$percent%', style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w900)),
                    ]),
                    const SizedBox(height: 10),
                    ClipRRect(borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(value: total == 0 ? 0 : done / total, minHeight: 8,
                        backgroundColor: const Color(0xFFE9EEF6), color: const Color(0xFF2E82C7))),
                    const SizedBox(height: 8),
                    Text(best == 0 ? 'لم يُسجّل تقييم لهذا المستوى بعد' : 'أفضل نتيجة تقييم: $best%',
                      textAlign: TextAlign.right, style: const TextStyle(color: AppColors.muted, fontSize: 10)),
                  ]),
                );
              }),
              const SizedBox(height: 12),
              _heading('الاختبارات والمراجعة', 'ملخص المحاولات وسجل الأخطاء'),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: _smallMetric('$_quizCount', 'اختبارات مكتملة', Icons.quiz_rounded)),
                const SizedBox(width: 8),
                Expanded(child: _smallMetric('$_mistakes', 'أسئلة في سجل الأخطاء', Icons.fact_check_rounded)),
              ]),
              const SizedBox(height: 8),
              if (_quizHistory.isNotEmpty) ...[
                const SizedBox(height: 7),
                const Text('آخر نتائج الاختبار الشامل', textAlign: TextAlign.right,
                  style: TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w900, fontSize: 13)),
                const SizedBox(height: 8),
                ..._quizHistory.map((item) => _historyTile(
                  '${item['source'] ?? 'الاختبار الشامل'}',
                  '${item['score'] ?? 0} من ${item['total'] ?? 0}',
                  (item['percent'] as num?)?.toInt() ?? 0,
                  item['completedAt']?.toString(),
                )),
              ],
              if (_levelHistory.isNotEmpty) ...[
                const SizedBox(height: 13),
                const Text('آخر تقييمات المستويات', textAlign: TextAlign.right,
                  style: TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w900, fontSize: 13)),
                const SizedBox(height: 8),
                ..._levelHistory.map((item) => _historyTile(
                  'تقييم ${item['level'] ?? '—'}',
                  '${item['score'] ?? 0} من ${item['total'] ?? 0}',
                  (item['percent'] as num?)?.toInt() ?? 0,
                  item['completedAt']?.toString(),
                )),
              ],
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(color: const Color(0xFFFFF6E8), borderRadius: BorderRadius.circular(15)),
                child: const Text(
                  'ملاحظة: تقدم الدروس يُحسب من الدروس التي وُضعت علامة إكمال لها، وليس من مجرد فتحها. وسجل الأخطاء يحصي الأسئلة المحفوظة المختلفة، لا عدد مرات الإجابة الخاطئة.',
                  textAlign: TextAlign.right,
                  style: TextStyle(color: AppColors.darkGreen, fontSize: 11, height: 1.6),
                ),
              ),
            ],
          ),
        ),
  );

  Widget _heading(String title, String subtitle) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
    Text(title, textAlign: TextAlign.right,
      style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w900, fontSize: 16)),
    const SizedBox(height: 4),
    Text(subtitle, textAlign: TextAlign.right,
      style: const TextStyle(color: AppColors.muted, fontSize: 10, height: 1.5)),
  ]);

  Widget _heroMetric(String value, String label) => Expanded(child: Column(children: [
    Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
    const SizedBox(height: 3),
    Text(label, style: const TextStyle(color: Colors.white70, fontSize: 9)),
  ]));

  Widget _smallMetric(String value, String label, IconData icon) => Container(
    padding: const EdgeInsets.all(14),
    decoration: _surface(),
    child: Row(children: [
      Icon(icon, color: AppColors.navy, size: 20),
      const SizedBox(width: 8),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(value, style: const TextStyle(color: AppColors.darkGreen, fontSize: 18, fontWeight: FontWeight.w900)),
        Text(label, textAlign: TextAlign.right, style: const TextStyle(color: AppColors.muted, fontSize: 9)),
      ])),
    ]),
  );

  Widget _historyTile(String title, String score, int percent, String? timestamp) {
    final date = DateTime.tryParse(timestamp ?? '');
    final dateLabel = date == null ? 'تاريخ غير متاح' :
      '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: _surface(),
      child: Row(children: [
        Text('$percent%', style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w900)),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('$title · $score', textAlign: TextAlign.right,
            style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w800, fontSize: 11)),
          Text(dateLabel, style: const TextStyle(color: AppColors.muted, fontSize: 9)),
        ])),
      ]),
    );
  }

  BoxDecoration _surface() => BoxDecoration(
    color: Colors.white, borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.border),
  );
}
