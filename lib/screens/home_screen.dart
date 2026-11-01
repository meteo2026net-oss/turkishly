import 'package:flutter/material.dart';

import '../data/course_catalog.dart';
import '../models/course_unit.dart';
import 'course_lesson_screen.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final units = CourseCatalog.units;
    final completed = units.where((unit) => unit.isCompleted).length;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: AppColors.gold, width: 1.5),
              ),
              child: const Icon(Icons.local_florist_rounded,
                  color: AppColors.red, size: 25),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('ساره تركيي',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
                Text('SARA TURKII',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(fontSize: 9, letterSpacing: 1.5, fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [AppColors.navy, Color(0xFF164D91)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Merhaba!  •  أهلاً بك',
                      textDirection: TextDirection.ltr,
                      style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 10),
                  const Text('رحلتك مع ساره تركيي لتعلّم التركية',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  const Text(
                    'منهج İstanbul مع شرح عربي وتدريبات تفاعلية ومحادثات تساعدك على التقدم بثقة.',
                    style: TextStyle(color: Colors.white, height: 1.6),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    completed.toString() + ' وحدات مكتملة تعليمياً',
                    style: const TextStyle(
                        color: AppColors.gold, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            const Text('مسارك التعليمي',
                style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: 21,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: CourseCatalog.levels
                  .map((level) => Chip(
                        label: Text(level),
                        backgroundColor: level == 'A1'
                            ? AppColors.softGreen
                            : AppColors.white,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 12),
            ...units.map((unit) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _UnitCard(unit: unit),
                )),
          ],
        ),
      ),
    );
  }
}

class _UnitCard extends StatelessWidget {
  const _UnitCard({required this.unit});
  final CourseUnit unit;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (_) => _UnitDetails(unit: unit),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              const Icon(Icons.menu_book_outlined,
                  color: AppColors.navy, size: 30),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(unit.titleArabic,
                        style: const TextStyle(
                            color: AppColors.darkGreen,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(unit.titleTurkish,
                        textDirection: TextDirection.ltr,
                        style: const TextStyle(
                            color: AppColors.muted, fontSize: 12)),
                    const SizedBox(height: 6),
                    Text(
                      unit.lessonCount.toString() + ' دروس • ' + unit.level,
                      style: const TextStyle(
                          color: AppColors.muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_left, color: AppColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnitDetails extends StatelessWidget {
  const _UnitDetails({required this.unit});
  final CourseUnit unit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.78,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(unit.titleArabic,
                      style: const TextStyle(
                          color: AppColors.darkGreen,
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 5),
                  Text(unit.titleTurkish,
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(color: AppColors.green)),
                  const SizedBox(height: 8),
                  Text(unit.description),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: unit.lessons.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: AppColors.softGreen,
                    child: Text((index + 1).toString()),
                  ),
                  title: Text(unit.lessons[index]),
                  trailing: const Icon(Icons.arrow_back_ios_new, size: 15),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => CourseLessonScreen(
                          unitId: unit.id,
                          unitTitle: unit.titleArabic,
                          lessonTitle: unit.lessons[index],
                          lessonNumber: index + 1,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
