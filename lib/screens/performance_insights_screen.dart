import 'package:flutter/material.dart';

import '../services/learning_progress.dart';
import '../theme/app_theme.dart';
import 'missed_questions_screen.dart';

class PerformanceInsightsScreen extends StatefulWidget {
  const PerformanceInsightsScreen({super.key});

  @override
  State<PerformanceInsightsScreen> createState() => _PerformanceInsightsScreenState();
}

class _PerformanceInsightsScreenState extends State<PerformanceInsightsScreen> {
  bool _loading = true;
  List<MapEntry<String, int>> _topics = <MapEntry<String, int>>[];
  List<MapEntry<String, int>> _sources = <MapEntry<String, int>>[];
  int _total = 0;
  int _quizBest = 0;
  int _quizCount = 0;
  List<Map<String, dynamic>> _history = <Map<String, dynamic>>[];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final values = await Future.wait([
      LearningProgress.missedQuestionDetails(),
      LearningProgress.bestQuizScore(),
      LearningProgress.quizCount(),
      LearningProgress.quizHistory(limit: 12),
    ]);
    final details = values[0] as List<Map<String, dynamic>>;
    final counts = <String, int>{};
    final sourceCounts = <String, int>{};
    for (final item in details) {
      final topic = item['topic']?.toString().trim();
      final key = topic == null || topic.isEmpty ? 'غير مصنف' : topic;
      counts[key] = (counts[key] ?? 0) + 1;
      final source = item['source']?.toString().trim();
      final sourceKey = source == null || source.isEmpty ? 'مصدر غير محدد' : source;
      sourceCounts[sourceKey] = (sourceCounts[sourceKey] ?? 0) + 1;
    }
    final topics = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final sources = sourceCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    if (!mounted) return;
    setState(() {
      _topics = topics;
      _sources = sources;
      _total = details.length;
      _quizBest = values[1] as int;
      _quizCount = values[2] as int;
      _history = values[3] as List<Map<String, dynamic>>;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF5F7FC),
    appBar: AppBar(
      title: const Text('تحليل الأداء', style: TextStyle(fontWeight: FontWeight.w900)),
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
              Row(children: [
                Expanded(child: _metric('أفضل نتيجة', '$_quizBest%', Icons.emoji_events_rounded)),
                const SizedBox(width: 9),
                Expanded(child: _metric('الاختبارات', '$_quizCount', Icons.quiz_rounded)),
                const SizedBox(width: 9),
                Expanded(child: _metric('أسئلة الأخطاء', '$_total', Icons.fact_check_rounded)),
              ]),
              const SizedBox(height: 18),
              _section(
                icon: Icons.show_chart_rounded,
                title: 'سجل المحاولات الأخيرة',
                subtitle: 'كل محاولة مكتملة تُسجّل بتاريخها ونتيجتها، بحد أقصى 100 محاولة على هذا الجهاز.',
              ),
              const SizedBox(height: 10),
              if (_history.isEmpty)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: _surface(),
                  child: const Text('ستظهر نتائجك هنا بعد إكمال الاختبار الشامل.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.muted, fontSize: 12)),
                )
              else ...[
                Container(
                  height: 150,
                  padding: const EdgeInsets.fromLTRB(10, 14, 10, 8),
                  decoration: _surface(),
                  child: CustomPaint(
                    painter: _AttemptChartPainter(_history.map((item) => (item['percent'] as num?)?.toDouble() ?? 0).toList().reversed.toList()),
                    child: const SizedBox.expand(),
                  ),
                ),
                const SizedBox(height: 9),
                ..._history.take(8).map((attempt) {
                  final score = (attempt['score'] as num?)?.toInt() ?? 0;
                  final total = (attempt['total'] as num?)?.toInt() ?? 0;
                  final percent = (attempt['percent'] as num?)?.toInt() ?? 0;
                  final rawDate = DateTime.tryParse(attempt['completedAt']?.toString() ?? '');
                  final date = rawDate == null ? 'تاريخ غير متاح' : '${rawDate.year}/${rawDate.month.toString().padLeft(2, '0')}/${rawDate.day.toString().padLeft(2, '0')}  ${rawDate.hour.toString().padLeft(2, '0')}:${rawDate.minute.toString().padLeft(2, '0')}';
                  return Container(
                    margin: const EdgeInsets.only(bottom: 7),
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
                    decoration: _surface(),
                    child: Row(children: [
                      Container(width: 48, height: 40, alignment: Alignment.center,
                        decoration: BoxDecoration(color: const Color(0xFFEAF2FF), borderRadius: BorderRadius.circular(10)),
                        child: Text('$percent%', style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w900))),
                      const SizedBox(width: 10),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text('${attempt['source'] ?? 'اختبار'} · $score من $total',
                          textAlign: TextAlign.right,
                          style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w800, fontSize: 12)),
                        const SizedBox(height: 3),
                        Text(date, style: const TextStyle(color: AppColors.muted, fontSize: 10)),
                      ])),
                    ]),
                  );
                }),
              ],
              const SizedBox(height: 18),
              _section(
                icon: Icons.track_changes_rounded,
                title: 'الموضوعات التي تحتاج مراجعة',
                subtitle: 'ترتيب تنازلي حسب عدد الأسئلة المختلفة المحفوظة كأخطاء.',
              ),
              const SizedBox(height: 10),
              if (_topics.isEmpty)
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: _surface(),
                  child: const Column(children: [
                    Icon(Icons.stars_rounded, color: Color(0xFF2E9B70), size: 42),
                    SizedBox(height: 9),
                    Text('لا توجد أخطاء محفوظة حالياً', style: TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w900)),
                    SizedBox(height: 5),
                    Text('أكمل الاختبارات، وستظهر هنا الموضوعات التي تحتاج إلى مراجعة.', textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.muted, height: 1.6, fontSize: 12)),
                  ]),
                )
              else
                ..._topics.asMap().entries.map((entry) {
                  final rank = entry.key + 1;
                  final topic = entry.value;
                  final fraction = _total == 0 ? 0.0 : topic.value / _total;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    padding: const EdgeInsets.all(14),
                    decoration: _surface(),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      Row(children: [
                        Container(width: 29, height: 29, alignment: Alignment.center,
                          decoration: BoxDecoration(color: const Color(0xFFEAF2FF), borderRadius: BorderRadius.circular(9)),
                          child: Text('$rank', style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w900))),
                        const SizedBox(width: 9),
                        Expanded(child: Text(topic.key, textAlign: TextAlign.right,
                          style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w900, fontSize: 13))),
                        Text('${topic.value} سؤال', style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                      ]),
                      const SizedBox(height: 11),
                      ClipRRect(borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(value: fraction, minHeight: 8,
                          backgroundColor: const Color(0xFFE9EEF6), color: const Color(0xFF2E82C7))),
                      const SizedBox(height: 5),
                      Text('${(fraction * 100).round()}% من سجل الأخطاء', textAlign: TextAlign.left,
                        style: const TextStyle(color: AppColors.muted, fontSize: 10)),
                    ]),
                  );
                }),
              const SizedBox(height: 18),
              _section(
                icon: Icons.source_rounded,
                title: 'مصادر الأخطاء',
                subtitle: 'توزيع الأسئلة المحفوظة بحسب الاختبار أو تقييم المستوى.',
              ),
              const SizedBox(height: 10),
              if (_sources.isEmpty)
                _emptySourceCard()
              else
                ..._sources.map((source) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: _surface(),
                  child: Row(children: [
                    Expanded(child: Text(source.key, textAlign: TextAlign.right,
                      style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w800, fontSize: 12))),
                    Text('${source.value} سؤال', style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w900, fontSize: 12)),
                  ]),
                )),
              if (_topics.isNotEmpty) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: const Color(0xFFFFF6E8), borderRadius: BorderRadius.circular(15)),
                  child: Row(children: [
                    const Icon(Icons.priority_high_rounded, color: Color(0xFFB7791F)),
                    const SizedBox(width: 9),
                    Expanded(child: Text('الأولوية الحالية: ${_topics.first.key} (${_topics.first.value} سؤال)',
                      textAlign: TextAlign.right,
                      style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w800, fontSize: 12))),
                  ]),
                ),
              ],
              const SizedBox(height: 12),
              Material(
                color: const Color(0xFFEAF2FF),
                borderRadius: BorderRadius.circular(15),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () async {
                    await Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (_) => const MissedQuestionsScreen(),
                    ));
                    _load();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Row(children: [
                      Icon(Icons.fact_check_rounded, color: AppColors.navy),
                      SizedBox(width: 9),
                      Expanded(child: Text('فتح سجل مراجعة الأخطاء',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.w900, fontSize: 12))),
                      Icon(Icons.chevron_left_rounded, color: AppColors.navy),
                    ]),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFFEAF2FF), borderRadius: BorderRadius.circular(16)),
                child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(Icons.info_outline_rounded, color: AppColors.navy),
                  SizedBox(width: 9),
                  Expanded(child: Text(
                    'هذه قراءة لسجل الأسئلة الخاطئة المحفوظة، وليست نسبة إتقان علمية لكل موضوع. يُحفظ السؤال مرة واحدة في السجل حتى لا تتضخم الأعداد بتكرار المحاولة.',
                    textAlign: TextAlign.right,
                    style: TextStyle(color: AppColors.navy, fontSize: 11, height: 1.6),
                  )),
                ]),
              ),
            ],
          ),
        ),
  );

  Widget _emptySourceCard() => Container(
    padding: const EdgeInsets.all(16),
    decoration: _surface(),
    child: const Text('لا توجد بيانات مصادر بعد.', textAlign: TextAlign.center,
      style: TextStyle(color: AppColors.muted, fontSize: 11)),
  );

  BoxDecoration _surface() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(17),
    border: Border.all(color: AppColors.border),
  );

  Widget _metric(String label, String value, IconData icon) => Container(
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 7),
    decoration: _surface(),
    child: Column(children: [
      Icon(icon, color: AppColors.navy, size: 20),
      const SizedBox(height: 7),
      Text(value, style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w900, fontSize: 18)),
      const SizedBox(height: 3),
      Text(label, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.muted, fontSize: 9)),
    ]),
  );

  Widget _section({required IconData icon, required String title, required String subtitle}) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(children: [
        Icon(icon, color: AppColors.navy, size: 21),
        const SizedBox(width: 7),
        Expanded(child: Text(title, textAlign: TextAlign.right,
          style: const TextStyle(color: AppColors.darkGreen, fontSize: 16, fontWeight: FontWeight.w900))),
      ]),
      const SizedBox(height: 4),
      Text(subtitle, textAlign: TextAlign.right,
        style: const TextStyle(color: AppColors.muted, fontSize: 11, height: 1.5)),
    ],
  );
}


class _AttemptChartPainter extends CustomPainter {
  _AttemptChartPainter(this.values);
  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final grid = Paint()..color = const Color(0xFFE9EEF6)..strokeWidth = 1;
    final line = Paint()..color = const Color(0xFF2E82C7)..strokeWidth = 2.8..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final dot = Paint()..color = const Color(0xFF2E82C7);
    for (var i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    final points = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      final x = values.length == 1 ? size.width / 2 : size.width * i / (values.length - 1);
      final y = size.height * (1 - values[i].clamp(0, 100) / 100);
      points.add(Offset(x, y));
    }
    if (points.length == 1) {
      canvas.drawCircle(points.first, 4, dot);
    } else {
      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (final point in points.skip(1)) { path.lineTo(point.dx, point.dy); }
      canvas.drawPath(path, line);
      for (final point in points) { canvas.drawCircle(point, 3.5, dot); }
    }
  }

  @override
  bool shouldRepaint(covariant _AttemptChartPainter oldDelegate) => oldDelegate.values != values;
}
