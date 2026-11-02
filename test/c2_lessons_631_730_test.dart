import 'package:flutter_test/flutter_test.dart';
import 'package:turkishly/data/c2_course_data.dart';
import 'package:turkishly/data/course_catalog.dart';
void main(){
 group('C2 curriculum batch 631-730',(){
  final batch=C2CourseData.lessons.where((e)=>e.globalNumber>=631&&e.globalNumber<=730).toList();
  test('C2 total and new global lesson range',(){
   expect(C2CourseData.lessons,hasLength(780));
   expect(batch,hasLength(100));
   expect(batch.map((e)=>e.globalNumber).toSet(),Set<int>.from(List<int>.generate(100,(i)=>631+i)));
  });
  test('ten new units each contain ten catalog lessons',(){
   for(var n=22;n<=31;n++){
    final id='c2-u$n';
    final unit=CourseCatalog.units.firstWhere((e)=>e.id==id);
    expect(unit.level,'C2'); expect(unit.lessons,hasLength(10));
    for(var i=1;i<=10;i++){expect(C2CourseData.find(id,i),isNotNull,reason:'$id lesson $i');}
   }
  });
  test('every new lesson includes learning content and five four-choice questions',(){
   for(final lesson in batch){
    expect(lesson.title,isNotEmpty); expect(lesson.goal,isNotEmpty); expect(lesson.rule,isNotEmpty);
    expect(lesson.examples,hasLength(2)); expect(lesson.dialogue,isNotEmpty); expect(lesson.speakingTask,isNotEmpty);
    expect(lesson.questions,hasLength(5));
    for(final q in lesson.questions){expect(q.options,hasLength(4));expect(q.options.toSet(),hasLength(4));expect(q.answer,inInclusiveRange(0,3));expect(q.explanation,isNotEmpty);}
   }
  });
 });
}