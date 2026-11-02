import 'package:flutter_test/flutter_test.dart';
import 'package:turkishly/data/c2_course_data.dart';
import 'package:turkishly/data/course_catalog.dart';
void main(){
 group('C2 final lessons 931-1200',(){
  final batch=C2CourseData.lessons.where((e)=>e.globalNumber>=931&&e.globalNumber<=1200).toList();
  test('all 270 final lessons are present exactly once',(){
   expect(batch,hasLength(270));
   expect(batch.map((e)=>e.globalNumber).toSet(),Set<int>.from(List<int>.generate(270,(i)=>931+i)));
   expect(C2CourseData.lessons,hasLength(780));
  });
  test('units 52-78 each contain ten aligned lessons',(){
   for(var n=52;n<=78;n++){
    final id='c2-u$n';final unit=CourseCatalog.units.firstWhere((e)=>e.id==id);
    expect(unit.lessons,hasLength(10));
    for(var i=1;i<=10;i++){
     final lesson=C2CourseData.find(id,i);
     expect(lesson,isNotNull,reason:'$id lesson $i');
     expect(lesson!.globalNumber,920+(n-51)*10+i);
     expect(lesson.title,unit.lessons[i-1]);
    }
   }
  });
  test('every final lesson has five complete four-option questions',(){
   for(final lesson in batch){
    expect(lesson.goal,isNotEmpty);expect(lesson.rule,isNotEmpty);expect(lesson.examples,hasLength(2));expect(lesson.dialogue,isNotEmpty);expect(lesson.speakingTask,isNotEmpty);expect(lesson.questions,hasLength(5));
    for(final q in lesson.questions){expect(q.options,hasLength(4));expect(q.options.toSet(),hasLength(4));expect(q.answer,inInclusiveRange(0,3));expect(q.explanation,isNotEmpty);}
   }
  });
 });
}