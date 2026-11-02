import 'package:flutter/material.dart';

import '../services/learning_progress.dart';
import '../theme/app_theme.dart';
import 'course_lesson_screen.dart';

class MissedQuestionsScreen extends StatefulWidget {
  const MissedQuestionsScreen({super.key});

  @override
  State<MissedQuestionsScreen> createState() => _MissedQuestionsScreenState();
}

class _MissedQuestionsScreenState extends State<MissedQuestionsScreen> {
  List<Map<String, dynamic>> _items = <Map<String, dynamic>>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final items = await LearningProgress.missedQuestionDetails();
    if (!mounted) return;
    setState(() { _items = items.reversed.toList(); _loading = false; });
  }

  Future<void> _clear() async {
    await LearningProgress.clearMissedQuestions();
    if (mounted) setState(() => _items = <Map<String, dynamic>>[]);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF5F7FC),
    appBar: AppBar(
      title: const Text('مراجعة أخطائي', style: TextStyle(fontWeight: FontWeight.w900)),
      backgroundColor: const Color(0xFFF5F7FC),
      foregroundColor: AppColors.darkGreen,
      elevation: 0,
      actions: [
        if (_items.isNotEmpty)
          IconButton(onPressed: _clear, tooltip: 'مسح سجل المراجعة',
            icon: const Icon(Icons.delete_outline_rounded)),
      ],
    ),
    body: _loading
      ? const Center(child: CircularProgressIndicator())
      : _items.isEmpty
        ? const Center(child: Padding(
            padding: EdgeInsets.all(28),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.check_circle_outline_rounded, color: Color(0xFF2E9B70), size: 54),
              SizedBox(height: 12),
              Text('لا توجد أخطاء محفوظة', style: TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w900, fontSize: 18)),
              SizedBox(height: 6),
              Text('عندما تخطئ في سؤال، سيظهر هنا مع الإجابة الصحيحة والشرح.', textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.muted, height: 1.6)),
            ]),
          ))
        : ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            itemCount: _items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = _items[index];
              final unitId = item['unitId']?.toString();
              final lessonNumber = item['lessonNumber'] is int ? item['lessonNumber'] as int : null;
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(19),
                  border: Border.all(color: AppColors.border)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Text(item['prompt']?.toString() ?? '', textAlign: TextAlign.right,
                    style: const TextStyle(color: AppColors.darkGreen, fontSize: 14, fontWeight: FontWeight.w900, height: 1.5)),
                  const SizedBox(height: 11),
                  _answerLine('إجابتك', item['selectedAnswer']?.toString() ?? '—', const Color(0xFFB33B3B)),
                  const SizedBox(height: 6),
                  _answerLine('الصحيح', item['correctAnswer']?.toString() ?? '—', const Color(0xFF21845B)),
                  const SizedBox(height: 10),
                  Text(item['explanation']?.toString() ?? '', textAlign: TextAlign.right,
                    style: const TextStyle(color: AppColors.navy, fontSize: 12, height: 1.7)),
                  const SizedBox(height: 10),
                  Container(padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: const Color(0xFFEAF2FF), borderRadius: BorderRadius.circular(12)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      Text('المصدر: ${item['source'] ?? 'اختبار سابق'}',\n                        style: const TextStyle(color: AppColors.muted, fontSize: 10)),\n                      const SizedBox(height: 4),\n                      Text('الموضوع: ${item['topic'] ?? 'مراجعة عامة'}',
                        style: const TextStyle(color: AppColors.navy, fontSize: 11, fontWeight: FontWeight.w800)),
                      if (item['lessonTitle'] != null) ...[
                        const SizedBox(height: 4),
                        Text('الدرس المرتبط: ${item['lessonTitle']}',
                          style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                      ],
                    ]),
                  ),
                  if (unitId != null && lessonNumber != null)
                    Align(alignment: Alignment.centerLeft, child: TextButton.icon(
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (_) => CourseLessonScreen(
                          unitId: unitId,
                          unitTitle: _unitTitle(unitId),
                          lessonTitle: item['lessonTitle']?.toString() ?? 'الدرس المرتبط',
                          lessonNumber: lessonNumber,
                        ),
                      )),
                      icon: const Icon(Icons.menu_book_rounded, size: 18),
                      label: const Text('افتح الدرس للمراجعة'),
                    )),
                ]),
              );
            },
          ),
  );

  Widget _answerLine(String label, String value, Color color) => Row(children: [
    Text('$label: ', style: const TextStyle(color: AppColors.muted, fontSize: 11)),
    Expanded(child: Text(value, textAlign: TextAlign.right,
      style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w800))),
  ]);

  String _unitTitle(String id) {
    switch (id) {
      case 'a1-u1': return 'الأبجدية والأصوات التركية';
      case 'a1-u3': return 'الأشياء والأدوات والألوان';
      default: return 'التحيات والتعارف';
    }
  }
}
