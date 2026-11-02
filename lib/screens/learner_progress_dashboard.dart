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
  String _timelineFilter = 'الكل';

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
      LearningProgress.quizHistory(limit: 100),
      LearningProgress.levelAssessmentHistory(limit: 100),
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
              _heading('شارات الإنجاز', 'تُفتح تلقائياً عند تحقيق شروط التعلم المحددة'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 9,
                runSpacing: 9,
                children: [
                  _achievementCard('البداية الأولى', 'إكمال الدروس', Icons.flag_rounded, _completed.length, [1, 10, 25], 'درس'),
                  _achievementCard('متعلم نشيط', 'الاستمرار في إكمال الدروس', Icons.local_fire_department_rounded, _completed.length, [10, 25, 50], 'دروس'),
                  _achievementCard('أول مفرداتك', 'إتقان المفردات', Icons.translate_rounded, _words, [5, 10, 25], 'كلمات'),
                  _achievementCard('رصيد لغوي', 'توسيع حصيلتك اللغوية', Icons.menu_book_rounded, _words, [10, 25, 50], 'كلمات'),
                  _achievementCard('خطوة الاختبار', 'إنهاء الاختبارات', Icons.quiz_rounded, _quizCount, [1, 5, 10], 'اختبار'),
                  _achievementCard('نتيجة متميزة', 'تحسين أفضل نتيجة اختبار', Icons.stars_rounded, _bestQuiz, [80, 90, 95], '%'),
                  _achievementCard('اجتياز A1', 'التقدم في تقييم A1', Icons.workspace_premium_rounded, _levelBest['A1'] ?? 0, [80, 90, 95], '%'),
                ],
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
                _quizPerformanceComparison(),
                const SizedBox(height: 12),
              ],
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
              if (_quizHistory.isNotEmpty || _levelHistory.isNotEmpty) ...[
                const SizedBox(height: 18),
                _heading('السجل الزمني للتعلم', 'آخر الاختبارات والتقييمات المسجلة على هذا الجهاز'),
                const SizedBox(height: 9),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 7,
                  children: ['الكل', 'اختبار', 'تقييم مستوى'].map((filter) => ChoiceChip(
                    label: Text(filter, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                    selected: _timelineFilter == filter,
                    onSelected: (_) => setState(() => _timelineFilter = filter),
                    selectedColor: const Color(0xFFDCEBFA),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: _timelineFilter == filter ? const Color(0xFF8AB9E2) : AppColors.border),
                    labelStyle: TextStyle(color: _timelineFilter == filter ? AppColors.navy : AppColors.muted),
                  )).toList(),
                ),
                const SizedBox(height: 8),
                if (_activityTimeline().isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text('لا توجد أنشطة من هذا النوع بعد.', textAlign: TextAlign.right,
                      style: TextStyle(color: AppColors.muted, fontSize: 11)),
                  )
                else
                  ..._activityTimeline().map(_activityTile),
              ],
              const SizedBox(height: 18),
              _heading('نشاطك خلال الفترة الأخيرة', 'إحصاءات محسوبة من تواريخ الاختبارات والتقييمات المسجلة فعلياً'),
              const SizedBox(height: 9),
              Row(children: [
                Expanded(child: _periodMetric('آخر 7 أيام', 7)),
                const SizedBox(width: 9),
                Expanded(child: _periodMetric('آخر 30 يوماً', 30)),
              ]),
              const SizedBox(height: 12),
              _weeklyActivityChart(),
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

  List<Map<String, dynamic>> _datedActivities() => [
    ..._quizHistory,
    ..._levelHistory,
  ];

  List<Map<String, dynamic>> _activitiesSince(int days) {
    final now = DateTime.now();
    final cutoff = now.subtract(Duration(days: days));
    return _datedActivities().where((item) {
      final date = DateTime.tryParse(item['completedAt']?.toString() ?? '');
      return date != null && !date.isBefore(cutoff) && !date.isAfter(now);
    }).toList();
  }

  Widget _weeklyActivityChart() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final days = List<DateTime>.generate(
      7, (index) => today.subtract(Duration(days: 6 - index)),
    );
    final events = _activitiesSince(7);
    final counts = days.map((day) => events.where((item) {
      final date = DateTime.tryParse(item['completedAt']?.toString() ?? '');
      return date != null &&
          date.year == day.year && date.month == day.month && date.day == day.day;
    }).length).toList();
    final maxCount = counts.fold<int>(0, (maxValue, value) =>
        value > maxValue ? value : maxValue);
    const labels = <String>['اث', 'ثل', 'أر', 'خم', 'جم', 'سب', 'أح'];
    return Container(
      padding: const EdgeInsets.fromLTRB(13, 12, 13, 10),
      decoration: _surface(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('توزيع النشاط اليومي', textAlign: TextAlign.right,
          style: TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w900, fontSize: 12)),
        const SizedBox(height: 12),
        SizedBox(
          height: 86,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              final count = counts[index];
              final barHeight = maxCount == 0 ? 5.0 : 8.0 + (count / maxCount) * 42.0;
              return Expanded(child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('$count', style: const TextStyle(
                    color: AppColors.muted, fontSize: 9, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Container(
                    height: barHeight,
                    width: 17,
                    decoration: BoxDecoration(
                      color: index == 6 ? AppColors.navy : const Color(0xFF78A9D8),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(labels[days[index].weekday - 1],
                    style: const TextStyle(color: AppColors.muted, fontSize: 8)),
                ],
              ));
            }),
          ),
        ),
        const SizedBox(height: 4),
        const Text('عدد الاختبارات والتقييمات المسجلة في كل يوم',
          textAlign: TextAlign.right,
          style: TextStyle(color: AppColors.muted, fontSize: 9)),
      ]),
    );
  }

  Widget _periodMetric(String label, int days) {
    final items = _activitiesSince(days);
    final average = items.isEmpty
        ? 0
        : (items.fold<int>(0, (sum, item) =>
            sum + ((item['percent'] as num?)?.toInt() ?? 0)) / items.length).round();
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: _surface(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(label, textAlign: TextAlign.right,
          style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w900, fontSize: 11)),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('${items.length}', style: const TextStyle(color: AppColors.navy, fontSize: 21, fontWeight: FontWeight.w900)),
            const Text('نشاط مسجل', style: TextStyle(color: AppColors.muted, fontSize: 9)),
          ])),
          Container(width: 1, height: 34, color: AppColors.border),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(items.isEmpty ? '—' : '$average%',
              style: const TextStyle(color: AppColors.navy, fontSize: 21, fontWeight: FontWeight.w900)),
            const Text('متوسط النتائج', style: TextStyle(color: AppColors.muted, fontSize: 9)),
          ])),
        ]),
      ]),
    );
  }

  Widget _quizPerformanceComparison() {
    final latest = _quizHistory.first;
    final best = _quizHistory.fold<Map<String, dynamic>>(
      _quizHistory.first,
      (currentBest, item) =>
          ((item['percent'] as num?)?.toInt() ?? 0) >
                  ((currentBest['percent'] as num?)?.toInt() ?? 0)
              ? item
              : currentBest,
    );
    final latestPercent = (latest['percent'] as num?)?.toInt() ?? 0;
    final bestPercent = (best['percent'] as num?)?.toInt() ?? 0;
    final difference = latestPercent - bestPercent;
    final differenceLabel = difference == 0
        ? 'تساوي أفضل نتيجة'
        : difference > 0
            ? 'أعلى من أفضل نتيجة محفوظة بـ $difference نقطة'
            : 'أقل من أفضل نتيجة بـ ${difference.abs()} نقطة';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _surface(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('مقارنة أداء الاختبارات',
            textAlign: TextAlign.right,
            style: TextStyle(color: AppColors.darkGreen,
              fontWeight: FontWeight.w900, fontSize: 13)),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _comparisonScore(
              'آخر نتيجة', latestPercent, const Color(0xFF4382B8))),
            const SizedBox(width: 9),
            Expanded(child: _comparisonScore(
              'أفضل نتيجة مسجلة', bestPercent, const Color(0xFF23866B))),
          ]),
          const SizedBox(height: 9),
          Text(differenceLabel,
            textAlign: TextAlign.right,
            style: const TextStyle(color: AppColors.muted,
              fontSize: 10, fontWeight: FontWeight.w700)),
          const SizedBox(height: 5),
          const Text(
            'المقارنة مبنية على سجل الاختبارات المحفوظ، ولا تشمل تقييمات المستويات.',
            textAlign: TextAlign.right,
            style: TextStyle(color: AppColors.muted, fontSize: 9, height: 1.5)),
        ],
      ),
    );
  }

  Widget _comparisonScore(String label, int percent, Color color) =>
      Container(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 9),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(children: [
          Text('$percent%',
            style: TextStyle(color: color, fontSize: 23,
              fontWeight: FontWeight.w900)),
          const SizedBox(height: 3),
          Text(label, textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted, fontSize: 9)),
        ]),
      );

  Widget _achievementCard(
    String title, String description, IconData icon,
    int current, List<int> thresholds, String unit,
  ) {
    final earnedLevels = thresholds.where((threshold) => current >= threshold).length;
    final nextIndex = earnedLevels;
    final complete = earnedLevels == thresholds.length;
    final nextTarget = complete ? thresholds.last : thresholds[nextIndex];
    final previousTarget = nextIndex == 0 ? 0 : thresholds[nextIndex - 1];
    final progress = complete
        ? 1.0
        : ((current - previousTarget) / (nextTarget - previousTarget))
            .clamp(0.0, 1.0).toDouble();
    final tier = earnedLevels == 0
        ? 'لم تُفتح بعد'
        : earnedLevels == 1
            ? 'برونزية'
            : earnedLevels == 2
                ? 'فضية'
                : 'ذهبية';
    final shown = current < nextTarget ? current : nextTarget;
    return SizedBox(
      width: (MediaQuery.sizeOf(context).width - 43) / 2,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: earnedLevels > 0 ? const Color(0xFFFFF7E7) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: earnedLevels > 0 ? const Color(0xFFE8C77D) : AppColors.border,
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Icon(icon, color: earnedLevels > 0 ? const Color(0xFFB7791F) : AppColors.muted, size: 25),
            const SizedBox(width: 8),
            Expanded(child: Text(title, textAlign: TextAlign.right,
              style: TextStyle(
                color: earnedLevels > 0 ? AppColors.darkGreen : AppColors.muted,
                fontSize: 11, fontWeight: FontWeight.w900,
              ))),
          ]),
          const SizedBox(height: 7),
          Text(complete ? 'اكتملت جميع المستويات · ذهبية' : '$description · $tier',
            textAlign: TextAlign.right,
            style: const TextStyle(color: AppColors.muted, fontSize: 9, height: 1.4)),
          const SizedBox(height: 7),
          ClipRRect(borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress, minHeight: 5,
              backgroundColor: const Color(0xFFE9EEF6),
              color: complete ? const Color(0xFFB7791F) : const Color(0xFF2E82C7),
            )),
          const SizedBox(height: 4),
          Text(
            complete ? '$current $unit · اكتمل الهدف' : '$shown من $nextTarget $unit للوصول للمستوى التالي',
            textAlign: TextAlign.right,
            style: const TextStyle(color: AppColors.muted, fontSize: 9),
          ),
        ]),
      ),
    );
  }

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

  List<Map<String, dynamic>> _activityTimeline() {
    final events = <Map<String, dynamic>>[
      ..._quizHistory.map((item) => <String, dynamic>{
        ...item,
        'eventTitle': item['source'] ?? 'الاختبار الشامل',
        'eventType': 'اختبار',
      }),
      ..._levelHistory.map((item) => <String, dynamic>{
        ...item,
        'eventTitle': 'تقييم المستوى ${item['level'] ?? '—'}',
        'eventType': 'تقييم مستوى',
      }),
    ];
    if (_timelineFilter != 'الكل') {
      events.removeWhere((event) => event['eventType'] != _timelineFilter);
    }
    events.sort((a, b) {
      final aDate = DateTime.tryParse(a['completedAt']?.toString() ?? '') ?? DateTime(2000);
      final bDate = DateTime.tryParse(b['completedAt']?.toString() ?? '') ?? DateTime(2000);
      return bDate.compareTo(aDate);
    });
    return events.take(8).toList();
  }

  void _showActivityDetails(Map<String, dynamic> item) {
    final date = DateTime.tryParse(item['completedAt']?.toString() ?? '');
    final score = (item['score'] as num?)?.toInt() ?? 0;
    final total = (item['total'] as num?)?.toInt() ?? 0;
    final percent = (item['percent'] as num?)?.toInt() ?? 0;
    final isQuiz = item['eventType'] == 'اختبار';
    final dateLabel = date == null
        ? 'تاريخ غير متاح'
        : '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')} · ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('${item['eventTitle']}', textAlign: TextAlign.right,
          style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w900)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Text('$percent%',
              style: const TextStyle(color: AppColors.navy, fontSize: 34, fontWeight: FontWeight.w900))),
            const SizedBox(height: 12),
            _detailRow('نوع النشاط', isQuiz ? 'اختبار شامل' : 'تقييم مستوى'),
            _detailRow('النتيجة', total > 0 ? '$score من $total' : 'غير متاحة'),
            _detailRow('النسبة', '$percent%'),
            _detailRow('التاريخ والوقت', dateLabel),
            if (item['level'] != null) _detailRow('المستوى', '${item['level']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(children: [
      Expanded(child: Text(value, textAlign: TextAlign.left,
        style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w700, fontSize: 11))),
      const SizedBox(width: 10),
      Text(label, textAlign: TextAlign.right,
        style: const TextStyle(color: AppColors.muted, fontSize: 11)),
    ]),
  );

  Widget _activityTile(Map<String, dynamic> item) {
    final date = DateTime.tryParse(item['completedAt']?.toString() ?? '');
    final dateLabel = date == null
        ? 'تاريخ غير متاح'
        : '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')} · ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    final percent = (item['percent'] as num?)?.toInt() ?? 0;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showActivityDetails(item),
        child: Container(
          margin: const EdgeInsets.only(bottom: 7),
          padding: const EdgeInsets.all(12),
          decoration: _surface(),
          child: Row(children: [
            Container(
              width: 34, height: 34,
              decoration: BoxDecoration(color: const Color(0xFFEAF2FF), borderRadius: BorderRadius.circular(10)),
              child: Icon(item['eventType'] == 'اختبار' ? Icons.quiz_rounded : Icons.assessment_rounded,
                color: AppColors.navy, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('${item['eventTitle']}', textAlign: TextAlign.right,
                style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w900, fontSize: 11)),
              Text(dateLabel, textAlign: TextAlign.right,
                style: const TextStyle(color: AppColors.muted, fontSize: 9)),
              const Text('اضغط لعرض تفاصيل النشاط', textAlign: TextAlign.right,
                style: TextStyle(color: Color(0xFF4382B8), fontSize: 9)),
            ])),
            const SizedBox(width: 8),
            Text('$percent%', style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w900)),
          ]),
        ),
      ),
    );
  }

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
